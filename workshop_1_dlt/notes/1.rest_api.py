import requests

result = requests.get("https://api.github.com/orgs/dlt-hub/repos").json()
print(result[:2])