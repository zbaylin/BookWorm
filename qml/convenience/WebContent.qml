/* 
  -- the template file for all WebContent --
  This is a base class for views that acquire their
  data from the internet.
*/
import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0

Item {
  // Exposes the loading indicator and error message components
  property alias loadingIndicator: loading
  property alias errorMessage: error

  // Convenience method to show an error
  function showErrorMessage(message) {
    errorMessage.text = message
    loadingIndicator.visible = false
    errorMessage.visible = true
  } 

  // Loading indicator
  BusyIndicator {
    running: true
    visible: false
    id: loading
    anchors.centerIn: parent
  }

  // Error message
  Text {
    visible: false
    id: error
    color: "red"
    anchors.centerIn: parent
  }
}