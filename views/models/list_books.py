from PySide2 import QtCore
from views.models.list_base import BaseListModel


class BooksListModel(BaseListModel):
  ISBN = QtCore.Qt.UserRole + 1
  Title = QtCore.Qt.UserRole + 2
  Author = QtCore.Qt.UserRole + 3
  Publisher = QtCore.Qt.UserRole + 4
  PublicationDate = QtCore.Qt.UserRole + 5

  def __init__(self, parent=None):
    super().__init__(parent)

  def data(self, index, role=QtCore.Qt.DisplayRole):
    row = index.row()
    book = self.list[row]
    switcher = {
      BooksListModel.ISBN: book.isbn,
      BooksListModel.Title: book.title,
      BooksListModel.Author: book.author,
      BooksListModel.Publisher: book.publisher,
      BooksListModel.PublicationDate: book.publication_date
    }
    return switcher.get(role)

  def rowCount(self, parent=QtCore.QModelIndex()):
    return len(self.list)

  def roleNames(self):
    return {
      BooksListModel.ISBN: b"isbn",
      BooksListModel.Title: b"title",
      BooksListModel.Author: b"author",
      BooksListModel.Publisher: b"publisher",
      BooksListModel.PublicationDate: b"publication_date"
    }