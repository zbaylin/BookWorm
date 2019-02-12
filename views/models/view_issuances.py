from PySide2 import QtCore
import threading
import requests
from util.states import NetworkState
from models.issuance import Issuance
from views.models.web_content import WebContentViewModel
import config


# Creates an issuances model from the WebContentViewModel class
class IssuancesViewModel(WebContentViewModel):
  def __init__(self):
    super().__init__(config.hostname + "/api/issuances")
    self.issuances = []
  
  # A slot to be called from QML which triggers the fetching of issuances
  @QtCore.Slot()
  def start_fetch(self):
    # Creates a thread so the UI is not locked
    self.thread = threading.Thread(target=self._fetch_data)
    # ...and start it
    self.thread.start()

  # A method that actually fetches data
  def _fetch_data(self):
    # We write it in a try/except so the app doenst crash
    try:
      # Emits that fetching is about to occur
      self.network_state.emit({'state': NetworkState.active})
      # Gets the data in a GET request
      r = requests.get(self.url)
      # Raise if there was an error
      r.raise_for_status()
      # Parses the response as JSON
      js = r.json()
      # Makes a list of issuances from the JSON
      self.issuances = [Issuance.from_json(j) for j in js["issuances"]]
      # Emits that all is good
      self.network_state.emit(
        {
          "state": NetworkState.done,
          "data": self.issuances
        }
      )
    except Exception as e:
      # ...print the error...
      print(e)
      # ...and emit it.
      self.network_state.emit(
        {
          "state": NetworkState.error,
          "error": str(e)
        }
      )

  # A function to be called from QML which updates a list model with the data
  @QtCore.Slot(QtCore.QObject)
  def update_list_model(self, list_model):
    # Relies on the BaseListModel #set_data method
    list_model.set_data(self.issuances)