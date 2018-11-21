from PySide2 import QtQml
from views.models.book import BookListModel


class MainView(QtQml.QQmlApplicationEngine):
  def __init__(self, parent=None):
    super(MainView, self).__init__(parent)
    self.book_model = BookListModel()
    context = self.rootContext()
    context.setContextProperty('BookListModel', self.book_model)
    self.load("qml/main/main.qml")