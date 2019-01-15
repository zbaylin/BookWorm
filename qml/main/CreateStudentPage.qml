import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

Item {
  // We reate a SwipeView so we can have nice transitions between pages,
  SwipeView {
    id: swipe // call it swipe,
    currentIndex: 0 // set it's initial page to the first page,
    interactive: false // make it not interactive,
    anchors.fill: parent // and have it fill the parent.

    // We create a column layout as a pseudo-form,
    ColumnLayout {
      // call it 'dataEntryColumn',
      id: dataEntryColumn

      // show a logo in the center to fill whitespace,
      FullLogo {
        Layout.alignment: Qt.AlignHCenter
        Layout.maximumWidth: mainWindow.width/1.5
        Layout.maximumHeight: mainWindow.height/6
      }

      // give the user some instructions,
      Text {
        text: "Please fill out the following information in order to create a new student."
        Layout.maximumWidth: mainWindow.width / 1.5
        Layout.alignment: Qt.AlignHCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
      }

      // and lay out the input.
      // We create a GridLayout,
      GridLayout {
        // call it 'dataFieldGrid'
        id: dataFieldGrid

        // center it,
        Layout.alignment: Qt.AlignCenter
        Layout.maximumWidth: mainWindow.width / 1.5

        // set the number of columns to 2,
        columns: 2

        // and show the various fields.

        // NB. all fields have (generally) the same properties.
        // We create a label to tell the user what to ender
        Label {
          id: firstNameLabel
          text: "First Name "
        }

        // We create a validatable field, so there are no errors in the future
        ValidatableField {
          id: firstNameField
          // Establish a placeholder text
          placeholderText: "John"
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

      // Create an error label in case invalid input is entered.
      Label {
        id: createErrorLabel
        text: "One or more fields has invalid or no input."
        Material.foreground: Material.Red
        Layout.alignment: Qt.AlignHCenter
        // Make it invisible unless it's needed
        visible: false
      }

      // We make a submit button...
      Button {
        text: "Submit"
        // ...aligned in the center...
        Layout.alignment: Qt.AlignHCenter
        highlighted: true
        // ...and set the function to be called on click.
        onClicked: function() {
          // Validate all the fields
          var validations = [
            emailField.validate(),
            passwordField.validate(),
            firstNameField.validate(),
            lastNameField.validate()
          ]
          // If all of them are valid, we can proceed by...
          var valid = validations.every(function(x) { return x })
          if (valid) {
            // ...hiding the label, initiating the viewmodel...
            createErrorLabel.visible = false
            CreateStudentViewModel.init_for_student(
              emailField.text,
              passwordField.text,
              firstNameField.text,
              lastNameField.text
            )
            // ...fetching from the server...
            CreateStudentViewModel.start_fetch()
            // ...and moving to the next page.
            swipe.currentIndex += 1

          // If not...
          } else {
            // ...show the error label.
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