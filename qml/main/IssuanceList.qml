import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState
import "../convenience/MaterialDesign.js" as MD

WebContent {
  Component.onCompleted: function() {
    IssuancesViewModel.start_fetch()
    console.log("NANANA")
  }

  ListView {
    focus: true
    visible: false
    id: issuancesListView
    spacing: 8
    model: IssuancesListModel
    anchors.fill: parent
    delegate: Card {
      width: issuancesListView.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      RowLayout {
        width: parent.width * .8
        anchors.centerIn: parent
        Column {
          Layout.preferredWidth: parent.width / 2
          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Student Info"
            font.pointSize: 16
          }
          Text {
            text: "<b>Student name:</b>\t" + lastname + ", " + firstname
          }
          Text {
            text: "<b>Checked out on:</b>\t" + creationDate
          }
        }
        Column {
          Layout.preferredWidth: parent.width / 2
          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Book Info"
            font.pointSize: 16
          }
          Text {
            text: "<b>Book name:</b>\t" + title
          }
          Text {
            text: "<b>ISBN:</b>\t" + isbn
          }
          Text {
            text: "<b>Redemption key:</b>\t" + redemptionKey
          }
        }
      }
    }
  }

  Connections {
    target: IssuancesViewModel
    onNetwork_state: function(state) {
      switch(state.state) {
        case NetworkState.active:
          loadingIndicator.visible = true
          break
        case NetworkState.done:
          loadingIndicator.visible = false
          IssuancesViewModel.update_list_model(IssuancesListModel)
          issuancesListView.visible = true
          break
        case NetworkState.error:
          showErrorMessage(state.error)
          break
      }
    }
  }
}