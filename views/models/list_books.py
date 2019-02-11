from PySide2 import QtCore
from views.models.list_base import BaseListModel


# Create a books list model that inherits the base list model
class BooksListModel(BaseListModel):
  # Establish the attributes of each book:
  ISBN = QtCore.Qt.UserRole + 1  # ISBN
  Title = QtCore.Qt.UserRole + 2  # Title
  Author = QtCore.Qt.UserRole + 3  # Author
  Publisher = QtCore.Qt.UserRole + 4  # Publisher
  PublicationDate = QtCore.Qt.UserRole + 5  # Publication Date

  # Initiate the parent on start
  def __init__(self, parent=None):
    super().__init__(parent)

  # A required function to get the data from the list
  def data(self, index, role=QtCore.Qt.DisplayRole):
    row = index.row()
    book = self.list[row]
    # Establishes a correspondence between the attributes 
    # and the book attributes
    switcher = {
      BooksListModel.ISBN: book.isbn,
      BooksListModel.Title: book.title,
      BooksListModel.Author: book.author,
      BooksListModel.Publisher: book.publisher,
      BooksListModel.PublicationDate: book.publication_date
    }
    return switcher.get(role)

  # A required function to return the number of rows
  def rowCount(self, parent=QtCore.QModelIndex()):
    return len(self.list)

  # A required function to bind names in strings to attributes
  def roleNames(self):
    return {
      BooksListModel.ISBN: b"isbn",
      BooksListModel.Title: b"title",
      BooksListModel.Author: b"author",
      BooksListModel.Publisher: b"publisher",
      BooksListModel.PublicationDate: b"publication_date"
    }