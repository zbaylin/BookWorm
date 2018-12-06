from PySide2 import QtCore


class BaseListModel(QtCore.QAbstractListModel):
  def __init__(self, parent=None):
    super().__init__(parent)
    self.list = []
  
  def set_data(self, _list):
    # Tell QML that row insertions are beginning
    self.beginResetModel()
    # Replace the list with the one passed
    self.list = _list
    # Tell QML that row insertions are done
    self.endResetModel()
