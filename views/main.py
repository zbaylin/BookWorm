from PySide2 import QtQml
from views.models.list_book import BookListModel
from views.models.view_book import BookViewModel


class MainView(QtQml.QQmlApplicationEngine):
  def __init__(self, parent=None):
    super(MainView, self).__init__(parent)
    self.book_list_model = BookListModel()
    self.book_view_model = BookViewModel()
    context = self.rootContext()
    context.setContextProperty('BookListModel', self.book_list_model)
    context.setContextProperty('BookViewModel', self.book_view_model)
    self.load("qml/main/main.qml")