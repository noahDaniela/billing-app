FROM nginx:1.26.2-alpine-slim

VOLUME /tmp

#Install application on nginx server
RUN rm -rf /usr/share/nginx/html/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY dist/billingApp /usr/share/nginx/html
COPY mime.types /etc/nginx/mime.types

#install backend
#OpenJDK 27
RUN apk --no-cache add openjdk17-jre

#Environment variables
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk17
ENV PATH $JAVA_HOME/bin:$PATH

RUN java -version


#install microservice
ENV JAVA_OPTS=""
ARG JAR_FILE
ADD ${JAR_FILE} app.jar 

#copy the initial script
COPY appshell.sh appshell.sh

#80 defined port for the frontend and 7080 port for the backend
EXPOSE 80 7080

ENTRYPOINT ["sh", "/appshell.sh"]
