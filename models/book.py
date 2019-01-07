import json


class Book():
  def __init__(
    self,
    isbn,
    title,
    author,
    publisher,
    summary,
    publication_date,
    rating
  ):
    self.isbn = isbn,
    self.title = title,
    self.author = author,
    self.publisher = publisher,
    self.summary = summary,
    self.publication_date = publication_date
    self.rating = rating
  
  @classmethod
  def from_json(cls, json_map):
    if type(json_map) is str:
      json_map = json.loads(json_map)
    return cls(
      json_map["isbn"],
      json_map["title"],
      json_map["author"],
      json_map["publisher"],
      json_map["summary"],
      json_map["publication_date"],
      json_map["rating"]
    )