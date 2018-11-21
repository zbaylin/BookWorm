from peewee import CharField
from models.main import BaseModel


class Student(BaseModel):
  firstname = CharField()
  lastname = CharField()
  email = CharField(unique=True)
  student_id = CharField()