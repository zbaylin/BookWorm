from PySide2 import QtCore, QtGui, QtQuick

class WizardView(QtQuick.QQuickView):
  def __init__(self, parent=None):
    super(WizardView, self).__init__(parent)
    self.setTitle("First Time Startup")
    self.setSource(QtCore.QUrl("wizard.qml"))
    self.setResizeMode(QtQuick.QQuickView.SizeRootObjectToView)