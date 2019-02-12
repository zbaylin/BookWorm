import QtQuick 2.11
import QtCharts 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.11
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

Item {
  anchors.fill: parent
  Column {
    anchors.centerIn: parent
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: "Please click the button below to generate and download a backup of the database."
    }
    Button {
      anchors.horizontalCenter: parent.horizontalCenter
      highlighted: true 
      text: "Backup"
      onClicked: function() {
        Qt.openUrlExternally(hostname + "/api/backup.zip")
      }
    }
  }
}