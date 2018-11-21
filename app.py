from PySide2 import QtWidgets, QtQml
import sys
import os
from views.wizard import WizardView
from interfaces.wizard import WizardInterface
from views.main import MainView
from models.main import db
from models import book, student
import signal
import config

if __name__ == "__main__":
  # Create a Qt Application object from the system arguments
  app = QtWidgets.QApplication(sys.argv)

  # Enable material design in the app
  os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"
  db.connect()

  if config.exists():
    config.load()
    window = MainView()
    root = window.rootObjects()[0]
    nameProp = QtQml.QQmlProperty(root, "name")
    schoolProp = QtQml.QQmlProperty(root, "school")
    nameProp.write(config.user["firstName"] + " " + config.user["lastName"])
    schoolProp.write(config.user["school"])
  else:
    # Create the tables in the database
    db.create_tables([book.Book, student.Student])
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