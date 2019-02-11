import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

WebContent {
  Component.onCompleted: function() {
    BooksViewModel.start_fetch()
  }

  Rectangle {
    color: Material.color(Material.Blue, Material.Shade100)
    anchors.fill: parent
  }

  GridView {
    focus: true
    property string name: "Book List"
    id: bookGridView
    cacheBuffer: 20
    model: BooksListModel
    anchors.fill: parent
    anchors.margins: 6
    cellWidth: 360; cellHeight: 230
    delegate: Card {
      width: bookGridView.cellWidth - 12
      height: bookGridView.cellHeight - 12
      ItemDelegate {
        id: itemDelegate
        anchors.fill: parent
        Row {
          id: row
          anchors.fill: parent
          Image {
            id: bookCover
            fillMode: Image.PreserveAspectFit
            Layout.preferredHeight: itemDelegate.height
            height: parent.height
            source: hostname + "/api/book/" + isbn + "/cover_image"
          }

          Column {
            width: row.width - bookCover.width
            anchors.verticalCenter: parent.verticalCenter
            Text {
              text: title
              anchors.horizontalCenter: parent.horizontalCenter
              horizontalAlignment: Text.AlignHCenter
              width: parent.width
              wrapMode: Text.Wrap
              maximumLineCount: 2
              font.bold: true
            }
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
        onPressed: function() {
          var comp = Qt.createComponent("BookPage.qml")
          var obj = comp.createObject(mainStack, {"isbn": isbn})
          mainStack.push(obj)
        }
      }
    }
  }

  Connections {
    target: BooksViewModel
    onNetwork_state: function(state) {
      switch(state.state) {
        case NetworkState.active:
          loadingIndicator.visible = true
          break
        case NetworkState.done:
          loadingIndicator.visible = false
          BooksViewModel.update_list_model(BooksListModel)
          bookGridView.visible = true
          break
        case NetworkState.error:
          showErrorMessage(state.error)
          break
      }
    }
  }
}