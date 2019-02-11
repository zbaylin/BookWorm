from PySide2 import QtCore
import threading
import requests
from util.states import NetworkState
from views.models.web_content import WebContentViewModel
import config


class IssuanceReportViewModel(WebContentViewModel):
  def __init__(self):
    # Initialize the parent class with the stat URI
    super().__init__(config.hostname + "/api/issuances/weekly_stats")

  @QtCore.Slot()
  def start_fetch(self):
    self.thread = threading.Thread(target=self._fetch_data)
    self.thread.start()
  
  def _fetch_data(self):
    try:
      self.network_state.emit({'state': NetworkState.active})
      r = requests.get(self.url)
      r.raise_for_status()
      js = r.json()
      if js["success"]:
        self.network_state.emit(
          {
            "state": NetworkState.done,
            "numIssuances": js["num_issuances"],
            "numRedeemed": js["num_redeemed"]
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