import QtQuick 2.11
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1
import "../convenience"

ColumnLayout {
  id: createUserColumn

  FullLogo {
    Layout.alignment: Qt.AlignHCenter
    Layout.maximumWidth: mainWindow.width/1.5
    Layout.maximumHeight: mainWindow.height/4
  }

  Text {
    text: "Please fill out the following information so that we can better personalize your experience."
    Layout.maximumWidth: mainWindow.width / 1.5
    Layout.alignment: Qt.AlignHCenter
    horizontalAlignment: Text.AlignHCenter
    wrapMode: Text.Wrap
  }

  GridLayout {
    id: createUserGrid
    Layout.alignment: Qt.AlignCenter
    Layout.maximumWidth: mainWindow.width / 1.5
    columns: 2

    Label {
      id: firstNameLabel
      text: "First Name "
    } 
    ValidatableField {
      id: firstNameField
      placeholderText: "John"
      Layout.fillWidth: true
      function validate() {
        var valid = text !== ""
        firstNameLabel.Material.foreground = ((valid) ? Material.Black : Material.Red)
        return valid
      }
    }

    Label {
      id: lastNameLabel
      text: "Last Name " 
    }
    ValidatableField {
      placeholderText: "Smith"
      id: lastNameField
      Layout.fillWidth: true
      function validate() {
        var valid = text !== ""
        lastNameLabel.Material.foreground = ((valid) ? Material.Black : Material.Red)
        return valid
      }
    }

    Label {
      id: schoolLabel
      text: "School " 
    }
    ValidatableField {
      id: schoolField
      placeholderText: "ex. North Springs HS"
      Layout.fillWidth: true
      function validate () {
        var valid = text !== ""
        schoolLabel.Material.foreground = ((valid) ? Material.Black : Material.Red)
        return valid
      }
    }
  }
  
  Label {
    id: createErrorLabel
    text: "One or more fields has invalid or no input."
    Material.foreground: Material.Red
    Layout.alignment: Qt.AlignHCenter
    visible: false
  }

  Button {
    text: "Submit"
    Layout.alignment: Qt.AlignHCenter
    highlighted: true
    onClicked: function() {
      var validations = [
        schoolField.validate(),
        firstNameField.validate(),
        lastNameField.validate()
      ]
      var valid = validations.every(function(x) { return x })
      if (valid) {
        wizardInterface.createUser(
          firstNameField.text,
          lastNameField.text,
          schoolField.text
        )
      } else {
        createErrorLabel.visible = true
      }
    } 
  }
}