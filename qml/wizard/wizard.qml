import QtQuick 2.11
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.1

ApplicationWindow {
  id: mainWindow
  visible: true
  title: "Setup Wizard"


  // Disable resizing of the window. This size looks good.
  minimumWidth: 400
  maximumWidth: 400
  minimumHeight: 450
  maximumHeight: 450

  // Set the color scheme of the application (Light and Blue)
  Material.theme: Material.Light
  Material.accent: Material.Blue

  /*
    In QML, functions are called slots because they can be called
    from C++ or Python (in our case PySide). This provides interactivity
    between our main language (Python) and the declarative GUI
    framework (QML).
  */
  function onUserCreated(success, firstName) {
    if (success) {
      userCreated.name = firstName
      swipe.currentIndex += 1
    } else {
      popup.text = "There has been an error setting up your account. Please try again later."
      popup.visible = true
    }
  }

  /* 
    We create a blank MessageDialog that isn't visible (until we
    change that later). This way we can project an error message
    on this same dialog every time we have an error.
  */
  MessageDialog {
    id: popup
    title: "Error"
    width: 300
    height: 200
    visible: false
  }


  /* 
    The SwipeView allows us to create a progression of "pages".
    Every time we want to go to the next page, we just increment
    the currentIndex property by 1.
  */
  SwipeView {
    id: swipe
    currentIndex: 0
    interactive: false
    anchors.fill: parent

    // See GetStarted.qml
    GetStarted {
      id: getStarted
    }

    // See CreateUser.qml
    CreateUser {
      id: createUser
    }

    // See UserCreated.qml
    UserCreated {
      id: userCreated
    }
  }
}