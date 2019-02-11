import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import Qt.labs.calendar 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState
import "../convenience/MaterialDesign.js" as MD

Item {
  id: reportPage
  width: mainStack.width
  height: mainStack.height
  property bool calendarShown: false
  property var dateEnd: new Date()
  property var months: [ "January", "February", "March", "April", "May", "June", 
              "July", "August", "September", "October", "November", "December" ]
        
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

      Row {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 10
        spacing: 6
        Text {
          id: weekLabel
          font.pointSize: 20.0
          text: "Week ending " + dateEnd.toLocaleDateString("en-US")
        }
        ItemDelegate {
          Text {
            anchors.centerIn: parent
            font.pointSize: 16
            font.family: iconFont.name
            text: calendarShown ? MD.icons.expand_less : MD.icons.expand_more
          }
          onClicked: function() {
            calendarShown = !calendarShown
          }
        }
      }
      
      ColumnLayout {
        visible: calendarShown
        Layout.maximumWidth: mainStack.width / 3
        Layout.minimumWidth: mainStack.width / 4
        Layout.alignment: Qt.AlignHCenter

        Text {
          Layout.alignment: Qt.AlignHCenter
          text: months[dateEnd.getMonth()]
        }

        DayOfWeekRow {
          locale: grid.locale
          Layout.fillWidth: true
        }

        MonthGrid {
          id: grid
          month: dateEnd.getMonth()
          Layout.fillWidth: true
          locale: Qt.locale("en_US")
          delegate: ItemDelegate {
            height: 16;
            Text {
              anchors.centerIn: parent
              text: model.day
              color: if (model.day == dateEnd.getDate() && model.date.getMonth() == date.getMonth()) {
                "orange" 
              } else if (model.day <= new Date().getDate()) {
                "black"
              } else {
                "grey"
              }
            }
            onClicked: function() {
              var newDate = new Date()

              if (model.day <= newDate.getDate()) {
                newDate.setDate(model.date.getDate() + 1)
                dateEnd = newDate
                issuanceReportCard.update()
              }
            }
          }
        }
      }

      IssuanceReportCard {
        id: issuanceReportCard
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: reportPage.width - 12
        Layout.leftMargin: 6
        date: dateEnd
      }
    }
  }
}