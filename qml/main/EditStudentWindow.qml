
import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Window 2.11

Window {
  id: editStudentWindow
  width: 400; height: 500;
  title: "Edit User"
  // Set the color scheme of the application (Light and Blue)
  Material.theme: Material.Light
  Material.accent: Material.Blue

  property alias user: editStudentPage.user
  
  EditStudentPage { id: editStudentPage }

  onClosing: function() {
    editStudentPage.reset()
  }
}