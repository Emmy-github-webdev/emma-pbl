import json
import time

def lambda_handler(event, context):
    try:
        body = json.loads(event.get("body", "{}"))

        if "id" not in body:
            return {
                "statusCode": 422,
                "body": json.dumps({
                    "errorCode": "VALIDATION_ERROR",
                    "message": "Missing required field: id"
                })
            }

        return {
            "statusCode": 200,
            "body": json.dumps({
                "requestId": context.aws_request_id,
                "timestamp": int(time.time()),
                "payload": body
            })
        }

    except json.JSONDecodeError:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "errorCode": "INVALID_JSON",
                "message": "Malformed JSON"
            })
        }
