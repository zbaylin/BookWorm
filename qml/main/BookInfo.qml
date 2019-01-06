import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

WebContent {
  property var book
  height: column.height
  Component.onCompleted: function() {
    BookInfoViewModel.init_for_book(isbn)
    BookInfoViewModel.start_fetch()
  }
  Column {
    id: column
    visible: false
    width: parent.width
    Text {
      text: book ? book.title : ""
      font.pointSize: 24
      anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
      text: "by " + (book ? book.author : "")
      font.pointSize: 16
      anchors.horizontalCenter: parent.horizontalCenter
    }
    Label {
      text: "Summary:"
      font.bold: true
    }
    Text {
      width: parent.width
      wrapMode: Text.WordWrap
      text: book ? book.summary : ""
    }
  }
  Connections {
    target: BookInfoViewModel
    onNetwork_state: function (state) {
      switch(state.state) {
        case NetworkState.active:
          loadingIndicator.visible = true
          break
        case NetworkState.error:
          showErrorMessage(state.error)
          break
        case NetworkState.done:
          book = state.data
          column.visible = true
          loadingIndicator.visible = false
      }
    }
  }
}