import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

Item {
  property string isbn: ""

  function reset() {
    swipe.currentIndex = 0
    emailField.text = ""
    passwordField.text = ""
    isbn = ""
    successColumn.visible = false
    successPage.errorMessage.visible = false
    successPage.loadingIndicator.visible = false
  }

  SwipeView {
    id: swipe
    currentIndex: 0
    interactive: false
    anchors.fill: parent

    ColumnLayout {
      id: dataEntryColumn
      // show a logo in the center to fill whitespace,
      FullLogo {
        Layout.alignment: Qt.AlignHCenter
        Layout.maximumWidth: checkOutBookWindow.width/1.5
        Layout.maximumHeight: checkOutBookWindow.height/6
      }
      Text {
        Layout.alignment: Qt.AlignHCenter
        text: "Checking Out: ISBN " + isbn
      }
      // and lay out the input.
      // We create a GridLayout,
      GridLayout {
        // call it 'dataFieldGrid'
        id: dataFieldGrid

        // center it,
        Layout.alignment: Qt.AlignCenter
        Layout.maximumWidth: checkOutBookWindow.width / 1.5

        // set the number of columns to 2,
        columns: 2

        // and show the various fields.

        // NB. all fields have (generally) the same properties.
        // We create a label to tell the user what to enter
        Label {
          id: emailLabel
          text: "Email " 
        }
        ValidatableField {
          id: emailField
          placeholderText: "ex. john@smith.com"
          Layout.fillWidth: true
          function validate () {
            // Using a RegEx, validate if the email is valid
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
          var validations = [
            emailField.validate(),
            passwordField.validate()
          ]
          // If all of them are valid, we can proceed by...
          var valid = validations.every(function(x) { return x })
          if (valid) {
            // ...hiding the label, initiating the viewmodel...
            createErrorLabel.visible = false
            CheckOutViewModel.init_for_student(
              emailField.text,
              passwordField.text,
              isbn
            )
            // ...fetching data from the server..
            CheckOutViewModel.start_fetch()
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
      ColumnLayout {
        visible: false
        anchors.fill: parent
        
        id: successColumn

        property string redemptionKey: ""

        // show a logo in the center to fill whitespace,
        FullLogo {
          Layout.alignment: Qt.AlignHCenter
          Layout.maximumWidth: checkOutBookWindow.width/1.5
          Layout.maximumHeight: checkOutBookWindow.height/6
        }

        Text {
          id: redemptionPreLabel
          Layout.alignment: Qt.AlignHCenter
          text: "Your redemption key is:"
        }

        Text {
          id: redemptionKeyLabel
          Layout.alignment: Qt.AlignHCenter
          font.pointSize: 24
          font.weight: Font.Bold
        }

        Text {
          Layout.maximumWidth: checkOutBookWindow.width / 1.5
          id: redemptionPostLabel
          Layout.alignment: Qt.AlignHCenter
          wrapMode: Text.Wrap
          horizontalAlignment: Text.AlignHCenter
          text: "You can redeem and download your eBook at " + hostname
        }

        Button {
          text: "Done"
          Layout.alignment: Qt.AlignHCenter
          highlighted: true

          onClicked: function() {
            checkOutBookWindow.close()
          }
        }
      }
    }
  }
  // We need to bind to the check out view model
  Connections {
    target: CheckOutViewModel
    // And detect when it emits a network signal
    onNetwork_state: function (state) {
      switch (state.state) {
        case NetworkState.active:
          // If it's loading, show a loading indicator
          successPage.loadingIndicator.visible = true
          break
        case NetworkState.error:
          // If there is an error, hide the loading indicator, and show the error message
          successPage.loadingIndicator.visible = false
          successPage.errorMessage.text = "There has been an error checking this book out."
          successPage.errorMessage.visible = true
          break
        case NetworkState.done:
          // If it's successful, show the redemption code
          successPage.loadingIndicator.visible = false
          redemptionKeyLabel.text = state.redemption_key
          successColumn.visible = true
      }
    }
  }
}