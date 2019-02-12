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
    StudentsViewModel.start_fetch()
  }

  ListView {
    focus: true
    visible: false
    id: studentListView
    spacing: 8
    model: StudentsListModel
    anchors.fill: parent
    delegate: Card {
      width: studentListView.width - 20
      anchors.horizontalCenter: parent.horizontalCenter
      ColumnLayout { 
        width: parent.width*.8
        anchors.centerIn: parent
        Text {
          Layout.alignment: Qt.AlignHCenter
          text: "<b>" + lastname + ", " + firstname + "</b> " + "(" + grade + ")"
          font.pointSize: 14
        }
        Text {
          Layout.alignment: Qt.AlignHCenter
          text: email
        }
        Row {
          spacing: 6
          Layout.alignment: Qt.AlignHCenter          
          Text {
            font.family: iconFont.name
            font.pointSize: 18
            color: "brown"
            text: MD.icons.book
          }
          Text {
            text: numIssuances
          }
        }
        Row {
          spacing: 6
          Layout.alignment: Qt.AlignRight
          Button {
            Material.background: Material.Blue
            Material.foreground: "white"         
            text: "Edit"
            onClicked: function() {
              editStudentWindow.user = {id: id, "firstname": firstname, "lastname": lastname, "email": email, "grade": grade}
              editStudentWindow.visible = true
            }
          }
        }
      }
    }
  }

  Connections {
    target: StudentsViewModel
    onNetwork_state: function(state) {
      switch(state.state) {
        case NetworkState.active:
          loadingIndicator.visible = true
          break
        case NetworkState.done:
          loadingIndicator.visible = false
          StudentsViewModel.update_list_model(StudentsListModel)
          studentListView.visible = true
          break
        case NetworkState.error:
          showErrorMessage(state.error)
          break
      }
    }
  }
}