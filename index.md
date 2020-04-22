# **Amenity On-Prem Setup**

### Hardware Requirements

In order to successfully install the Amenity on-prem base solution, ensure that you have the following available on a Linux machine:
* 32+ GB RAM
* 8+-core CPU
* An available communication port (e.g., 9090)
* An access key and secret key provided by Amenity
* `sudo` access to your machine

---

### Software Requirements

* [Docker 18+](https://docs.docker.com/install)
* [`docker-compose` 1.25.1-rc1+](https://github.com/docker/compose/releases) (format 3.7+)
* [`pip3`](https://pip.pypa.io/en/stable/installing)
* [AWS Command Line Interface (CLI)](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* User added to the docker group
  ```bash
  sudo usermod -aG docker $USER
  ```

---

### Setup

The installation steps outlined in Setup below assumes the following software is installed and properly configured:
* Run `aws configure` and it will prompt your four times for information.
  * Input the access key provided by Amenity
  * Input the secret key provided by Amenity
  * Input `us-east-1` for the default region
  * The default output can remain `None`
* Run `$(aws ecr get-login --no-include-email --region us-east-1)`
  * The output should end with `Login Succeeded`
* Use one of the following commands to download a `docker-compose.yml` file depending on whether or not you need a security layer.
  * _HTTP_
    ```bash
    curl -L -o docker-compose.yml https://github.com/amenityllc/amenity.github.io/releases/download/1.0/docker-compose.yml
    ```
  * _HTTPS_
    ```bash
    curl -L -o docker-compose.yml https://github.com/amenityllc/amenity.github.io/releases/download/1.0/docker-compose-ssl.yml
    ```
    **NOTE**: Amenity does not provide security credentials. You must place your certificate and key files in the `/cert` folder.
* Run `docker-compose up` to download and run the engine and gateway.

---

### Testing

To test your installation is properly running, run the following command:
* _HTTP_
  ```bash
  curl -X GET http://localhost:9090/api/v1/articles/analyzeText
  ```

The output should resemble the following format:
```bash
{
  "test": "success"
}
```

---

### Custom Model Update

By default, the engine ships with Amenity's base image. This step is only necessary if Amenity provided a separate model bundle file.

Adding a model or updating one built-in can be done without re-downloading the engine or gateway. Simply place a model bundle (`zip`) in an empty folder and mount the folder to the docker container.

For example,
```
docker run -d -e JAVA_OPTS="-Xmx16Gb" -p 8080:8080  -v path/to/active/model/directoy:/data/models  919287335240.dkr.ecr.us-east-1.amazonaws.com/on-pr-saeng-14u6p6wnbgv10:latest
```
**NOTE**: The engine only supports a single model bundle and will use the first alphanumeric zip found.

---

### End Points

The following end points are the different ways in which one can interact with the gateway and engine.
* _GET_
  * `/version` returns the version of the gateway and any model attached to the engine.
    ```bash
    curl -X GET http://localhost:9090/version
    ```
  * `/api/v1/articles/analyzeText` runs a test call to the engine and returns whether or not the test succeeded or a possible cause of failure.
    ```bash
    curl -X GET http://localhost:9090/api/v1/articles/analyzeText
    ```
* _POST_
  * `/api/v1/articles/analyzeText` tests whether or not the gateway properly receives data and runs a test call to the engine. This endpoint returns whether or not the tests succeeded or a possible cause of failure.
    ```bash
    curl -X POST -d "this can contain any text" http://localhost:9090/api/v1/articles/analyzeText
    ```
  * `/api/v1/articles/${DOCUMENT_ID}/analyzeText` calls a specific set of pre- and post-processing functions designed for a specific use-case.
    ```bash
    curl -X POST -H "Content-type: ${INPUT_MIME_TYPE}" -H "Accept: ${OUTPUT_MIME_TYPE} --data-binary @path/to/input/file.ext http://localhost:9090/api/v1/articles/${DOCUMENT_ID}/analyzeText
    ```
    * `${INPUT_MIME_TYPE}` and `${OUTPUT_MIME_TYPE}` are pre-defined (e.g., `application/xml`)
    * `${DOCUMENT_ID}` will be provided by Amenity

---
