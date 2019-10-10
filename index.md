# Amenity On-Prem Setup #

In order to successfully install the Amenity on prem base solution, ensure that you have: 
* 16 GB RAM or more on your machine
* An access key and secret key provided by Amenity  
* `sudo` access to your machine

***
*Software prerequisite:*
--
* Docker 18 or above (https://docs.docker.com/install)
* `docker-compose` 3.7 or above (https://docs.docker.com/compose/install)
* `pip3` installed (https://pip.pypa.io/en/stable/installing)
* AWS command Line Interface (CLI) tool installed (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* User added to the docker group (`sudo usermod -a -G docker $USER`)


##### Verify docker is setup correctly 
* Login as a non-root user and run the next command `docker run hello-world` 
to verify it returns with no errors

# Setup #

* Run `aws configure`
    * Provide the access key
    * Provide the secret key 
    * Set region as `us-east-1`
    * Default output can remain `None`
* Run `$(aws ecr get-login --no-include-email --region us-east-1)`
  * You should see `Login Succeeded` after running this command

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
 To serve the endpoint with SSL you must place your certificate and key in the `certs` folder. Check the `volume` section in the `docker-compose.yml` file. 
 The certificate and key are passed to the container via the `GUNICORN_CMD_ARGS` environment variable.
```
curl -L -o docker-compose.yml https://github.com/amenityllc/amenity.github.io/releases/download/1.0/docker-compose-ssl.yml
docker-compose up
``` 
---
# Custom Model Update #
In order to preload a custom model, you must put the model bundle zip file in a folder and mount the folder to the container and a script will process the file on startup. 

In case there are multiple zip files in the mount folder, we will only use the first one (alphabetical order). 

If the folder does not exist or does not contain a zip file, the startup script will continue with the included base model.   

An example of how to start the engine with a mounted folder (containing a model file) is as follows: 
```
docker run -d -e JAVA_OPTS="-Xmx16Gb" -p 8080:8080  -v /local/path/to/models/directoy:/data/models  919287335240.dkr.ecr.us-east-1.amazonaws.com/on-pr-saeng-14u6p6wnbgv10:latest
```
   

# Testing #
*HTTP:*
--
```
curl -X GET http://localhost:9090/version --verbose
```
***
*HTTPS:*
--
```
curl -X GET https://localhost:9090/version --verbose
```
