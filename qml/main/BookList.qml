import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

// Create a BookList component that is based on the WebContent component
WebContent {
  // As soon as the component is rendered, fetch the list of books from the server.
  Component.onCompleted: function() {
    BooksViewModel.start_fetch()
  }

  // This is just a pretty background for the grid view
  Rectangle {
    color: Material.color(Material.Blue, Material.Shade100)
    anchors.fill: parent
  }

  // A grid view that contains all the list of books
  GridView {
    focus: true
    property string name: "Book List"
    id: bookGridView
    // We want to keep 20 books in the cache at all times
    cacheBuffer: 20
    // We use the BooksListModel from Python
    // see views.models.list_books
    model: BooksListModel
    // Fills the parent
    anchors.fill: parent
    anchors.margins: 6
    // Sets the cell size to be uniform
    cellWidth: 360; cellHeight: 230
    // For each item, render it in a card
    delegate: Card {
      width: bookGridView.cellWidth - 12
      height: bookGridView.cellHeight - 12
      // The card holds a clickable "Item Delegate" that takes the user to the book page
      ItemDelegate {
        id: itemDelegate
        anchors.fill: parent
        // Create a row in the card
        Row {
          id: row
          anchors.fill: parent
          // Show the image on the left
          Image {
            id: bookCover
            fillMode: Image.PreserveAspectFit
            Layout.preferredHeight: itemDelegate.height
            height: parent.height
            source: hostname + "/api/book/" + isbn + "/cover_image"
          }

          // And the book's info on the right contained in a column
          Column {
            width: row.width - bookCover.width
            anchors.verticalCenter: parent.verticalCenter
            // Contains the book's title...
            Text {
              text: title
              anchors.horizontalCenter: parent.horizontalCenter
              horizontalAlignment: Text.AlignHCenter
              width: parent.width
              wrapMode: Text.Wrap
              maximumLineCount: 2
              font.bold: true
            }
            // ...and it's Author
            Text {
              Layout.alignment: Qt.AlignHCenter
              width: parent.width
              anchors.horizontalCenter: parent.horizontalCenter
              horizontalAlignment: Text.AlignHCenter
              wrapMode: Text.Wrap
              text: author
            }
          }
        }
        // When the card is pressed, we want to launch the BookPage
        onPressed: function() {
          // Creates a BookPage component
          var comp = Qt.createComponent("BookPage.qml")
          // Adds it to the main stack with the isbn prop
          var obj = comp.createObject(mainStack, {"isbn": isbn})
          // And pushes it to the stack
          mainStack.push(obj)
        }
      }
    }
  }

  // We want to connect to all the signals of the view model
  Connections {
    target: BooksViewModel
    onNetwork_state: function(state) {
      // We act upon the emitted state
      switch(state.state) {
        // If it's active, show the loading icon
        case NetworkState.active:
          loadingIndicator.visible = true
          break
        // If it's done, show the list and hide the loading icon
        case NetworkState.done:
          loadingIndicator.visible = false
          BooksViewModel.update_list_model(BooksListModel)
          bookGridView.visible = true
          break
        // If there is an error, show it!
        case NetworkState.error:
          showErrorMessage(state.error)
          break
      }
    }
  }
}