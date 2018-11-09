import QtQuick 2.11
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

Rectangle {
  id: mainWindow
  visible: true

  width: 600
  height: 350

  Material.theme: Material.Light
  Material.accent: Material.Blue

  Column {
    id: mainColumn
    anchors.centerIn: parent
    spacing: 8
    
    Logo {
      width: mainWindow.width / 2
      height: mainWindow.height / 2
    }

    Button {
      text: "Test"
      highlighted: true
      onClicked: function() {
        wizardInterface.test()
      }
    }
  }
}