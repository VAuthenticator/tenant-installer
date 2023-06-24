import boto3
import uuid
import sys
import base64
import bcrypt
import os

isProduction = bool(os.getenv("IS_PRODUCITON"))
print(isProduction)


def dynamodbClient():
    dynamodb_endpoint = os.getenv('DYNAMO_DB_ENDPOINT')
    if dynamodb_endpoint is None:
        client = boto3.resource('dynamodb')
    else:
        client = boto3.resource('dynamodb', endpoint_url=dynamodb_endpoint)
    return client


def kmsClient():
    kms_endpoint = os.getenv('KMS_ENDPOINT')
    if kms_endpoint is None:
        client = boto3.client("kms")
    else:
        client = boto3.client('kms', endpoint_url=kms_endpoint)
    return client


dynamodb = dynamodbClient()
kms_client = kmsClient()


def store_account(user_name, account_table_name):
    password = str(uuid.uuid4()) if isProduction else "admin"
    print(f'default user password: {password}')

    table = dynamodb.Table(account_table_name)
    table.put_item(Item={
        "user_name": user_name,
        "password": pass_encoded(password),
        "phone": "",
        "birthDate": "",
        "locale": "en",
        "firstName": "Admin",
        "firstName": "Admin",
        "lastName": "",
        "email": user_name,
        "emailVerified": True,
        "enabled": True,
        "credentialsNonExpired": True,
        "accountNonLocked": True,
        "accountNonExpired": True,
        "authorities": set(["ROLE_USER", "VAUTHENTICATOR_ADMIN"])
    })


def store_roles(role_table_name):
    table = dynamodb.Table(role_table_name)
    table.put_item(Item={"role_name": "ROLE_USER", "description": "Generic user role"})
    table.put_item(Item={"role_name": "VAUTHENTICATOR_ADMIN", "description": "VAuthenticator admin role"})


def store_sso_client_applications(client_application_table_name):
    client_id = str(uuid.uuid4()) if isProduction else "vauthenticator-management-ui"
    print(f'client id: {client_id}')
    print(f'client id: {client_id}')

    client_secret = str(uuid.uuid4()) if isProduction else "secret"
    print(f'client secret: {client_secret}')
    print(f'client_id={client_id}&client_secret={client_secret}')

    table = dynamodb.Table(client_application_table_name)
    scopes = set(
        ["openid", "profile", "email", "admin:reset-password", "admin:key-reader", "admin:key-editor",
         "admin:mail-template-reader", "admin:mail-template-writer"])
    if isProduction:
        scopes.add("mfa:always")

    table.put_item(Item={
        "client_id": client_id,
        "client_secret": pass_encoded(client_secret),
        "scopes": scopes,
        "authorized_grant_types": set(["AUTHORIZATION_CODE"]),
        "web_server_redirect_uri": "http://local.management.vauthenticator.com:8080/login/oauth2/code/client",
        "authorities": set(["ROLE_USER", "VAUTHENTICATOR_ADMIN"]),
        "access_token_validity": 180,
        "refresh_token_validity": 3600,
        "auto_approve": True,
        "post_logout_redirect_uris": "http://local.management.vauthenticator.com:8080/secure/admin/index",
        "logout_uris": "http://local.management.vauthenticator.com:8080/logout",
    })


def store_client_applications(client_application_table_name):
    client_id = str(uuid.uuid4()) if isProduction else "admin"
    print(f'client id: {client_id}')

    client_secret = str(uuid.uuid4()) if isProduction else "secret"
    print(f'client secret: {client_secret}')
    print(f'client_id={client_id}&client_secret={client_secret}')

    table = dynamodb.Table(client_application_table_name)
    table.put_item(Item={
        "client_id": client_id,
        "client_secret": pass_encoded(client_secret),
        "scopes": set([
            "openid", "profile", "email",
            "admin:signup", "admin:welcome", "admin:mail-verify", "admin:reset-password",
            "admin:key-reader", "admin:key-editor",
            "admin:mail-template-reader", "admin:mail-template-writer",
            "mfa:always"
        ]),
    })


def pass_encoded(password):
    encode = str.encode(password)
    return bcrypt.hashpw(encode, bcrypt.gensalt(12)).decode()


if __name__ == '__main__':
    user_name = sys.argv[1]

    input_key_table_name = sys.argv[3]
    input_role_table_name = sys.argv[4]
    input_account_table_name = sys.argv[5]
    input_client_applications_table_name = sys.argv[6]

    store_roles(input_role_table_name)
    store_account(user_name, input_account_table_name)
    store_client_applications(input_client_applications_table_name)
    store_sso_client_applications(input_client_applications_table_name)
