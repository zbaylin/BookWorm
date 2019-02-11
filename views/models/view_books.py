from PySide2 import QtCore
import threading
import requests
from util.states import NetworkState
from models.book import Book
from views.models.web_content import WebContentViewModel
import config


# Creates a book view model from the WebContentViewModel class
class BooksViewModel(WebContentViewModel):
  # A constructor
  def __init__(self):
    super().__init__(config.hostname + "/api/books")
    # The list of books is empty until they are gotten from the server.
    self.books = []
  
  # A slot to be called from QML which triggers the fetching of books.
  @QtCore.Slot()
  def start_fetch(self):
    # Create a thread (so the UI is not locked)...
    self.thread = threading.Thread(target=self._fetch_data)
    # ...and start it
    self.thread.start()

  # A method that actually fetches the data
  def _fetch_data(self):
    # We wrap it in a try/except so the app doesn't crash
    try:
      # Emits that fetching is about to occur
      self.network_state.emit({'state': NetworkState.active})
      # Gets the data in a GET request from the server
      r = requests.get(self.url)
      # Raises an exception if the response returned a non-200 status code
      r.raise_for_status()
      # Parses the response as JSON
      js = r.json()
      # Makes a list of books from the JSON
      self.books = [Book.from_json(j) for j in js["books"]]
      # And emits that the fetching has been completed, alongside the list of books
      # These will later be passed to the list model
      self.network_state.emit(
        {
          "state": NetworkState.done, 
          "data": self.books
        }
      )
    # In the case something bad happens...
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
    list_model.set_data(self.books)