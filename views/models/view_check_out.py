from PySide2 import QtCore
import threading
import requests
from util.states import NetworkState
from views.models.web_content import WebContentViewModel
import config


class CheckOutViewModel(WebContentViewModel):
  def __init__(self):
    # Initialize this class as part of the parent class with the check out URI
    super().__init__(config.hostname + "/api/issuance/create")
    # We will set the params once we get the student's credentials
    self.params = None
  
  # A method to be called _from_ QML to init the viewmodel
  @QtCore.Slot(str, str, str)
  def init_for_student(self, email, password, isbn):
    self.params = {
      "email": email,
      "password": password,
      "isbn": isbn
    }

  @QtCore.Slot()
  def start_fetch(self):
    # If there are no params, don't initiate the request
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
            "state": NetworkState.done,
            "redemption_key": js["issuance"]["redemption_key"]
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