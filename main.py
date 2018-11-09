from PySide2 import QtWidgets, QtQuick, QtCore, QtQml
import sys
import os
import routes
from views.wizard import WizardView
from interfaces.wizard import WizardInterface

if __name__ == "__main__":
  # Create a Qt Application object from the system arguments
  app = QtWidgets.QApplication(sys.argv)

  # Enable material design in the app
  os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"

  window = WizardView()
  window.show()

  context = window.rootContext()
  interface = WizardInterface()
  context.setContextProperty("wizardInterface", interface)

  # and start the app
  sys.exit(app.exec_())