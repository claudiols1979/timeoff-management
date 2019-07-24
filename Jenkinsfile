node {
    def app

    stage('Clone repository') {
        /* Cloning the Repository to our Workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image */

        app = docker.build("claudiols1979/nodeapp")
    }
        

    stage('Build') {
        
            sh "npm install"
        
                       
    }

    

    stage('Push image') {
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
                echo "Push Docker Build to DockerHub"
    }

    stage('deploy to prod')  {
        
            
                docker.image("claudiols1979/nodeapp_test:${env.BUILD_NUMBER}").inside('-p 3000:3000'){
                
            }
                sh "./scripts/build.sh"
                sh "./scripts/deliver.sh"
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh "./scripts/kill.sh"

        }
    }
