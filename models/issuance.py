import json
from models.book import Book
from models.student import Student


class Issuance():
  def __init__(
    self,
    student: Student,
    book: Book,
    creation_date: str,
    redeemed: bool,
    redemption_key: str
  ):
    self.student = student
    self.book = book
    self.creation_date = creation_date
    self.redeemed = redeemed
    self.redemption_key = redemption_key
  
  @classmethod
  def from_json(cls, json_map):
    if type(json_map) is str:
      json_map = json.loads(json_map)
    c = cls(
      Student.from_json(json_map["student"]),
      Book.from_json(json_map["book"]),
      json_map["created_at"],
      json_map["redeemed"],
      json_map["redemption_key"]
    )
    return c