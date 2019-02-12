from PySide2 import QtCore
from views.models.list_base import BaseListModel


class StudentsListModel(BaseListModel):
  ID = QtCore.Qt.UserRole + 1
  Firstname = QtCore.Qt.UserRole + 2
  Lastname = QtCore.Qt.UserRole + 3
  Email = QtCore.Qt.UserRole + 4
  Grade = QtCore.Qt.UserRole + 5
  NumIssuances = QtCore.Qt.UserRole + 6

  def __init__(self, parent=None):
    super().__init__(parent)

  def data(self, index, role=QtCore.Qt.DisplayRole):
    row = index.row()
    student = self.list[row]
    switcher = {
      StudentsListModel.ID: student.id,
      StudentsListModel.Firstname: student.firstname,
      StudentsListModel.Lastname: student.lastname,
      StudentsListModel.Email: student.email,
      StudentsListModel.Grade: student.grade,
      StudentsListModel.NumIssuances: student.num_issuances
    }
    return switcher.get(role)

  def rowCount(self, parent=QtCore.QModelIndex()):
    return len(self.list)

  def roleNames(self):
    return {
      StudentsListModel.ID: b"id",
      StudentsListModel.Firstname: b"firstname",
      StudentsListModel.Lastname: b"lastname",
      StudentsListModel.Email: b"email",
      StudentsListModel.Grade: b"grade",
      StudentsListModel.NumIssuances: b"numIssuances"
    }