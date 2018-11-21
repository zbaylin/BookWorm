from peewee import SqliteDatabase, Model

db = SqliteDatabase('data.db')


class BaseModel(Model):
  class Meta:
    database = db