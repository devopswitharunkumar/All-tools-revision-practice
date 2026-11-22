//In python module we are using Jenkins Build Number as Application version because we dont have Application version variable 


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
                // string(name: 'Version', defaultValue: '', description: 'What is the Artifact Version?')
                // string(name: 'Environment', defaultValue: 'dev', description: 'What is the Environment?')
                // choice(name: 'action', choices: ['Apply', 'Destroy'], description: 'Select Terraform action')
                booleanParam(name:'Deploy', defaultValue: true, description: "By default deploy is false while Developing CI")
            }
        stages {
            stage("Get Current Version") {
                steps {
                    script {
                        env.PACKAGE_VERSION = "${env.BUILD_NUMBER}"

                        // Use Jenkins build number as Python artifact version
                        echo "Jenkins Build Number: ${env.BUILD_NUMBER}"
                        echo "Payment Application Version: ${env.PACKAGE_VERSION}"
                    }
                }
            }  
            stage("Install dependencies") {         //check whether version 18 is there or not if not download if present skip those commands 
                steps {
                    sh """
                        echo "Checking Python version..."
                        
                        if ! command -v python3.9 >/dev/null 2>&1; then
                            echo "Installing Python 3..."
                            sudo dnf install python3.9 -y
                        fi

                        echo "Checking GCC..."

                        if ! command -v gcc >/dev/null 2>&1; then
                            sudo dnf install gcc -y
                        fi

                        echo "Checking Python development packages..."

                        sudo dnf install python3-devel -y

                        python3.9 --version
                        pip3.9 --version

                        cd 92-roboshop-CI-Appln-Code/${configMap.component}/

                        python3.9 -m venv .venv

                        source .venv/bin/activate

                        echo "Installing Python application dependencies..."

                        python -m pip install -q -r requirements.txt
                    """
                }
            }
            //-q --> quiet mode -- suppresses the dependencies console print & -qq --> more suppress 
            stage("Unit Testing") {
                steps {
                    sh """
                        cd 92-roboshop-CI-Appln-Code/${configMap.component}/

                        source .venv/bin/activate

                        if [ -d tests ]; then
                            echo "Running Python unit tests..."

                            python -m pip install -q pytest
                            python -m pytest tests/
                        else
                            echo "No test cases found. Skipping unit tests."
                        fi
                    """
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

                            echo "Preparing Python application package..."
                            ls -la
                            zip -q -r ${configMap.component}.zip . -x ".git/*" "*.zip" ".venv/*" ".scannerwork/*" "__pycache__/*" "*.pyc"                            

                            echo "Generated artifact:"
                            ls -lh ${configMap.component}.zip
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
                    version: "${env.packageVersion}",
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
                        params.Deploy  //or  params.Deploy == true 
                    }
                }
                steps {
                    script {
                        echo "Deploy value is: ${params.Deploy}"
                        
                        def buildParams = [
                            string(name:'Version', value: "${env.PACKAGE_VERSION}"),
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