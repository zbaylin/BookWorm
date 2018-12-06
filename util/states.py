class ThreadState:
  idle = "idle"
  done = "done"
  error = "error"


class NetworkState(ThreadState):
  active = "active"
