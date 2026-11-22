def call(Map configMap){
    pipeline {
        agent {
            node {
                label 'Agent-1'
            }
        }
        environment {
            packageVersion=''
            // nexusURL='172.31.36.95:8081'
            // repositoryName="catalogue"
        }
        options {
            ansiColor('xterm')
            timeout(time: 30, unit: 'MINUTES')
            disableConcurrentBuilds()
        }
        parameters {
            booleanParam(name:'Deploy', defaultValue: true, description: "By default deploy is false while Developing CI")
        }
        stages {
            stage("Get Current Version"){
                steps {
                    script {
                        def packageJSON = readJSON file: "92-roboshop-CI-Appln-Code/${configMap.component}/package.json"
                        packageVersion= packageJSON.version
                        echo "Application version is : $packageVersion"
                    }
                } 
            }
            // stage("Install dependencies"){
            //     steps {
            //         sh """
            //             sudo dnf module disable nodejs -y
            //             sudo dnf module enable nodejs:18 -y 
            //             sudo dnf install nodejs -y 
            //             cd 92-roboshop-CI-Appln-Code/catalogue/
            //             echo "for npm to work we need to install nodejs first that y above we did"
            //             npm install 
            //         """
            //     } 
            // }
            stage("Install dependencies") {         //check whether version 18 is there or not if not download if present skip those commands 
                steps {
                    sh """
                        NODE_VERSION=\$(node --version 2>/dev/null || echo "not-installed")

                        if [[ "\$NODE_VERSION" == v18.* ]]; then
                            echo "Node.js 18 is already installed: \$NODE_VERSION"
                        else
                            echo "Installing Node.js 18..."

                            sudo dnf module disable nodejs -y
                            sudo dnf module enable nodejs:18 -y
                            sudo dnf install nodejs -y
                            sudo dnf install zip -y

                            node --version
                        fi

                        cd 92-roboshop-CI-Appln-Code/${configMap.component}/
                        npm install
                    """
                }
            }
            stage("Unit Testing"){
                steps {
                    echo "Unit tests run here"
                }
            }
            stage('Sonar Scanning') {
                steps {
                    withSonarQubeEnv('SonarQubeURL') {                      //SonarQubeURL -- this name should match the name configured in jenakins -- manage jenkins -- system -- SonarQube Servers -- name 
                        sh """
                            sonar-scanner \
                            -Dproject.settings=$WORKSPACE/92-roboshop-CI-Appln-Code/${configMap.component}/sonar-project.properties
                        """
                            //-Dproject.settings ==> Tells scanner which project properties file to read
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
                            ls -la
                            zip -q -r ${configMap.component}.zip ./* -x ".git" -x "*.zip"
                            ls -ltr 
                        """
                    }
            }
            stage("Publish Artifact") {
                steps {
                    sh """
                        cd 92-roboshop-CI-Appln-Code/${configMap.component}/
                    """
                    nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: pipelineGlobals.nexusURL(),
                    groupId: 'com.roboshop',
                    version: "${packageVersion}",
                    repository: "${configMap.component}",
                    credentialsId: 'nexus-login-credentials',       //created credentials in manage jenkins in jenkins dashboard
                    artifacts: [
                        [artifactId: "${configMap.component}",
                        classifier: '',
                        file: "92-roboshop-CI-Appln-Code/${configMap.component}/${configMap.component}.zip",
                        type: 'zip']
                    ]
                    )
                }
            }
            //ROBOSHOP_INFRA_CD_DEPLOY/${configMap.component}_deploy --> should be pipeline name in jenkins tool which needed to called 
            stage("Trigger CD pipeline For Deploy") {
                when {
                    expression {
                        params.Deploy == true   //or  params.Deploy 
                    }
                }
                steps {
                    script {
                        echo "Deploy value is: ${params.Deploy}"
                        
                        def buildParams = [
                            string(name:'Version', value: "${packageVersion}"),
                            string(name:'Environment', value: "dev"),
                            // string(name: 'Create', value: '${params.Deploy}')
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
                echo "All stages of CI process completed-Always"
                // deleteDir() 
            } 
            success {
                echo "All stages of CI process completed Successfully"
            }
            failure {
                echo "CI process Failed"
            }
        }
    }
}