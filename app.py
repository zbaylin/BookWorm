from PySide2 import QtWidgets, QtQml, QtGui
import sys
import os
from interfaces.wizard import WizardInterface
import views.main
import signal
import config
from util import network


def run():
  # Sets path of QML files
  qml_path = ""
  if os.path.isdir(sys.path[0] + "/qml"):
    qml_path = sys.path[0] + "/qml"
  else:
    qml_path = sys.path[0] + "/../qml"
  # Create a Qt Application object from the system arguments
  app = QtWidgets.QApplication(sys.argv)

  # Set the application icon
  app.setWindowIcon(QtGui.QIcon("assets/img/icon.png"))

  # Enable material design in the app
  os.environ["QT_QUICK_CONTROLS_STYLE"] = "Material"

  # When the SIGINT signal is received, exit
  signal.signal(signal.SIGINT, signal.SIG_DFL)

  # Creates an engine for the application to run under
  engine = QtQml.QQmlApplicationEngine()

  # A function to start the main part of the program.
  # It is conditionally executed based on if the program
  # has been started before.
  def start_main():
    # Access the global proc and app vars
    # Load in the config
    config.load()
    # Prep the engine (see views.main)
    views.main.prep_engine(engine, qml_path)
    # Get the list of root objects:
    n = engine.rootObjects()
    # If there are more than one objects in the list, use the second one.
    # This occurs when the wizard is shown first.
    if len(n) > 1:
      root = engine.rootObjects()[1]
    else:
      # Else, show the first one
      root = engine.rootObjects()[0]

    # Establish all the properties from the config
    nameProp = QtQml.QQmlProperty(root, "name")
    schoolProp = QtQml.QQmlProperty(root, "school")
    hostProp = QtQml.QQmlProperty(root, "hostname")
    nameProp.write(config.user["firstName"] + " " + config.user["lastName"])
    schoolProp.write(config.user["school"])
    hostProp.write(config.hostname)

    # Show the root window
    root.show()
    # And execute the application
    proc = app.exec_()

  # Register this client to the main server
  network.register_client()  
      
  # A function to start the wizard
  # Again, it is conditionally executed.
  def start_wizard():
    global proc

    # A function to start the main application from the wizard:
    def start_main_from_wizard(root):
      # Close the main window
      root.close()
      # and execute start_main
      start_main()

    # Load in the interface so it is accessible from QML
    context = engine.rootContext()
    engine.load(qml_path + "/wizard/wizard.qml")
    interface = WizardInterface(lambda: start_main_from_wizard(root))
    root = engine.rootObjects()[0]
    context.setContextProperty("wizardInterface", interface)
    # Bind user_created to onUserCreated
    interface.user_created.connect(root.onUserCreated)
    # And execute the application
    proc = app.exec_()

  # If the config file exists, show the main window, if not, show the wizard.
  if config.exists():
    start_main()
  else:
    start_wizard()

  # Exit python when the app starts
  sys.exit()


if __name__ == "__main__":
  run()
