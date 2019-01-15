import json
import util.dict


class Student():
  def __init__(
    self,
    firstname,
    lastname,
    email,
    password=None
  ):
    self.firstname = firstname
    self.lastname = lastname
    self.email = email
    self.password = password
  
  @classmethod
  def from_json(cls, json_map):
    if type(json_map) is str:
      json_map = json.loads(json_map)
    return cls(
      json_map["firstname"],
      json_map["lastname"],
      json_map["email"],
      util.dict.safe_get(json_map, "publisher")
    )