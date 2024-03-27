import fileinput

# Define the new MongoDB URL
new_mongodb_url = "mongodb://localhost:27017"

# Path to your .env file
env_file = '.env'

# Read the .env file and replace the MONGODB_URL line
with fileinput.FileInput(env_file, inplace=True) as file:
    for line in file:
        if line.startswith('MONGODB_URL='):
            print(f'MONGODB_URL={new_mongodb_url}')
        else:
            print(line, end='')