import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

Item {
  id: reportPage
  width: mainStack.width
  height: mainStack.height
  ScrollView {
    height: parent.height
    width: parent.width

    contentHeight: column.implicitHeight
    anchors.horizontalCenter: parent.horizontalCenter    
    ScrollBar.vertical.policy: ScrollBar.AlwaysOn

    ColumnLayout {
      id: column
      height: parent.height
      width: parent.width
      spacing: 12
      anchors.horizontalCenter: parent.horizontalCenter

      Text {
        id: weekLabel
        Layout.topMargin: 10
        Layout.alignment: Qt.AlignHCenter
        font.pointSize: 20.0
        text: "Week of "
        Component.onCompleted: function() {
          var date_1 = new Date()
          var date_0 = new Date()
          date_0.setDate(date_1.getDate() - 7)
          weekLabel.text = "Week of " + date_0.toLocaleDateString("en-US") + " to " + date_1.toLocaleDateString("en-US")
        }
      }

      IssuanceReportCard {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: reportPage.width - 12
        Layout.leftMargin: 6
      }
    }
  }
}