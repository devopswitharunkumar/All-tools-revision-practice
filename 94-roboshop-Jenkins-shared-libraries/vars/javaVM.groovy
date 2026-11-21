def call(Map configMap) {
    pipeline {
        agent {
            node {
                label 'Agent-1'
            }
        }

        environment {
            packageVersion = ''
            // nexusURL='172.31.36.95:8081'
            // repositoryName="catalogue"
        }

        options {
            ansiColor('xterm')
            timeout(time: 30, unit: 'MINUTES')
            disableConcurrentBuilds()
        }

        parameters {
            booleanParam(name: 'Deploy', defaultValue: true, description: 'Trigger CD pipeline after successful CI')
        }

        stages {

            stage("Get Current Version") {
                steps {
                    script {
                        def pom = readMavenPom(
                            file: "92-roboshop-CI-Appln-Code/${configMap.component}/pom.xml"
                        )

                        packageVersion = pom.version

                        echo "Shipping Application version is: ${packageVersion}"
                    }
                }
            }

            stage("Install Dependencies") {
                steps {
                    sh """
                        echo "Checking Java version..."

                        if ! command -v java >/dev/null 2>&1; then
                            echo "Java is not installed. Installing JDK 17..."
                            sudo dnf install java-17-openjdk-devel -y
                        fi

                        java -version

                        echo "Checking Maven..."

                        if ! command -v mvn >/dev/null 2>&1; then
                            echo "Maven is not installed. Installing Maven..."
                            sudo dnf install maven -y
                        fi

                        mvn -version

                        cd 92-roboshop-CI-Appln-Code/${configMap.component}/

                        echo "Downloading Maven dependencies..."
                        mvn dependency:resolve
                    """
                }
            }

            stage("Unit Testing") {
                steps {
                    sh """
                        cd 92-roboshop-CI-Appln-Code/${configMap.component}/

                        echo "Running Java unit tests..."
                        mvn test
                    """
                }
            }

            stage('Sonar Scanning') {
                steps {
                    withSonarQubeEnv('SonarQubeURL') {
                        sh """
                            cd 92-roboshop-CI-Appln-Code/${configMap.component}/

                            sonar-scanner \\
                            -Dproject.settings=\$WORKSPACE/92-roboshop-CI-Appln-Code/${configMap.component}/sonar-project.properties
                        """
                    }
                }
            }

            stage('Quality Gate') {
                steps {
                    timeout(time: 15, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }

            stage("Build") {
                steps {
                    sh """
                        cd 92-roboshop-CI-Appln-Code/${configMap.component}/

                        echo "Building Java application..."

                        mvn package -DskipTests

                        echo "Generated JAR files:"
                        ls -lh target/*.jar

                        echo "Creating ZIP package..."

                        zip -j -q ${configMap.component}.zip target/*.jar

                        ls -lh ${configMap.component}.zip
                    """
                }
            }

            stage("Publish Artifact") {
                steps {
                    nexusArtifactUploader(
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        nexusUrl: pipelineGlobals.nexusURL(),
                        groupId: 'com.roboshop',
                        version: "${packageVersion}",
                        repository: "${configMap.component}",
                        credentialsId: 'nexus-login-credentials',
                        artifacts: [
                            [
                                artifactId: "${configMap.component}",
                                classifier: '',
                                file: "92-roboshop-CI-Appln-Code/${configMap.component}/${configMap.component}.zip",
                                type: 'zip'
                            ]
                        ]
                    )
                }
            }

            stage("Trigger CD Pipeline For Deploy") {
                when {
                    expression {
                        params.Deploy
                    }
                }

                steps {
                    script {
                        echo "Deploy value is: ${params.Deploy}"

                        def buildParams = [
                            string(name: 'Version', value: "${packageVersion}"),
                            string(name: 'Environment', value: 'dev'),
                            booleanParam(name: 'Create', value: true)
                        ]

                        build job: "../${configMap.component}-deploy",
                            wait: true,
                            parameters: buildParams
                    }
                }
            }
        }

        post {
            always {
                echo "All stages of Java CI process completed - Always"
            }

            success {
                echo "Java CI process completed successfully"
            }

            failure {
                echo "Java CI process failed"
            }
        }
    }
}