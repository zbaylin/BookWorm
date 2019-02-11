
import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Window 2.11

// A window to be shown when a student is edited
Window {
  id: editStudentWindow
  width: 400; height: 500;
  title: "Edit User"
  // Set the color scheme of the application (Light and Blue)
  Material.theme: Material.Light
  Material.accent: Material.Blue

  property alias user: editStudentPage.user
  
  // Shows the edit student page in the window
  EditStudentPage { id: editStudentPage }

  // Reset the edit student page when the window closes
  onClosing: function() {
    editStudentPage.reset()
  }
}