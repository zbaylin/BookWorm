from PySide2 import QtQml


class WizardView(QtQml.QQmlApplicationEngine):
  def __init__(self, parent=None):
    super(WizardView, self).__init__(parent)
    self.load("qml/wizard/wizard.qml")
