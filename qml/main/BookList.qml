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

  Image {
    anchors.fill: parent
    source: "../../assets/img/book_bg.jpg"
  }

  GridView {
    focus: true
    property string name: "Book List"
    id: bookGridView
    cacheBuffer: 20
    model: BooksListModel
    anchors.fill: parent
    cellWidth: 220; cellHeight: 220
    delegate: ItemDelegate {
      width: bookGridView.cellWidth
      height: bookGridView.cellHeight
      onPressed: function() {
        var comp = Qt.createComponent("BookPage.qml")
        var obj = comp.createObject(mainStack, {"isbn": isbn})
        mainStack.push(obj)
      }
      Column {
        anchors.fill: parent
        anchors.topMargin: 20
        visible: true
        Image {
          anchors.horizontalCenter: parent.horizontalCenter
          fillMode: Image.PreserveAspectFit
          width: parent.width / 1.5
          height: parent.height / 1.5
          source: hostname + "/api/book/" + isbn + "/cover_image"
        }
        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: title
          font.bold: true
        }
        Text {
          anchors.horizontalCenter: parent.horizontalCenter
          text: author
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