from peewee import CharField, TextField, DateField
from models.main import BaseModel


class Book(BaseModel):
  isbn = CharField(unique=True)
  title = CharField()
  author = CharField()
  publisher = CharField()
  summary = TextField()
  publication_date = DateField()