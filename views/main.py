from PySide2 import QtQml
from views.models.list_books import BooksListModel
from views.models.view_books import BooksViewModel
from views.models.view_book_info import BookInfoViewModel
from views.models.view_create_student import CreateStudentViewModel
from views.models.view_check_out import CheckOutViewModel


class MainView(QtQml.QQmlApplicationEngine):
  def __init__(self, parent=None):
    super(MainView, self).__init__(parent)
    self.book_list_model = BooksListModel()
    self.book_view_model = BooksViewModel()
    self.book_info_view_model = BookInfoViewModel()
    self.check_out_view_model = CheckOutViewModel()
    self.create_student_view_model = CreateStudentViewModel()
    context = self.rootContext()
    context.setContextProperty('BooksListModel', self.book_list_model)
    context.setContextProperty('BooksViewModel', self.book_view_model)
    context.setContextProperty('BookInfoViewModel', self.book_info_view_model)
    context.setContextProperty('CreateStudentViewModel', self.create_student_view_model)
    context.setContextProperty('CheckOutViewModel', self.check_out_view_model)
    self.load("qml/main/main.qml")