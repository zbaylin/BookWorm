import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

Item {
  SwipeView {
    id: swipe
    currentIndex: 0
    interactive: false
    anchors.fill: parent

    ColumnLayout {
      id: dataEntryColumn

      FullLogo {
        Layout.alignment: Qt.AlignHCenter
        Layout.maximumWidth: mainWindow.width/1.5
        Layout.maximumHeight: mainWindow.height/6
      }

      Text {
        text: "Please fill out the following information in order to create a new student."
        Layout.maximumWidth: mainWindow.width / 1.5
        Layout.alignment: Qt.AlignHCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
      }

      GridLayout {
        id: dataFieldGrid
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
          id: emailLabel
          text: "Email " 
        }
        ValidatableField {
          id: emailField
          placeholderText: "ex. john@smith.com"
          Layout.fillWidth: true
          function validate () {
            var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            var valid = re.test(text)
            emailLabel.Material.foreground = ((valid) ? Material.Black : Material.Red)
            return valid
          }
        }

        Label {
          id: passwordLabel
          text: "Password " 
        }
        ValidatableField {
          id: passwordField
          Layout.fillWidth: true
          echoMode: TextInput.Password
          function validate () {
            var valid = text.length >= 6
            passwordLabel.Material.foreground = ((valid) ? Material.Black : Material.Red)
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
            emailField.validate(),
            passwordField.validate(),
            firstNameField.validate(),
            lastNameField.validate()
          ]
          var valid = validations.every(function(x) { return x })
          if (valid) {
            createErrorLabel.visible = false
            CreateStudentViewModel.init_for_student(
              emailField.text,
              passwordField.text,
              firstNameField.text,
              lastNameField.text
            )
            CreateStudentViewModel.start_fetch()
            swipe.currentIndex += 1
          } else {
            createErrorLabel.visible = true
          }
        } 
      }
    }
    
    WebContent {
      id: successPage
      Text {
        anchors.centerIn: parent
        id: successText
        visible: false
        text: "You have been signed up! You are now able to check out eBooks."
      }
    }
  }

  Connections {
    target: CreateStudentViewModel
    onNetwork_state: function (state) {
      switch (state.state) {
        case NetworkState.active:
          successPage.loadingIndicator.visible = true
          break
        case NetworkState.error:
          successPage.loadingIndicator.visible = false
          successPage.errorMessage.text = "There has been an error creating this user. Please note you can only make one account."
          successPage.errorMessage.visible = true
          break
        case NetworkState.done:
          successPage.loadingIndicator.visible = false
          successText.visible = true
      }
    }
  }
}