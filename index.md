***Amenity Docker Compose setup*** 

In order to install Amenity docker base solution make sure that you have: 
* machine with 16 GB ram or above
* you have access key + secret key provided by Amenity  


*Software prerequisite:*
* Docker 18 or above (https://download.docker.com/)
* Docker-compose 3.7 or above (https://docs.docker.com/compose/install/)
* pip3 installed(https://pip.pypa.io/en/stable/)
* aws cli tool installed(`pip3 install awscli --upgrade --user`)
   
***


##### Setup

* run `aws configure`
    * provide the access key and the secret 
    * set region as `us-east-1`
    * default output can remain `None`
* run `$(aws ecr get-login --no-include-email --region us-east-1)`
  * you should see `Login Succeeded` after running this command
* `curl -L -o docker-compose.yml https://my.url/composefile && docker-compose up`  

