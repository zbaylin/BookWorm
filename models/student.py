import json
import util.dict


class Student():
  def __init__(
    self,
    firstname,
    lastname,
    email,
    ID=None,
    password=None,
    num_issuances=0,
  ):
    self.firstname = firstname
    self.lastname = lastname
    self.email = email
    self.id = ID
    self.password = password
    self.num_issuances = num_issuances
  
  @classmethod
  def from_json(cls, json_map):
    if type(json_map) is str:
      json_map = json.loads(json_map)
    issuances = util.dict.safe_get(json_map, "issuances")
    return cls(
      json_map["firstname"],
      json_map["lastname"],
      json_map["email"],
      util.dict.safe_get(json_map, "id"),
      util.dict.safe_get(json_map, "password"),
      len(issuances) if issuances else 0
    )