import boto3
import uuid
import sys
import base64
import os


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


if __name__ == '__main__':
    input_master_key = sys.argv[1]
    input_key_table_name = f'VAuthenticator_Signature_Keys{sys.argv[2]}'

    store_key(input_key_table_name, input_master_key)
