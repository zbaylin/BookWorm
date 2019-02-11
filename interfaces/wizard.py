from PySide2 import QtCore
import config


# Create a WizardInterface class from the QObject class from QtCore
class WizardInterface(QtCore.QObject):

  # Creates a signal to be bound to QML code
  user_created = QtCore.Signal(bool, str)

  # The constructor
  def __init__(self, on_done_func):
    super().__init__()
    # Binds a function to be called when the [DONE] button is clicked
    self.on_done_func = on_done_func

  # Creates a slot to be called when the user is created
  @QtCore.Slot(str, str, str)
  def createUser(self, first, last, school):
    # Try to save the config with the user info
    try:
      config.user = {
        "firstName": first,
        "lastName": last,
        "school": school
      }
      config.save()
      self.user_created.emit(True, first)
      pass
    # If it fails, say so!
    except Exception as e:
      self.user_created.emit(False, "")
      pass

  # When it's done, call the on_done_func
  @QtCore.Slot()
  def onDone(self):
    self.on_done_func()

  
