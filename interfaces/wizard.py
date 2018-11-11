from PySide2 import QtCore
import config


class WizardInterface(QtCore.QObject):

  user_created = QtCore.Signal(bool, str)

  @QtCore.Slot(str, str, str)
  def createUser(self, first, last, school):
    try:
      config.user = {
        "firstName": first,
        "lastName": last,
        "school": school
      }
      config.save()
      self.user_created.emit(True, first)
      pass
    except Exception as e:
      self.user_created.emit(False, "")
      pass