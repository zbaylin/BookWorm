from PySide2 import QtCore

class WizardInterface(QtCore.QObject):
  @QtCore.Slot()
  def test(self):
    print("test")