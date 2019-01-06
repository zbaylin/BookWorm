from PySide2 import QtCore
import threading
import requests
from util.states import NetworkState
from models.book import Book
from views.models.web_content import WebContentViewModel
import config


class BookInfoViewModel(WebContentViewModel):
  def __init__(self, isbn=""):
    super().__init__(config.hostname + "/api/book/" + isbn + "/info")
  
  @QtCore.Slot(str)
  def init_for_book(self, isbn):
    self.url = config.hostname + "/api/book/" + isbn + "/info"
  
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
      self.book = Book.from_json(js["book"])
      self.network_state.emit(
        {
          "state": NetworkState.done, 
          "data": self.book.__dict__
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
    list_model.set_data(self.books)