from PySide2 import QtCore
from views.models.list_base import BaseListModel


class IssuancesListModel(BaseListModel):
  Firstname = QtCore.Qt.UserRole + 1
  Lastname = QtCore.Qt.UserRole + 2
  Email = QtCore.Qt.UserRole + 3
  ISBN = QtCore.Qt.UserRole + 4
  Title = QtCore.Qt.UserRole + 5
  CreationDate = QtCore.Qt.UserRole + 6
  Redeemed = QtCore.Qt.UserRole + 7
  RedemptionKey = QtCore.Qt.UserRole + 8

  def __init__(self, parent=None):
    super().__init__(parent)
  
  def data(self, index, role=QtCore.Qt.DisplayRole):
    row = index.row()
    issuance = self.list[row]
    switcher = {
      IssuancesListModel.Firstname: issuance.student.firstname,
      IssuancesListModel.Lastname: issuance.student.lastname,
      IssuancesListModel.Email: issuance.student.email,
      IssuancesListModel.ISBN: issuance.book.isbn,
      IssuancesListModel.Title: issuance.book.title,
      IssuancesListModel.CreationDate: issuance.creation_date,
      IssuancesListModel.Redeemed: issuance.redeemed,
      IssuancesListModel.RedemptionKey: issuance.redemption_key
    }
    return switcher.get(role)

  def rowCount(self, parent=QtCore.QModelIndex()):
    return len(self.list)
  
  def roleNames(self):
    return {
      IssuancesListModel.Firstname: b"firstname",
      IssuancesListModel.Lastname: b"lastname",
      IssuancesListModel.Email: b"email",
      IssuancesListModel.ISBN: b"isbn",
      IssuancesListModel.Title: b"title",
      IssuancesListModel.CreationDate: b"creationDate",
      IssuancesListModel.Redeemed: b"redeemed",
      IssuancesListModel.RedemptionKey: b"redemptionKey"
    }