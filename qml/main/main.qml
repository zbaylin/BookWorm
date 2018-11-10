import QtQuick 2.11
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.1

ApplicationWindow {
  property string name : ""
  property string school : ""
  id: mainWindow
  visible: true

  width: 1280
  height: 720
  title: name + "'s Library: " + school

}