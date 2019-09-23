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
        
    /*Still in the /var/lib/jenkins/nodeapp_test npm install to install dependencies on this jenkins workspace scm*/
    stage('Build') {
        node ('master') {
            sh "npm install"
        }
            
                        
    }
    
      stage('SonarQube Analysis') {
        node ('master') {
             def scannerHome = tool 'SonarQube';
             withSonarQubeEnv('SonarQube') { // If you have configured more than one global server connection, you can specify its name
             sh "${scannerHome}/bin/sonar-scanner"
            }
            
                        
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
                sh "docker push claudiols1979/nodeapp_test"

            } 
        }
        
                echo "Push docker build tag to DockerHub using ${BUILD_NUMBER}"
    }

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
    

       
    stage('Clone repository to AWS EC2') {
    /* Cloning the Repository to ec2 instance Workspace /home/jenkins */
                node ('aws-slave') {
                    checkout scm
        }
         
    }

    stage('Ansible install nodejs role') {
    /* Provision nodejs app role master */
                node ('master') {
                    sh "ansible-galaxy install geerlingguy.nodejs"
                    
        
                
            }
         
    }

    stage('Ansible install nodejs in aws-slave app_server') {
    /* Provision nodejs app in aws-slave */
                node ('master') {
                    sh "ansible-playbook /var/lib/jenkins/.ansible/roles/geerlingguy.nodejs/site.yml"
                    
        
                
            }
         
    }

    stage('Deploy to AWS EC2') {
    /* Running application in aws platform */
                node ('aws-slave') {
                sh "./scripts/build.sh"
                sh "./scripts/deliver.sh"
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh "./scripts/kill.sh"
        }
        
    }
}
