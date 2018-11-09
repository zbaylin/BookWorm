import QtQuick 2.11
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1

ApplicationWindow {
  id: mainWindow
  visible: true
  title: "Setup Wizard"

  width: 400
  height: 450

  Material.theme: Material.Light
  Material.accent: Material.Blue

  function onUserCreated(success, firstName) {
    console.log(success, firstName)
  }

  SwipeView {
    id: swipe
    currentIndex: 0
    anchors.fill: parent

    GetStarted {

    }

    CreateUser {

    }
  }
}