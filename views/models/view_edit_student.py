from PySide2 import QtCore
import threading
import requests
from util.states import NetworkState
from views.models.web_content import WebContentViewModel
import config


class EditStudentViewModel(WebContentViewModel):
  def __init__(self):
    super().__init__(config.hostname + "/api/student/edit")
    self.params = None

  @QtCore.Slot(int, str, str, str, str)
  def init_for_student(self, ID, firstname, lastname, email, grade):
    self.params = {
      "id": ID,
      "email": email,
      "firstname": firstname,
      "lastname": lastname,
      "grade": grade
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
        self.network_state.emit({'state': NetworkState.done})
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