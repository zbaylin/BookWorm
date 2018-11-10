import yaml

user = None


def toMap():
  return {
    "user": user
  }


def save():
  with open("config.yaml", "w+") as f:
    f.write(yaml.dump(toMap()))