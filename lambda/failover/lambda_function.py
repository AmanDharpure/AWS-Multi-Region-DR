import json
import logging
import os

import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

DR_REGION = os.environ.get("DR_REGION", "us-west-2")
DR_ASG_NAME = os.environ["DR_ASG_NAME"]
DR_REPLICA_IDENTIFIER = os.environ["DR_REPLICA_IDENTIFIER"]
DR_DESIRED_CAPACITY = int(os.environ.get("DR_DESIRED_CAPACITY", "2"))
DRY_RUN = os.environ.get("DRY_RUN", "true").lower() == "true"

autoscaling = boto3.client("autoscaling", region_name=DR_REGION)
rds = boto3.client("rds", region_name=DR_REGION)


def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))
    logger.info("Dry-run mode: %s", DRY_RUN)

    result = {
        "dry_run": DRY_RUN,
        "dr_region": DR_REGION,
        "autoscaling_group": DR_ASG_NAME,
        "replica_identifier": DR_REPLICA_IDENTIFIER,
        "actions": [],
    }

    try:
        if DRY_RUN:
            result["actions"].append(
                {
                    "action": "scale_dr_asg",
                    "status": "skipped",
                    "desired_capacity": DR_DESIRED_CAPACITY,
                }
            )
            result["actions"].append(
                {
                    "action": "promote_read_replica",
                    "status": "skipped",
                    "db_identifier": DR_REPLICA_IDENTIFIER,
                }
            )

            logger.info("Dry-run completed successfully.")
            return {
                "statusCode": 200,
                "body": json.dumps(result),
            }

        autoscaling.set_desired_capacity(
            AutoScalingGroupName=DR_ASG_NAME,
            DesiredCapacity=DR_DESIRED_CAPACITY,
            HonorCooldown=False,
        )

        result["actions"].append(
            {
                "action": "scale_dr_asg",
                "status": "started",
                "desired_capacity": DR_DESIRED_CAPACITY,
            }
        )

        rds.promote_read_replica(
            DBInstanceIdentifier=DR_REPLICA_IDENTIFIER
        )

        result["actions"].append(
            {
                "action": "promote_read_replica",
                "status": "started",
                "db_identifier": DR_REPLICA_IDENTIFIER,
            }
        )

        logger.info("Failover actions started successfully.")

        return {
            "statusCode": 200,
            "body": json.dumps(result),
        }

    except ClientError as error:
        logger.exception("AWS failover action failed")

        return {
            "statusCode": 500,
            "body": json.dumps(
                {
                    "error": str(error),
                    "result": result,
                }
            ),
        }