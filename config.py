import yaml
import os

user = None
hostname = "http://localhost:3000"


def toMap():
  return {
    "user": user
  }


def exists():
  return os.path.isfile("config.yaml")


def load():
  global user
  with open("config.yaml", "r") as f:
    x = yaml.load(f)
    user = x["user"]
    

def save():
  with open("config.yaml", "w+") as f:
    f.write(yaml.dump(toMap()))