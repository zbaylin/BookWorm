from PySide2 import QtCore
import threading
import requests
from util.states import NetworkState
from models.student import Student
from views.models.web_content import WebContentViewModel
import config


class StudentsViewModel(WebContentViewModel):
  def __init__(self):
    super().__init__(config.hostname + "/api/students")
    self.students = []
  
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
      self.students = [Student.from_json(j) for j in js["students"]]
      self.network_state.emit(
        {
          "state": NetworkState.done, 
          "data": self.students
        }
      )
    except Exception as e:
      print(e)
      self.network_state.emit(
        {
          "state": NetworkState.error,
          "error": str(e)
        }
      )
  
  @QtCore.Slot(QtCore.QObject)
  def update_list_model(self, list_model):
    list_model.set_data(self.students)