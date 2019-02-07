import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.2
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

WebContent {
  id: bookInfo
  property var book
  Component.onCompleted: function() {
    BookInfoViewModel.init_for_book(isbn)
    BookInfoViewModel.start_fetch()    
  }
  property alias columnHeight: column.implicitHeight
  ColumnLayout {
    id: column
    visible: false
    Text {
      text: book ? book.title : ""
      font.pointSize: 24
      Layout.alignment: Qt.AlignHCenter
    }
    Text {
      text: "by " + (book ? book.author : "")
      font.pointSize: 16
      Layout.alignment: Qt.AlignHCenter
    }
    Row {
      Layout.alignment: Qt.AlignHCenter
      Repeater {
        model: book ? Math.round(book.rating) : 0
        Text {
          text: "★"
          color: "goldenrod"
          font.pointSize: 40
        }
      }
      Repeater {
        model: book ? 5 - Math.round(book.rating) : 0
        Text {
          text: "☆"
          color: "goldenrod"
          font.pointSize: 40
        }
      }
    }
    Text {
      Layout.alignment: Qt.AlignHCenter
      text: book ? "Rating: " + book.rating : ""
    }
    Label {
      text: "Publisher:"
      font.bold: true
    }
    Text {
      text: book ? "\t" + book.publisher : ""
    }
    Label {
      text: "Publication Date:"
      font.bold: true
    }
    Text {
      text: book ? "\t" + book.publication_date.substring(0, book.publication_date.length - 10) : ""
    }
    Label {
      text: "ISBN:"
      font.bold: true
    }
    Text {
      text: book ? "\t" + book.isbn : ""
    }
    Label {
      text: "Summary:"
      font.bold: true
    }
    Text {
      Layout.preferredWidth: bookInfo.width
      wrapMode: Text.Wrap
      text: book ? "\t" + book.summary : ""
    }
    Row {
      spacing: 16
      Layout.alignment: Qt.AlignRight
      Button {
        text: "VIEW IN GOOGLE BOOKS"
        Material.background: "white"
        Material.foreground: Material.Blue
        onClicked: function() {
          Qt.openUrlExternally("https://books.google.com/books?vid=" + isbn)
        }
      }
      Button {
        text: "CHECK OUT EBOOK"
        Material.background: Material.Blue
        Material.foreground: "white"
        onClicked: function() {
          checkOutBookWindow.isbn = book.isbn
          checkOutBookWindow.visible = true
        }
      }
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