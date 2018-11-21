import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/MaterialDesign.js" as MD

ApplicationWindow {
  property string name : ""
  property string school : ""
  id: mainWindow
  visible: true


  // Set the color scheme of the application (Light and Blue)
  Material.theme: Material.Light
  Material.accent: Material.Blue

  property bool menuOpen: false

  // Set the default window size to 1280x720
  width: 1280
  height: 720

  // Set the window title to the user's name and their school
  title: "BookWorm"

  /* 
    Loads the material icons font, so we can 
    use things like a hambuerger menu icon, etc. 
  */
  FontLoader {
    id: iconFont
    source: "../../assets/fonts/MaterialIcons-Regular.ttf"
  }

  // Sets the header to be a tool bar
  header: ToolBar {
    id: toolBar
    
    // Raises the toolbar to be above all standard elements
    z: 1

    // Sets the background of the toolbar to blue
    Material.background: Material.Blue
    // Sets the foreground of the toolbar (text color, etc.) to white
    Material.foreground: "white"

    // Adds a clickable hamburger menu button to trigger the menu
    MouseArea {
      // Creates a square for the button to "sit in"
      width: toolBar.height
      height: toolBar.height

      // Centers the button vertically in the toolbar
      anchors.verticalCenter: parent.verticalCenter

      // The actual icon for the button
      Text {
        // Centers the icon in the square
        anchors.centerIn: parent
        // Colors the button white
        color: "white"
        // Sets the font to be the icon font we loaded earlier
        font.family: iconFont.name
        // Sets the size of the icon to be 60% of the height of the toolbar
        font.pixelSize: toolBar.height * 0.6
        // Sets the icon to be the menu icon (see material.io)
        text: MD.icons.menu
      }

      // Sets the function to be called when the hamburger menu button is pressed
      onPressed: function() {
        // Sets the mainWindow menuOpen property to true, which opens the menu
        mainWindow.menuOpen = true
      }
    }

    Text {
      color: "white"
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter

      text: name + "'s Library: " + school
      font.pointSize: 14.0
    }
  }

  Drawer {
    id: drawer
    visible: menuOpen
    modal: menuOpen
    interactive: true
    onClosed: function() {
      mainWindow.menuOpen = false
    }

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
      
      readonly property var modelElements: [
        {
          name: "Book List",
          viewID: bookList
        }
      ]
      model: ListModel {}

      Component.onCompleted: {
        modelElements.forEach(function(element) {
          model.append(element)
        })
      }

      delegate: ItemDelegate {
        Label {
          anchors.horizontalCenterOffset: 20
          anchors.verticalCenter: parent.verticalCenter
          text: "    " + name
        }
        width: parent.width
        onClicked: function () {
          mainStack.push(viewID)
          mainWindow.menuOpen = false
        }
      }
    }
  }

  StackView { 
    id: mainStack
    initialItem: bookList
    anchors.fill: parent

    Component { id: bookList; BookList {} }
  }
}