import QtQuick 2.11
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1

TextField {
  Layout.fillWidth: true
  function validate () { }
  onTextEdited: function () {
    validate()
  }
}