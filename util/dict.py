def safe_get(d, k):
  try:
    return d[k]
  except Exception as e:
    return None