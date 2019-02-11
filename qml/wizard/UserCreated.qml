import QtQuick 2.11
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1


// Column to be shown when the user is created
ColumnLayout {
  // Give it an ID an a name, which is sourced from Python
  id: userCreatedColumn
  property alias name : userCreatedLabel.name
  // Space everything 8px
  spacing: 8

  // Show welcome text with the previously inputted name
  Text {
    id: userCreatedLabel
    property string name: ""
    Layout.alignment: Qt.AlignCenter
    horizontalAlignment: Text.AlignHCenter
    text: "Welcome, " +  name
    font.pointSize: 24
  }

  // Show a helper text
  Text {
    text: "Click the button below to be taken to your custom library portal."
    Layout.alignment: Qt.AlignCenter
    font.weight: Font.ExtraLight
    horizontalAlignment: Text.AlignHCenter
    Layout.maximumWidth: mainWindow.width / 1.5
    wrapMode: Text.Wrap
  }

  // And finally, show a button to be done with the wizard
  Button {
    text: "I'm ready"
    Layout.alignment: Qt.AlignCenter
    highlighted: true
    // Calls the onDone function specified in app.py
    onClicked: function() {
      wizardInterface.onDone()
    }
  }
}