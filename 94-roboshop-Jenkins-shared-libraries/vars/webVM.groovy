
def call(Map configMap) {
    pipeline {
        agent {
            node {
                label 'Agent-1'
            }
        }
        options {
            ansiColor('xterm')
            timeout(time: 30, unit: 'MINUTES')
            disableConcurrentBuilds()
        }

        parameters {
            booleanParam(name: 'Deploy', defaultValue: true, description: 'By default deploy is false while developing CI')
        }

        stages {
            stage("Get Current Version") {
                steps {
                    script {
                        env.PACKAGE_VERSION = env.BUILD_NUMBER.toString()

                        echo "Jenkins Build Number: ${env.BUILD_NUMBER}"
                        echo "Web Application Version: ${env.PACKAGE_VERSION}"
                    }
                }
            }

            stage("Validate Web Source Code") {
                steps {
                    sh """
                        cd 92-roboshop-CI-Appln-Code/${configMap.component}/

                        echo "Checking Web frontend files..."

                        ls -la

                        if [ ! -f index.html ]; then
                            echo "ERROR: index.html not found!"
                            exit 1
                        fi

                        echo "Web source validation completed."
                    """
                }
            }

            stage('Sonar Scanning') {
                steps {
                    withSonarQubeEnv('SonarQubeURL') {
                        sh """
                            sonar-scanner \
                            -Dproject.settings=$WORKSPACE/92-roboshop-CI-Appln-Code/${configMap.component}/sonar-project.properties
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

                        echo "Preparing Web application package..."

                        zip -q -r ${configMap.component}.zip . -x ".git/*" "*.zip" ".scannerwork/*"

                        echo "Generated Web artifact:"
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
                        version: "${env.PACKAGE_VERSION}",
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

            stage("Trigger CD pipeline For Deploy") {
                when {
                    expression {
                        params.Deploy
                    }
                }

                steps {
                    script {
                        echo "Deploy value is: ${params.Deploy}"

                        def buildParams = [
                            string(name: 'Version', value: "${env.PACKAGE_VERSION}"),
                            string(name: 'Environment', value: 'dev'),
                            string(name: 'action', value: 'Apply')
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
                echo "All stages of Web CI process completed - Always"
            }

            success {
                echo "Web CI process completed successfully"
            }

            failure {
                echo "Web CI process failed"
            }
        }
    }
}
