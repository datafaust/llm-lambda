import requests
import json

#url = 'https://xi6su0kbkd.execute-api.us-east-1.amazonaws.com/llm_ap_1/start_instance'
url = 'https://xi6su0kbkd.execute-api.us-east-1.amazonaws.com/llm_ap_1/ask'


# myobj = json.dumps({ "inputs": "what is 3 + 3?" })
# #myobj = json.dumps({})

# response = requests.post(url, data = myobj)

# #x = requests.post(url, data=myobj, headers={'content-type': 'application/json', 'x-api-key': ''})

# #print(x.text)

# if response.status_code == 200:#
#     print('Success:', response.json())
# else:
#     print('Error:', response.status_code, response.text)



# JSON payload
payload = {"inputs": "write a navbar div"}

# Send POST request with JSON payload
response = requests.post(url, json=payload, headers={'Content-Type': 'application/json'})

# Check response status code and print response data
if response.status_code == 200:
    print('Success:', response.json())
else:
    print('Error:', response.status_code, response.text)