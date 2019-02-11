import QtQuick 2.11
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1



ColumnLayout {
  id: userCreatedColumn
  property alias name : userCreatedLabel.name
  spacing: 8

  Text {
    id: userCreatedLabel
    property string name: ""
    Layout.alignment: Qt.AlignCenter
    horizontalAlignment: Text.AlignHCenter
    text: "Welcome, " +  name
    font.pointSize: 24
  }

  Text {
    text: "Click the button below to be taken to your custom library portal."
    Layout.alignment: Qt.AlignCenter
    font.weight: Font.ExtraLight
    horizontalAlignment: Text.AlignHCenter
    Layout.maximumWidth: mainWindow.width / 1.5
    wrapMode: Text.Wrap
  }

  Button {
    text: "I'm ready"
    Layout.alignment: Qt.AlignCenter
    highlighted: true
    onClicked: function() {
      wizardInterface.onDone()
    }
  }
}