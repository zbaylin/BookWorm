
import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Window 2.11

Window {
  id: checkOutBookWindow
  width: 400; height: 500;
  title: "Check Out Book"
  visible: false
  // Set the color scheme of the application (Light and Blue)
  Material.theme: Material.Light
  Material.accent: Material.Blue

  property alias isbn: checkOutBookPage.isbn

  // We show the book page in the window
  CheckOutBookPage {
    anchors.fill: parent
    id: checkOutBookPage
  }

  // When the window closes, reset the page
  onClosing: function() {
    checkOutBookPage.reset()
  }
}