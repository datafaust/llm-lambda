import os
import json
import sagemaker
import boto3
import datetime
from dotenv import load_dotenv
from sagemaker.huggingface import HuggingFaceModel, get_huggingface_llm_image_uri

# record start time
start_time = datetime.datetime.now()

load_dotenv()

try:
        role = sagemaker.get_execution_role()
except ValueError:
        role = os.getenv('SAGEMAKER_ROLE', 'my_role')


# Hub Model configuration. https://huggingface.co/models
hub = {
	'HF_MODEL_ID':'mistralai/Mistral-7B-v0.1',
	'SM_NUM_GPUS': json.dumps(1)
}



# create Hugging Face Model Class
huggingface_model = HuggingFaceModel(
	image_uri=get_huggingface_llm_image_uri("huggingface",version="1.4.2"),
	env=hub,
	role=role, 
)

# deploy model to SageMaker Inference
predictor = huggingface_model.deploy(
	initial_instance_count=1,
	instance_type="ml.g5.2xlarge",
	container_startup_health_check_timeout=3600,
  )
  
# send request
predictor.predict({
	"inputs": "My name is Julien and I like to",
})

# Record the end time
end_time = datetime.datetime.now()

# Calculate the difference in minutes
time_diff = (end_time - start_time).total_seconds() / 60

print(f"Script execution time: {time_diff:.2f} minutes")
print(f'in service as of {datetime.datetime.now()}')
