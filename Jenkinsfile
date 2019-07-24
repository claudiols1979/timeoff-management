node {
    def app
     
    stage('Clone repository') {        
        /* Cloning the Repository to our Workspace */
        node ('centos') {
            checkout scm
        }

        
    }

    stage('Build custom image') {
        /* This builds the actual image */
        node ('centos') {
            app = docker.build("claudiols1979/nodeapp")
        }
        
    }
        

    stage('Build') {
        node ('centos') {
            sh "npm install"
        }
            
                        
    }
    

    stage('Push image to dockerhub') {
        node ('centos') {
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

    stage('Deploy to staging env')  {
        node ('centos') {
                docker.image("claudiols1979/nodeapp_test:${env.BUILD_NUMBER}").inside('-p 3000:3000'){
                
            }
                sh "./scripts/build.sh"
                sh "./scripts/deliver.sh"
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh "./scripts/kill.sh"
        }
          
            

    }
    

    stage('Ansible orchestrate AWS') {
    /* ssh into ansible.local and provsion nodejs to aws ec2 instance */
                node ('centos') {
                    sh 'sshpass -p "ansible" ssh -v -o StrictHostKeyChecking=no ansible@ansible.local && "cd /home/ansible/.ansible/roles/geerlingguy.nodejs" && "ansible-playbook site.yml"'
        
                
            }
         
    }
     
    stage('Clone repository to AWS EC2') {
    /* Cloning the Repository to ec2 instance Workspace /var/lib/jenkins */
                node ('aws') {
                    checkout scm
        }
         
    }

    stage('Deploy to AWS EC2') {
    /* Cloning the Repository to ec2 instance Workspace /var/lib/jenkins */
                node ('aws') {
                sh "./scripts/build.sh"
                sh "./scripts/deliver.sh"
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh "./scripts/kill.sh"
        }
        
    }
}