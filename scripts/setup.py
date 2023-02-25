import boto3
import uuid
import sys
import base64
import bcrypt
import os

def dynamodbClient():
    dynamodb_endpoint = os.getenv('DYNAMO_DB_ENDPOINT')
    if dynamodb_endpoint is None:
        client= boto3.resource('dynamodb')
    else:
        client = boto3.resource('dynamodb', endpoint_url=dynamodb_endpoint)
    return client
def kmsClient():
    kms_endpoint = os.getenv('KMS_ENDPOINT')
    if kms_endpoint is None:
        client= boto3.client("kms")
    else:
        client = boto3.client('kms', endpoint_url=kms_endpoint)
    return client



dynamodb = dynamodbClient()
kms_client = kmsClient()


def store_account(user_name, account_table_name, account_role_table_name):
    password = str(uuid.uuid4())
    print(f'default user password: {password}')

    table = dynamodb.Table(account_table_name)
    table.put_item(Item={
        "user_name": user_name,
        "password": pass_encoded(password),
        "phone": "",
        "locale": "en",
        "firstName": "Admin",
        "lastName": "",
        "email": user_name,
        "emailVerified": True,
        "enabled": True,
        "credentialsNonExpired": False,
        "accountNonLocked": True,
        "accountNonExpired": True
    })
    table = dynamodb.Table(account_role_table_name)
    table.put_item(Item={"role_name": "VAUTHENTICATOR_ADMIN", "user_name": user_name})


def store_roles(role_table_name):
    table = dynamodb.Table(role_table_name)
    table.put_item(Item={"role_name": "VAUTHENTICATOR_ADMIN", "description": "VAuthenticator admin role"})


def store_client_applications(client_application_table_name):
    client_id = str(uuid.uuid4())
    print(f'client id: {client_id}')

    client_secret = str(uuid.uuid4())
    print(f'client secret: {client_secret}')

    table = dynamodb.Table(client_application_table_name)
    table.put_item(Item={
        "client_id": client_id,
        "client_secret": pass_encoded(client_secret),
        "scopes": [
            "openid", "profile", "email",
            "admin:signup", "admin:welcome", "admin:mail-verify", "admin:reset-password",
            "admin:key-reader", "admin:key-editor",
            "mfa:always"
        ],
        "authorized_grant_types": ["CLIENT_CREDENTIALS"],
        "web_server_redirect_uri": "",
        "authorities": [],
        "access_token_validity": 180,
        "refresh_token_validity": 3600,
        "auto_approve": True,
        "post_logout_redirect_uris": "",
        "logout_uris": "",
    })


def store_key(key_table_name, master_key):
    table = dynamodb.Table(key_table_name)
    key_pair = kms_client.generate_data_key_pair(KeyId=master_key, KeyPairSpec='RSA_2048')
    table.put_item(Item={
        "master_key_id": key_pair["KeyId"],
        "key_id": str(uuid.uuid4()),
        "encrypted_private_key": base64.b64encode(key_pair["PrivateKeyCiphertextBlob"]).decode(),
        "public_key": base64.b64encode(key_pair["PublicKey"]).decode(),
        "key_purpose": "SIGNATURE",
        "key_type": "ASYMMETRIC",
        "enabled": True
    })


def pass_encoded(password):
    encode = str.encode(password)
    return bcrypt.hashpw(encode, bcrypt.gensalt(12)).decode()


if __name__ == '__main__':
    user_name = sys.argv[1]
    input_master_key = sys.argv[2]

    input_key_table_name = sys.argv[3]
    input_role_table_name = sys.argv[4]
    input_account_table_name = sys.argv[5]
    input_account_role_table_name = sys.argv[6]
    input_client_applications_table_name = sys.argv[7]

    store_key(input_key_table_name, input_master_key)
    store_roles(input_role_table_name)
    store_account(user_name, input_account_table_name, input_account_role_table_name)
    store_client_applications(input_client_applications_table_name)
