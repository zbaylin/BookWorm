from PySide2 import QtQml
from views.models.list_books import BooksListModel
from views.models.view_books import BooksViewModel
from views.models.view_book_info import BookInfoViewModel
from views.models.view_create_student import CreateStudentViewModel
from views.models.view_check_out import CheckOutViewModel
from views.models.list_students import StudentsListModel
from views.models.view_students import StudentsViewModel
from views.models.view_edit_student import EditStudentViewModel
from views.models.view_issuance_report import IssuanceReportViewModel
from views.models.view_issuances import IssuancesViewModel
from views.models.list_issuances import IssuancesListModel


def prep_engine(engine: QtQml.QQmlApplicationEngine):
  # We create all the list/view models needed for the main application
  # All of them can be found at their umport locations above
  engine.book_list_model = BooksListModel()
  engine.book_view_model = BooksViewModel()
  engine.book_info_view_model = BookInfoViewModel()
  engine.check_out_view_model = CheckOutViewModel()
  engine.create_student_view_model = CreateStudentViewModel()
  engine.students_view_model = StudentsViewModel()
  engine.students_list_model = StudentsListModel()
  engine.edit_student_view_model = EditStudentViewModel()
  engine.issuance_report_view_model = IssuanceReportViewModel()
  engine.issuances_list_model = IssuancesListModel()
  engine.issuances_view_model = IssuancesViewModel()
  # We acquire the root context from the engine...
  context = engine.rootContext()
  # ...and load in all of the models so they are accessible from QML
  context.setContextProperty('BooksListModel', engine.book_list_model)
  context.setContextProperty('BooksViewModel', engine.book_view_model)
  context.setContextProperty('BookInfoViewModel', engine.book_info_view_model)
  context.setContextProperty('CreateStudentViewModel', engine.create_student_view_model)
  context.setContextProperty('CheckOutViewModel', engine.check_out_view_model)
  context.setContextProperty('StudentsViewModel', engine.students_view_model)
  context.setContextProperty('StudentsListModel', engine.students_list_model)
  context.setContextProperty('EditStudentViewModel', engine.edit_student_view_model)
  context.setContextProperty('IssuanceReportViewModel', engine.issuance_report_view_model)
  context.setContextProperty('IssuancesListModel', engine.issuances_list_model)
  context.setContextProperty('IssuancesViewModel', engine.issuances_view_model)
  # We load the main QML file from the disk into the engine
  engine.load("qml/main/main.qml")