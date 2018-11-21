from PySide2 import QtCore
from models.book import Book


class BookListModel(QtCore.QAbstractListModel):
  ISBN = QtCore.Qt.UserRole + 1
  Title = QtCore.Qt.UserRole + 2
  Author = QtCore.Qt.UserRole + 3
  Publisher = QtCore.Qt.UserRole + 4
  PublicationDate = QtCore.Qt.UserRole + 5

  def __init__(self, parent=None):
    super().__init__(parent)
    self.books = Book.select()

  def data(self, index, role=QtCore.Qt.DisplayRole):
    row = index.row()
    book = self.books[row]
    switcher = {
      BookListModel.ISBN: book.isbn,
      BookListModel.Title: book.title,
      BookListModel.Author: book.author,
      BookListModel.Publisher: book.publisher,
      BookListModel.PublicationDate: book.publication_date
    }
    return switcher.get(role)

  def rowCount(self, parent=QtCore.QModelIndex()):
    return len(self.books)

  def roleNames(self):
    return {
      BookListModel.ISBN: b"isbn",
      BookListModel.Title: b"title",
      BookListModel.Author: b"author",
      BookListModel.Publisher: b"publisher",
      BookListModel.PublicationDate: b"publication_date"
    }