from PySide2 import QtCore
import threading
import requests
from util.states import NetworkState
from models.student import Student
from views.models.web_content import WebContentViewModel
import config


class CreateStudentViewModel(WebContentViewModel):
  def __init__(self):
    # Initialize the parent class with the create user URI
    super().__init__(config.hostname + "/api/student/create")
    # We will set the params once we get the student's info
    self.params = None
  
  @QtCore.Slot(str, str, str, str)
  def init_for_student(self, email, password, firstname, lastname):
    self.params = {
      "email": email,
      "password": password,
      "firstname": firstname,
      "lastname": lastname
    }
  
  @QtCore.Slot()
  def start_fetch(self):
    if self.params is None:
      raise TypeError
    self.thread = threading.Thread(target=self._fetch_data)
    self.thread.start()
  
  def _fetch_data(self):
    try:
      self.network_state.emit({'state': NetworkState.active})
      r = requests.post(self.url, json=self.params)
      r.raise_for_status()
      js = r.json()
      if js["success"]:  
        self.network_state.emit(
          {
            "state": NetworkState.done
          }
        )
      else:
        raise ConnectionError
    except Exception as e:
      print(e)
      self.network_state.emit(
        {
          "state": NetworkState.error,
          "error": str(e)
        }
      )