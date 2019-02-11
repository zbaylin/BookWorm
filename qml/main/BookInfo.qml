import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.2
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

// A book info page that inherits the WebContent component
WebContent {
  id: bookInfo

  // We want to establish that each book page has a book object property
  // It is initially null
  property var book
  
  // Get the book when the component renders
  Component.onCompleted: function() {
    BookInfoViewModel.init_for_book(isbn)
    BookInfoViewModel.start_fetch()    
  }

  // Create an alias to the column layout's implicit height
  property alias columnHeight: column.implicitHeight

  // Creates a column that holds all the book's info
  ColumnLayout {
    id: column
    // It is invisible until the book loads
    visible: false
    /* 
      N.B. -- all the Text components render an empty string if the
      book is not loaded. This prevents any errors from occuring.
      All the text components are the same.
    */
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
    // Creates a row to contain the star-rating
    Row {
      Layout.alignment: Qt.AlignHCenter
      // We show all the filled in stars using a repeater...
      Repeater {
        model: book ? Math.round(book.rating) : 0
        Text {
          text: "★"
          color: "goldenrod"
          font.pointSize: 40
        }
      }
      // ...and all the empty stars
      Repeater {
        model: book ? 5 - Math.round(book.rating) : 0
        Text {
          text: "☆"
          color: "goldenrod"
          font.pointSize: 36
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
    // Adds a button row at the end with various actions
    Row {
      spacing: 16
      Layout.alignment: Qt.AlignRight
      // A button to view the book in Google Books
      ItemDelegate {
        text: "VIEW IN GOOGLE BOOKS"
        Material.foreground: Material.Orange
        // When you click the button, open the Google Books pages in a browser
        onClicked: function() {
          Qt.openUrlExternally("https://books.google.com/books?vid=" + isbn)
        }
      }
      // A button to check out the book
      ItemDelegate {
        text: "CHECK OUT EBOOK"
        Material.foreground: Material.Blue
        // Opens the check out book window
        onClicked: function() {
          checkOutBookWindow.isbn = book.isbn
          checkOutBookWindow.visible = true
        }
      }
    }
  }
  // We want to act every time the BookInfoViewModel emits
  Connections {
    target: BookInfoViewModel
    onNetwork_state: function (state) {
      // Acts based on the state
      switch(state.state) {
        case NetworkState.active:
          loadingIndicator.visible = true
          break
        case NetworkState.error:
          showErrorMessage(state.error)
          break
        // When it's done, show the book's data
        case NetworkState.done:
          book = state.data
          column.visible = true
          loadingIndicator.visible = false
      }
    }
  }
}