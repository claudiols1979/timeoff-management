node {

    def app    
     
    stage('Clone repository') {        
        /* Cloning the Repository to our Workspace */
        node ('master') {
            checkout scm
        }        
    }

    stage('Build custom image') {
        /* This builds the actual image */
        node ('master') {
            app = docker.build("claudiols1979/nodeapp")
        }        
    }
        
    /*Still in the /var/lib/jenkins/workspace npm install to install dependencies on this jenkins workspace scm*/
    stage('Build') {
        node ('master') {            
            /*sh "npm install"*/
           withNPM(npmrcConfig: 'c91e9113-9c37-4187-9782-8a3f87af0352') {
                sh 'npm install'
            /*env.NODEJS_HOME = "${tool 'nodejs'}"
            env.PATH="${env.NODEJS_HOME};${env.PATH}"*/
            // sh 'export PATH=$PATH:/home/claudio/.nvm/versions/node/v14.15.4/bin/npm'
            // sh 'npm install'
            }
        }                        
    }
    /*sonarqube token 162e6c51cb9e7ecf7a5335fd6e22a2336a6bdf9c*/
    stage('SonarQube Analysis') {
        node ('master') {
              sh "/opt/sonar-scanner/bin/sonar-scanner -Dsonar.login=admin -Dsonar.password=sILVANa1996!+ -Dsonar.host.url=http://192.168.0.107:9000 -Dsonar.projectName=timeoff-management -Dsonar.projectVersion=1.0 -Dsonar.projectKey=timeoff-management:app -Dsonar.sources=. -Dsonar.projectBaseDir=/var/lib/jenkins/workspace/timeoff-management@2"
            }                       
    }
    stage('Upload artifactory - Nexus 3') {
        node ('master') {
            //   sh "cd .."
            //   zip zipFile: 'timeoff-management@2.zip', archive: false, dir: 'timeoff-management@2'
            //   archiveArtifacts artifacts: 'timeoff-management@2.zip', fingerprint: true
            sh "cd /var/lib/jenkins/workspace/timeoff-management@2;sudo rm -rf timeoff-management@2.zip"
            //zip zipFile: 'timeoff-management@2.zip', archive: false, dir: '/var/lib/jenkins/workspace/timeoff-management@2'
            sh "sudo apt install zip -y"
            sh "zip -r timeoff-management@2.zip /var/lib/jenkins/workspace/timeoff-management@2"
            archiveArtifacts artifacts: 'timeoff-management@2.zip', fingerprint: true
            // sh "cd /var/lib/jenkins/workspace/timeoff-management@2;curl -v -u admin:sILVANa1996!+ --upload-file timeoff-management@2.zip http://192.168.0.107:8081/repository/timeoff-management/timeoff-management@2.zip"
            sh "cd /var/lib/jenkins/workspace/timeoff-management@2;curl -v -u admin:sILVANa1996!+ --upload-file timeoff-management@2.zip http%3A%2F%2F192.168.0.107%3A8081%2Frepository%2Ftimeoff-management%2Ftimeoff-management%402.zip"
            //sh "curl -v -u admin:admin --upload-file timeoff-management@2.zip http://192.168.0.118:8081/repository/devops-timeoff-management-webapp/timeoff-management@2.zip"
              }
            }
    stage('Push image to dockerhub') {
        node ('master') {
            /* 
			You would need to first register with DockerHub before you can push images to your account
		*/
        /* docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
            
        } */
            withDockerRegistry([ credentialsId: "docker-hub", url: "" ]) {
                sh "docker tag claudiols1979/nodeapp:latest claudiols1979/nodeapp_test:${env.BUILD_NUMBER}"
                sh "docker push claudiols1979/nodeapp_test:${env.BUILD_NUMBER}"

            } 
        }
        
                echo "Push docker build tag to DockerHub using ${BUILD_NUMBER}"
    }
    /*STAGE ANSIBLE TO CHECK HOST*/
    /*Image already built with all dependencies in stage build*/
    stage('Deploy to staging env')  {
        node ('master') {
                docker.image("claudiols1979/nodeapp_test:${env.BUILD_NUMBER}").inside('-p 3000:3000'){
                
            }
                
                sh "./scripts/build.sh"
                sh "./scripts/deliver.sh"
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh "./scripts/kill.sh"
        }
          
            

    }
    
    
    /*HERE WE WANT TO INGTEGRATE NEXUS SO WE CAN DOWNLOAD THE IMAGE FROM NEXUS TO AWS EC2*/
       
    /*
        stage('Clone repository to AWS EC2') {*/
    /* Cloning the Repository to ec2 instance Workspace /home/jenkins */
        /*        node ('aws-slave') {
                    checkout scm
        }
         
    }
    */

    // stage('Ansible install nodejs role') {
     /* Provision nodejs app role master */
    //             node ('master') {
    //                 sh "ansible-galaxy install geerlingguy.nodejs"
                    
        
                
    //         }
         
    // }
    
   /* stage('Deploy nodejs using ansible in AWS EC2 instance') {
        ansibleTower(
            towerServer: 'Ansible Tower',
            templateType: 'job',
            jobTemplate: 'deploy nodejs',
            importTowerLogs: true,
            inventory: 'ec2-web-server',
            verbose: true,
            credential: 'ec2-app-server',
            async: false
            )
        }

    */
    
    

    // stage('Ansible install nodejs in aws-slave app_server') {
    // /* Provision nodejs app in aws-slave */
    //             node ('master') {
    //                 sh "ansible-playbook /var/lib/jenkins/.ansible/roles/geerlingguy.nodejs/site.yml"
                    
        
                
    //         }
         
    // }
    

    /*stage('Deploy Application to AWS EC2') {*/
    /* Running application in aws platform */
            /*    node ('aws-slave') {
                sh "./scripts/build.sh"
                sh "./scripts/deliver.sh"
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh "./scripts/kill.sh"
            }
        
        }
        */
    

      }


    
    

