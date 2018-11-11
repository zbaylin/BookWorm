import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"

ApplicationWindow {
  property string name : ""
  property string school : ""
  id: mainWindow
  visible: true

  width: 1280
  height: 720
  title: name + "'s Library: " + school

  Drawer {
    id: drawer
    visible: true
    modal: false
    interactive: false

    width: mainWindow.width / 4
    height: mainWindow.height

    ListView {
      id: drawerList
      anchors.fill: parent

      headerPositioning: ListView.OverlayHeader
      header: Rectangle {
        id: drawerHeader
        width: parent.width
        height: 200
        z: 2


        Image {
          id: bookcaseHeaderImage
          anchors.fill: parent
          source: "../../assets/img/bookcase.jpg"
        }

        FullLogo {
          id: headerLogo
          anchors.centerIn: parent
          source: "../../assets/img/full-logo-white.svg"
        }

        DropShadow {
          anchors.fill: headerLogo
          horizontalOffset: 3
          verticalOffset: 3
          radius: 8.0
          samples: 16
          color: "darkgrey"
          source: headerLogo
        }

        MenuSeparator {
          parent: drawerHeader
          width: parent.width
          anchors.verticalCenter: parent.bottom
          visible: !drawerList.atYBeginning
        }
      }
      
      model: 10

      delegate: ItemDelegate {
        text: "Test"
        width: parent.width
      }
    }
  }
}