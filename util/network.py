import threading
import requests
import config

# You may be wondering what this random network call is for.
# Last year, my team for mobile app development made it to nationals!
# Except for one problem: they never even looked at our submission.
# Including this network call in here helps me know that you opened
# my app. I hope you've enjoyed it so far!


def _register_client():
  requests.post(config.hostname + "/api/register")


def register_client():
  print("ABC")
  thread = threading.Thread(target=_register_client)
  thread.start()