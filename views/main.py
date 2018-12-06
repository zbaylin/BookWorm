from PySide2 import QtQml
from views.models.list_books import BooksListModel
from views.models.view_books import BooksViewModel


class MainView(QtQml.QQmlApplicationEngine):
  def __init__(self, parent=None):
    super(MainView, self).__init__(parent)
    self.book_list_model = BooksListModel()
    self.book_view_model = BooksViewModel()
    context = self.rootContext()
    context.setContextProperty('BooksListModel', self.book_list_model)
    context.setContextProperty('BooksViewModel', self.book_view_model)
    self.load("qml/main/main.qml")