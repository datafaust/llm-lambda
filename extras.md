master lambda

frontend
- type and try to get a response
-- return an error saying the instance is not started
-- follow through with response being sent





lambda 1
- checks sagemaker for existing endpoints
- checks sagemaker for existing models
- checks sagemaker for existing endpoint configs

if ^ true STOP else

lambda 2
- start ec2 instance
- run deploy script
- stop ec2 instance when its finished

lambda 3
- 



aws ec2 associate-iam-instance-profile --instance-id i-0a886aa54162ec805 --iam-instance-profile Name=ec2_ssm_sagemaker_role

aws ec2 describe-instances --instance-id i-0a886aa54162ec805 --query 'Reservations[].Instances[].IamInstanceProfile'




###############

import boto3
import time
import json

def lambda_handler(event, context):
    # Specify the region where your EC2 instance is located
    ec2 = boto3.client('ec2', region_name='us-east-1')
    ssm = boto3.client('ssm', region_name='us-east-1')
    
    # Specify the instance ID of the EC2 instance you want to start
    instance_id = event['instance_id']
    
    # Check if the instance is already running
    instance = ec2.describe_instances(InstanceIds=[instance_id])
    state = instance['Reservations'][0]['Instances'][0]['State']['Name']
    
    if state == 'running':
        
        # check to see if endpoints exist
        lambda_client = boto3.client('lambda')
        invoke_response = lambda_client.invoke(
            FunctionName='check_sm_endpoints',
            InvocationType='RequestResponse',
            Payload=json.dumps({'action': 'check'})
            )

        # Get the response from the invoked Lambda function
        invoked_response = json.loads(invoke_response['Payload'].read().decode('utf-8'))
        
        # if they do not exist then launch the endpoint
        if invoked_response['message'] == 'there are no endpoints currently available!':
            print('time to deploy the endpoints then!')
            
            response = ssm.send_command(
                InstanceIds=[instance_id],
                DocumentName='AWS-RunShellScript',
                Parameters={'commands': ['sudo -u ec2-user /usr/bin/python3 /home/ec2-user/llm-lambda/deploy_test_model.py']}
                )
        
            # Get the command ID for the executed script
            command_id = response['Command']['CommandId']
            
            # every 10 seconds check if the endpoints are being created
            # once they are in the process of being created we can break
            while True:
                time.sleep(10)  # Wait for 10 seconds
                new_invoked_response = lambda_client.invoke(
                    FunctionName='check_sm_endpoints',
                    InvocationType='RequestResponse',
                    Payload=json.dumps({'action': 'check'})
                )
    
                new_invoked_response = json.loads(new_invoked_response['Payload'].read().decode('utf-8'))
                endpoint_status = new_invoked_response.get('endpoint_status', '')
                if endpoint_status:
                    break
            
            
            # Get the command output
            #output = command_invocation.get('StandardOutputContent', '') + command_invocation.get('StandardErrorContent', '')
        
            # Return success message with the command ID and output
            #return {"message": "Instance is already running", "command_id": command_id, "output": output}
            return {"status": "success", "command_id": command_id, "output": new_invoked_response}
        
        
        
        # Run the script on the EC2 instance using SSM
        #response = ssm.send_command(
        #InstanceIds=[instance_id],
        #DocumentName='AWS-RunShellScript',
        #Parameters={'commands': ['sudo -u ec2-user /usr/bin/python3 /home/ec2-user/llm-lambda/deploy_test_model.py']}
        #)
        
        # Get the command ID for the executed script
        #command_id = response['Command']['CommandId']
        
        # Wait for the command to complete
        #while True:
            #time.sleep(5)  # Wait for 5 seconds
            #command_invocation = ssm.get_command_invocation(
            #    CommandId=command_id,
            #    InstanceId=instance_id
            #)
            #status = command_invocation['Status']
            #if status in ['Success', 'Failed', 'Cancelled']:
            #    break
        
        # Get the command output
        #output = command_invocation.get('StandardOutputContent', '') + command_invocation.get('StandardErrorContent', '')
        
        # Return success message with the command ID and output
        #return {"message": "Instance is already running", "command_id": command_id, "output": output}
    else:
        # Start the EC2 instance
        ec2.start_instances(InstanceIds=[instance_id])
        
        # Wait for the instance to be running
        while True:
            time.sleep(50)  # Wait for 50 seconds
            instance = ec2.describe_instances(InstanceIds=[instance_id])
            state = instance['Reservations'][0]['Instances'][0]['State']['Name']
            if state == 'running':
                print("running")
                break
        
        # Run the script on the EC2 instance using SSM
        response = ssm.send_command(
            InstanceIds=[instance_id],
            DocumentName='AWS-RunShellScript',
            Parameters={'commands': ['sudo -u ec2-user /usr/bin/python3 /home/ec2-user/llm-lambda/deploy_test_model.py']}
        )
        
        # Get the command ID for the executed script
        command_id = response['Command']['CommandId']
        
        # Invoke another Lambda function
        time.sleep(40)
        lambda_client = boto3.client('lambda')
        invoke_response = lambda_client.invoke(
            FunctionName='check_sm_endpoints',
            InvocationType='RequestResponse',
            Payload=json.dumps({'action': 'check'})
            )

        # Get the response from the invoked Lambda function
        invoked_response = invoke_response['Payload'].read().decode('utf-8')
        
        # Wait for the command to complete
        #while True:
        #    time.sleep(5)  # Wait for 5 seconds
        #    command_invocation = ssm.get_command_invocation(
        #        CommandId=command_id,
        #        InstanceId=instance_id
        #    )
        #    status = command_invocation['Status']
        #    if status in ['Success', 'Failed', 'Cancelled']:
        #        break
        
        # Get the command output
        #output = command_invocation.get('StandardOutputContent', '') + command_invocation.get('StandardErrorContent', '')
        
        # Return success message with the command ID and output
        return {"message": "Instance has been started and script is running", "command_id": command_id, "invoked_response": invoked_response}


huggingface-pytorch-tgi-inference-2024-02-29-16-10-01-343

huggingface-pytorch-tgi-inference-2024-02-29-16-10-01


okay so lets do this, i will create a logging bucket, i want you to edit this code so that under the else statement we send a log file to 





python -m venv venv

source venv/bin/activate

pip install -r requirements.txt
deactivate

cd venv/lib/python3.9/site-packages/  

zip -r9 ${OLDPWD}/my-deployment-package.zip .

cd $OLDPWD                                   
zip -g my-deployment-package.zip lambda_function.py