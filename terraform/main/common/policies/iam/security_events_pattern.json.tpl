{
  "source": ${jsonencode(SOURCES)},
  "detail-type": ${jsonencode(DETAIL_TYPE)},
  "detail": {
    "eventSource": ${jsonencode(EVENT_SOURCES)},
    "eventName": ${jsonencode(EVENT_NAMES)}
  }
}