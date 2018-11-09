from PySide2 import QtWidgets, QtCore
import sys
import os
from views.wizard import WizardView
from interfaces.wizard import WizardInterface
import signal

if __name__ == "__main__":
  # Create a Qt Application object from the system arguments
  app = QtWidgets.QApplication(sys.argv)

  # Enable material design in the app
  os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"

  window = WizardView()

  context = window.rootContext()
  interface = WizardInterface()
  context.setContextProperty("wizardInterface", interface)
  root = window.rootObjects()[0]
  interface.user_created.connect(root.onUserCreated)

  # When the SIGINT signal is received, exit
  signal.signal(signal.SIGINT, signal.SIG_DFL)

  # and start the app
  sys.exit(app.exec_())