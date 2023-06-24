# local-environment

Make sure to have on the root project a folder called tenant-installer with teh content on the relative version of the [tenant-installer project](https://github.com/VAuthenticator/tenant-installer).
The project is composed by a docker-compose yml designed to provide you all the basic infrastructure to start
vauthenticator app in local.

# local host config

- add on your local hosts file the following configurations

    ```
    127.0.0.1   local.assets.vauthenticator.com
    127.0.0.1   local.assets.management.vauthenticator.com
    127.0.0.1   local.api.vauthenticator.com
    127.0.0.1   local.management.vauthenticator.com
    ```
- make sure that you have a clean installation 
  - docker-compose down  
  - docker-compose rm  
  - 
- create an .env file like this:
  ````
  ACCOUNT_ID=xxxx
  VAUTHENTICATOR_BUCKET=xxxx
  TF_STATE_BUCKET=xxxx
  MASTER_KEY=will be available on the aws console or in the terraform resource apply console log 
  AWS_REGION=xxxx
  ````
- run the setup.sh
  ```
  After that the setup.sh is executed in the AWS console on KMS section you can see the Key ID of your key. 
  It is the master key to insert in the configuration
  file configuration/Fvauthenticator.yml.
  ```
  
  - configure your app
    - Property name is: `key.master-key: ${A_MASTER_KEY}`
    - Property name is: `: ${VAUTHENTICATOR_DOCUMENTS_BUCKET}`
    - create the IAM key and set up the required environment variables like below
      ```
      AWS_ACCESS_KEY_ID=xxxx
      AWS_SECRET_ACCESS_KEY=xxxx
      AWS_REGION=xxxx
      ```
  
- run the init.sh: After that the init.sh is executed you will have configured.
  - default admin client application for M2M:
      - username: admin
      - password: secret 
  - default client application for configure the sso login for the admin ui:
      - username: vauthenticator-management-ui
      - password: secret 
  - default management ui client application 
    - link:  http://local.management.vauthenticator.com:8080/secure/admin/index
    - username: admin@email.com
    - password: admin


- to reset all the environment use the ```./dispose.sh``` script