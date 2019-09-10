***Amenity On Prem setup*** 

In order to install the Amenity on prem base solution, make sure that you have: 
* a machine with 16 GB RAM or more
* you have an access key and secret key provided by Amenity  
* sudo access to your machine

*Software prerequisite:*
* Docker 18 or above (https://download.docker.com/)
* Docker-compose 3.7 or above (https://docs.docker.com/compose/install/)
* pip3 installed (https://pip.pypa.io/en/stable/)
* aws cli tool installed (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* user added to the docker group (sudo usermod -a -G docker $USER)


##### Verify docker is setup correctly 
* login with non root user and run the next command  `docker run hello-world` 
see if it returns without errors

## Setup

* run `aws configure`
    * provide the access key
    * provide the secret key 
    * set region as `us-east-1`
    * default output can remain `None`
* run `$(aws ecr get-login --no-include-email --region us-east-1)`
  * you should see `Login Succeeded` after running this command
* 

***
*HTTP:*
--
```
curl -L -o docker-compose.yml https://github.com/amenityllc/amenity.github.io/releases/download/1.0/docker-compose.yml
docker-compose up
```    
***
*HTTPS:*
--
 To serve the endpoint with SSL you must place your certificate and key in the `certs` folder. Checkout the `volume` section in the `docker-compose.yml` file. 
 The certificate and key are passed to the container via `GUNICORN_CMD_ARGS` envionment variable.
```
curl -L -o docker-compose.yml https://github.com/amenityllc/amenity.github.io/releases/download/1.0/docker-compose-ssl.yml
docker-compose up
``` 
---
# Custom Model update #
In order to preload a custom model to the container, you'll have to put the model bundle zip in a folder and mount it to the container. a ststup script will installed the model zip inside the container. 

in case there is multiple zip files in the mount folder we will peek only the first one (alphabetic order). 

if the folder is not exist or not containing any zip file, the startup scrit will continue to startup the server.   

in order to load the custom model: 
```
docker run -d -e JAVA_OPTS="-Xmx16Gb" -p 8080:8080  -v /local/path/to/models/directoy:/data/models  919287335240.dkr.ecr.us-east-1.amazonaws.com/on-pr-saeng-14u6p6wnbgv10:latest
```
   

##### Testing 
*HTTP:*
--
```
curl -L -o 1001.xml https://github.com/amenityllc/a,emotu/github.io/releases/download/1.0/1001.xml
curl -X POST -d @1001.xml http://localhost:9090/api/v1/articles/000/000/analyzeText --verbose
```
***
*HTTPS:*
--
```
curl -L -o 1001.xml https://github.com/amenityllc/amenity.github.io/releases/download/1.0/1001.xml
curl -X POST -d @1001.xml https://localhost:9443/api/v1/articles/000/000/analyzeText --verbose
```

