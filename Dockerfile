# Pull base image 
From tomcat:8-jre8 
COPY ./*.war /usr/local/tomcat/webapps
