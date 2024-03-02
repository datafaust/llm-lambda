import os
import json
import sagemaker
import boto3
from dotenv import load_dotenv
from sagemaker.huggingface import HuggingFaceModel, get_huggingface_llm_image_uri

load_dotenv()

try:
        role = sagemaker.get_execution_role()
except ValueError:
        role = os.getenv('SAGEMAKER_ROLE', 'my_role')

# Hub Model configuration. https://huggingface.co/models
hub = {
        'HF_MODEL_ID':'WizardLM/WizardCoder-1B-V1.0',
        'SM_NUM_GPUS': json.dumps(1)
}


# create Hugging Face Model Class
huggingface_model = HuggingFaceModel(
        image_uri=get_huggingface_llm_image_uri("huggingface",version="1.1.0"),
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