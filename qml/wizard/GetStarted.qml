import QtQuick 2.11
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1

ColumnLayout {
  id: getStarted
  spacing: 8
  
  Logo {
    Layout.maximumWidth: mainWindow.width / 1.5
    Layout.maximumHeight: mainWindow.height / 3
    Layout.alignment: Qt.AlignCenter

    NumberAnimation on opacity {
      from: 0
      to: 1
      duration: 3000
    }
  }

  Text {
    Layout.alignment: Qt.AlignCenter
    text: "Welcome to BookWorm."
    font.pointSize: 24
  }

  Text {
    text: "Looks like you haven't gotten started with us quite yet. In order to begin, we need a little information about you. To continue, press the button below."
    Layout.alignment: Qt.AlignCenter
    font.weight: Font.ExtraLight
    horizontalAlignment: Text.AlignHCenter
    Layout.maximumWidth: mainWindow.width / 1.5
    wrapMode: Text.Wrap
  }

  Button {
    text: "Get Started"
    Layout.alignment: Qt.AlignCenter
    highlighted: true
    onClicked: function() {
      swipe.currentIndex += 1
    } 
  }
}
