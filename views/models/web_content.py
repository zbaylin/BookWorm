from PySide2 import QtCore
from util.states import NetworkState
import threading


# This is a base View Model class abstraction
# for views that acquire their data from the
# internet. This is used so that we know this
# type of View Model will always have these
# same methods (namely start_fetch) and the
# same signals (namely network_state).
class WebContentViewModel(QtCore.QObject):
  # This signal will update everytime there is
  # a change in state of the thread. See
  # utils.states.NetworkState for the states.
  network_state = QtCore.Signal('QVariant')
  thread = threading.Thread()

  def __init__(self, url):
    super(WebContentViewModel, self).__init__()
    self.url = url
    self.network_state.emit({"state": NetworkState.idle})

  @QtCore.Slot()
  def start_fetch(self):
    raise NotImplementedError

  def _fetch_data(self):
    raise NotImplementedError
