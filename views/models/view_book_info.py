from PySide2 import QtCore
import threading
import requests
from util.states import NetworkState
from models.book import Book
from views.models.web_content import WebContentViewModel
import config


# Creates a book info view model from WebContentViewModel
class BookInfoViewModel(WebContentViewModel):
  # The constructor 
  def __init__(self, isbn=""):
    # Initializes the super class with the ISBN url
    super().__init__(config.hostname + "/api/book/" + isbn + "/info")
  
  # Inits the class for a specific book
  # This can/will be called from QML
  @QtCore.Slot(str)
  def init_for_book(self, isbn):
    self.url = config.hostname + "/api/book/" + isbn + "/info"
  
  # A function to be called from QML to initiate fetching the book's info
  @QtCore.Slot()
  def start_fetch(self):
    # Creates a thread (so the UI doesn't lock up)
    self.thread = threading.Thread(target=self._fetch_data)
    # And starts it
    self.thread.start()

  # The method that actually fetches data
  def _fetch_data(self):
    # We wrap it in a try/except in case it fails
    try:
      # Emit that we're fethcing data
      self.network_state.emit({'state': NetworkState.active})
      # Get the data from the server in a GET request
      r = requests.get(self.url)
      # Raise if the response code is anything non-200
      r.raise_for_status()
      # Parse the response as JSON
      js = r.json()
      # Parse the JSON as a Book
      self.book = Book.from_json(js["book"])
      # And emit the book while saying the fetching is done
      self.network_state.emit(
        {
          "state": NetworkState.done, 
          "data": self.book.__dict__
        }
      )
    # If it is not successful...
    except Exception as e:
      # ...show the error...
      print(e)
      # ...and emit it
      self.network_state.emit(
        {
          "state": NetworkState.error,
          "error": str(e)
        }
      )