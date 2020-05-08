pipeline {
    agent {
        label "master"
    }
    tools {
        // Note: this should match with the tool name configured in your jenkins instance (JENKINS_URL/configureTools/)
        maven "MC-1"
    }

    stages {
        stage("clone code") {
            steps {
                script {
                    // Let's clone the source
                    git 'https://github.com/devops5511996/hello-world.git';
                }
            }
        }
        stage("mvn build") {
            steps {
                script {
                  def mvnHome = tool name: 'MC-1', type: 'maven'
                  sh "${mvnHome}/bin/mvn clean install package"                    
                }
            }
        }
        stage("publish to nexus") {
            steps {
                script {
                    nexusArtifactUploader artifacts: [
                      [
                        artifactId: 'hello-world',
                        classifier: '',
                        file: 'webapp/target/webapp.war',
                        type: 'war']
                    ],
                      credentialsId: 'nexus_key',
                      groupId: 'hello-world',
                      nexusUrl: '34.219.45.178:8081',
                      nexusVersion: 'nexus3',
                      protocol: 'http',
                      repository: 'maven-snapshots',
                      version: '1.0-SNAPSHOT'              
                    }
                }
            }
        stage("Retrieving From Nexus") {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'ansible_server'
                    remote.host = '3.82.232.208'
                    remote.user = 'ubuntu'
                    remote.password = 'devops@1996'
                    remote.allowAnyHosts = true
  
                    sshCommand remote: remote, command: "cd /home/ubuntu/"
                    sshCommand remote: remote, command: " wget http://34.219.45.178:8081/repository/maven-snapshots/hello-world/hello-world/1.0-SNAPSHOT/hello-world-1.0-20200507.183101-1.war "
                }
            }
        }
        stage("Publishing Artifacts") {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'ansible_server'
                    remote.host = '3.82.232.208'
                    remote.user = 'ubuntu'
                    remote.password = 'devops@1996'
                    remote.allowAnyHosts = true
  
                    sshCommand remote: remote, command: "cd /home/ubuntu/"
                    sshCommand remote: remote, command: "sudo mv `ls -rt /home/ubuntu/*.war | tail -1` /home/ubuntu/artifacts/"
                    sshCommand remote: remote, command: "ansible-playbook  /home/ubuntu/copyfile.yml "
                    sshCommand remote: remote, command: "sudo rm -rf /home/ubuntu/artifacts/*"
                }
            }
        }
        stage("deploying to Tomcat") {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'tomcat_server'
                    remote.host = '52.202.124.0'
                    remote.user = 'ubuntu'
                    remote.password = 'devops@1996'
                    remote.allowAnyHosts = true
  
                    sshCommand remote: remote, command: "cd /home/ubuntu/"
                    sshCommand remote: remote, command: "sudo mv `ls -rt /home/ubuntu/artifacts/*.war | tail -1` /home/ubuntu/webapp.war"
                    sshCommand remote: remote, command: "sudo cp `ls -rt /home/ubuntu/webapp.war | tail -1` /usr/share/tomcat/webapps/"
                    sshCommand remote: remote, command: "sudo rm -rf /home/ubuntu/artifacts"
                    
                }
            }
        }
        stage("Building docker image") {
            steps {
                script {
                    def remote = [:]
                    remote.name = 'tomcat_server'
                    remote.host = '52.202.124.0'
                    remote.user = 'ubuntu'
                    remote.password = 'devops@1996'
                    remote.allowAnyHosts = true
  
                    sshCommand remote: remote, command: "cd /home/ubuntu/"
                    sshPut remote: remote, from: '/var/lib/jenkins/workspace/Hello-World/Dockerfile', into: '/home/ubuntu'
                    sshCommand remote: remote, command: "sudo docker build -t devproject ."
                    sshCommand remote: remote, command: "sudo docker tag devproject saikalyan551/devproject:latest"
                    sshCommand remote: remote, command: "sudo docker login"
                    sshCommand remote: remote, command: "sudo docker push saikalyan551/devproject:latest"
                    sshCommand remote: remote, command: "sudo docker rmi devproject saikalyan551/devproject:latest"
                    sshCommand remote: remote, command: "sudo rm -rf webapp.war"
                    
                    
                }
            }
        }

        
    }
}
