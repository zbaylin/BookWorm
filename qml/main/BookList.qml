import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"

GridView {
  property string name: "Book List"
  id: bookGridView
  model: BookListModel
  cellWidth: 180; cellHeight: 220
  delegate: ItemDelegate {
    width: bookGridView.cellWidth
    height: bookGridView.cellHeight
    Column {
      anchors.fill: parent
      anchors.topMargin: 20
      Image {
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
        width: parent.width / 1.5
        height: parent.height / 1.5
        source: "../../assets/thumbs/" + isbn
      }
      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: title
        font.bold: true
      }
      Text {
        anchors.horizontalCenter: parent.horizontalCenter
        text: author
      }
    }
  }
}