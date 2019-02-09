import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

Item {
  property var user
  anchors.fill: parent

  function reset() {
    user = null
    swipe.currentIndex = 0
  }

  SwipeView {
    id: swipe
    currentIndex: 0
    interactive: false
    anchors.fill: parent

    // A column view with all the fields
    ColumnLayout {
      id: dataEntryColumn
      // Show a logo to fill whitespace
      FullLogo {
        Layout.alignment: Qt.AlignHCenter
        Layout.maximumWidth: checkOutBookWindow.width/1.5
        Layout.maximumHeight: checkOutBookWindow.height/6
      }

      Text {
        Layout.alignment: Qt.AlignHCenter
        text: "Edit user"
      }

      GridLayout {
        id: dataFieldGrid

        Layout.alignment: Qt.AlignCenter
        Layout.maximumWidth: checkOutBookWindow.width / 1.5

        // Set the number of columns to 2
        columns: 2

        Label {
          id: firstNameLabel
          text: "First Name "
        }
        // We create a validatable field, so there are no errors in the future
        ValidatableField {
          id: firstNameField
          // Set the initial text
          text: user ? user.firstname : ""
          // and have it fill the width of the layout
          Layout.fillWidth: true
          // We write a validate function which will be called when the button is pressed
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
          text: user ? user.lastname : ""
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
          text: user ? user.email : ""
          Layout.fillWidth: true
          function validate () {
            // Using a RegEx, validate if the email is valid
            var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            var valid = re.test(text)
            emailLabel.Material.foreground = ((valid) ? Material.Black : Material.Red)
            return valid
          }
        }
      }

      // Create an error label in case invalid input is entered.
      Label {
        id: createErrorLabel
        text: "One or more fields has invalid or no input."
        Material.foreground: Material.Red
        Layout.alignment: Qt.AlignHCenter
        // Make it invisible unless it's needed
        visible: false
      }

      Button {
        text: "Submit"
        // align it in the center...
        Layout.alignment: Qt.AlignHCenter
        highlighted: true
        // ...and set the function to be called on click.
        onClicked: function() {
          var validations = [
            emailField.validate(),
            firstNameField.validate(),
            lastNameField.validate()
          ]
          // If all of them are valid, we can proceed by...
          var valid = validations.every(function(x) { return x })
          if (valid) {
            createErrorLabel.visible = false
            EditStudentViewModel.init_for_student(
              user.id,
              firstNameField.text,
              lastNameField.text,
              emailField.text
            )
            EditStudentViewModel.start_fetch()
            swipe.currentIndex += 1
          } else {
            createErrorLabel.visible = true
          }
        }
      }

    }

    WebContent {
      id: resultPage
      ColumnLayout {
        visible: false
        anchors.fill: parent
        id: successColumn
        
        // show a logo in the center to fill whitespace,
        FullLogo {
          Layout.alignment: Qt.AlignHCenter
          Layout.maximumWidth: checkOutBookWindow.width/1.5
          Layout.maximumHeight: checkOutBookWindow.height/6
        }

        Text {
          Layout.alignment: Qt.AlignHCenter
          text: "Successfully edited student."
        }

        Button {
          text: "Done"
          Layout.alignment: Qt.AlignHCenter
          highlighted: true

          onClicked: function() {
            editStudentWindow.close()
          }
        }
      }
    }
  }

  Connections {
    target: EditStudentViewModel
    onNetwork_state: function(state) {
      switch (state.state) {
        case NetworkState.active:
          resultPage.loadingIndicator.visible = true
          break
        case NetworkState.error:
          resultPage.loadingIndicator.visible = false
          resultPage.errorMessage.text = "There has been an error editing this student."
          resultPage.errorMessage.visible = true
          break
        case NetworkState.done:
          // If it's successful, say so!
          resultPage.loadingIndicator.visible = false
          successColumn.visible = true
          break
      }
    }
  }
}