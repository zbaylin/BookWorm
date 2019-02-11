from PySide2 import QtWidgets, QtQml, QtCore
import sys
import os
from interfaces.wizard import WizardInterface
import views.main
import signal
import config

proc = None
app = None

if __name__ == "__main__":
  # Create a Qt Application object from the system arguments
  app = QtWidgets.QApplication(sys.argv)

  # Enable material design in the app
  os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"

  # When the SIGINT signal is received, exit
  signal.signal(signal.SIGINT, signal.SIG_DFL)

  engine = QtQml.QQmlApplicationEngine()

  def start_main():
    global proc, app
    config.load()
    views.main.prep_engine(engine)
    n = engine.rootObjects()
    if len(n) > 1:
      root = engine.rootObjects()[1]
    else:
      root = engine.rootObjects()[0]

    nameProp = QtQml.QQmlProperty(root, "name")
    schoolProp = QtQml.QQmlProperty(root, "school")
    hostProp = QtQml.QQmlProperty(root, "hostname")
    nameProp.write(config.user["firstName"] + " " + config.user["lastName"])
    schoolProp.write(config.user["school"])
    hostProp.write(config.hostname)
    root.show()
    proc = app.exec_()
      
  def start_wizard():
    global proc

    def start_main_from_wizard(root):
      root.close()
      start_main()

    context = engine.rootContext()
    engine.load("qml/wizard/wizard.qml")
    interface = WizardInterface(lambda: start_main_from_wizard(root))
    root = engine.rootObjects()[0]
    context.setContextProperty("wizardInterface", interface)
    interface.user_created.connect(root.onUserCreated)
    proc = app.exec_()

  if config.exists():
    start_main()
  else:
    start_wizard()

  # and start the app
  sys.exit(proc)