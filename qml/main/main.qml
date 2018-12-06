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

    // Adds a title to the menubar
    Text {
      // Sets the text color to white
      color: "white"

      // Centers the title in the menubar
      anchors.verticalCenter: parent.verticalCenter
      anchors.horizontalCenter: parent.horizontalCenter

      // Sets the title to the name of the user and the name of their school
      text: name + "'s Library: " + school
      // Sets the font size to 14pt
      font.pointSize: 14.0
    }
  }

  // A hamburger menu/sidemenu that serves as the main navigational tool for the app 
  Drawer {
    id: drawer
    // Uses the global property to determine whether or not the menu is open
    visible: menuOpen
    modal: menuOpen

    /*
      Sets the drawer to be interactive. This means the user can click out
      of it and it will close
    */
    interactive: true

    // Sets the menuOpen property to false when the user closes the menu
    onClosed: function() {
      mainWindow.menuOpen = false
    }

    // Sets the size of the menu
    width: mainWindow.width / 4
    height: mainWindow.height

    // A list to hold all the elements of the menu
    ListView {
      id: drawerList
      anchors.fill: parent

      // We want it to overlay the header
      headerPositioning: ListView.OverlayHeader
      // Sets the header to a rectangle
      header: Rectangle {
        id: drawerHeader
        // Sets the width to span the whole sidemenu
        width: parent.width
        // Sets the height to 200
        height: 200
        // Moves it up on the z-axis so that it covers the other items on scroll
        z: 2 

        // Loads in a preset image as a background to the header
        Image {
          id: bookcaseHeaderImage
          anchors.fill: parent
          source: "../../assets/img/bookcase.jpg"
        }

        // Loads in the logo to the header
        FullLogo {
          id: headerLogo
          anchors.centerIn: parent
          source: "../../assets/img/full-logo-white.svg"
        }

        // Adds a drop shadow to the logo
        DropShadow {
          anchors.fill: headerLogo
          horizontalOffset: 3
          verticalOffset: 3
          radius: 8.0
          samples: 16
          color: "darkgrey"
          source: headerLogo
        }
        
        // Adds a separator between the menu items and the header
        MenuSeparator {
          parent: drawerHeader
          width: parent.width
          anchors.verticalCenter: parent.bottom
          visible: !drawerList.atYBeginning
        }
      }

      // Creates a list of modelElements, which are different views      
      readonly property var modelElements: [
        {
          name: "Book List",
          viewID: bookList
        }
      ]
      /*
        Creates an empty list model. We need to do this because
        QML won't allow compile time creation of list models
        with dynamic content (the viewIDs) 
      */
      model: ListModel {}

      // When the component has loaded...
      Component.onCompleted: {
        // ...append each modelElement to the list model
        modelElements.forEach(function(element) {
          model.append(element)
        })
      }

      // Renders each modelElement
      delegate: ItemDelegate {
        Label {
          anchors.horizontalCenterOffset: 20
          anchors.verticalCenter: parent.verticalCenter
          text: "    " + name
        }
        width: parent.width
        // When the list item is clicked, push the view to the StackView
        onClicked: function () {
          mainStack.push(viewID)
          mainWindow.menuOpen = false
        }
      }
    }
  }

  /*
    The main container for all the views. 
  */
  StackView { 
    id: mainStack
    initialItem: bookList
    anchors.fill: parent

    // All the possible views to be switched to
    BookList {id: bookList; anchors.fill: parent}
  }
}