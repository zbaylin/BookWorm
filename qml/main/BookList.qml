import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

WebContent {
  anchors.fill: parent
  Component.onCompleted: function() {
    BookViewModel.start_fetch()
  }

  GridView {
    focus: true
    property string name: "Book List"
    id: bookGridView
    cacheBuffer: 20
    model: BookListModel
    anchors.fill: parent
    cellWidth: 180; cellHeight: 220
    delegate: ItemDelegate {
      width: bookGridView.cellWidth
      height: bookGridView.cellHeight
      Column {
        anchors.fill: parent
        anchors.topMargin: 20
        visible: true
        Image {
          anchors.horizontalCenter: parent.horizontalCenter
          fillMode: Image.PreserveAspectFit
          width: parent.width / 1.5
          height: parent.height / 1.5
          source: "http://localhost:3000/api/book/" + isbn + "/cover_image"
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
    target: BookViewModel
    onNetwork_state: function(state) {
      switch(state.state) {
        case NetworkState.active:
          loadingIndicator.visible = true
          break
        case NetworkState.done:
          loadingIndicator.visible = false
          BookViewModel.update_list_model(BookListModel)
          bookGridView.visible = true
          break
        case NetworkState.error:
          showErrorMessage(state.error)
          break
      }
    }
  }
}