import json


def lambda_handler(event, context):
    for k, v in event.items():
        print(k, v)

    return {
        'status_code': 200,
        'body': json.dumps('Hi there from the new lambda!')
    }
