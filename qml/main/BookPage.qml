import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

Item {
  property string isbn
  id: bookPage
  width: mainStack.width
  height: mainStack.height
  ScrollView {
    // Set the height and width of the ScrollView to
    // that of the mainStack
    height: mainStack.height
    width: mainStack.width

    /*
      Because this view scrolls, it has two height properties:
        1. The view height
        2. The height of it's children
      The contentHeight needs to be set to the implicit width
      (the sum of all the widths of it's childen) of the 
      column layout.
    */
    contentHeight: column.implicitHeight
    // We want to always show the scrollbar so the user knows there
    // is more information
    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
    
    // Encase all the elements in the ScrollView in a ColumnLayout...
    ColumnLayout {
      // ...which we will call 'column'
      id: column
      // set tge 
      height: parent.height

      // A rectangle to make the book cover look pretty...
      Item {
        // ...which we will call 'imgContainer'
        id: imgContainer
        // Set it's height to 400 (looks good on most screens)...
        height: 400
        // ...and enforce it.
        Layout.minimumHeight: height
        Layout.preferredHeight: height
        Layout.preferredWidth: mainStack.width
        // Center it in the screen
        Layout.alignment: Qt.AlignHCenter

        // We show the cover itself with no effects...
        Image {
          // ...and call it 'foreImg'
          id: foreImg
          // Show it above the background in space
          z: 2
          // Acquire the image from BookWormServer
          source: hostname + "/api/book/" + isbn + "/cover_image"
          // Make it look like a book cover (don't crop it)
          fillMode: Image.PreserveAspectFit
          // and set it's height and width
          height: parent.height
          width: mainStack.width
        }

        // Now we prepare the blurred background image...
        Image {
          // ...and call it 'backImg'
          id: backImg
          // Get it from BookWormServer
          source: hostname + "/api/book/" + isbn + "/cover_image"
          // Have it fill the background
          fillMode: Image.PreserveAspectCrop
          // Set it's height and width
          height: parent.height
          width: mainStack.width
          // Make it invisible, because we haven't blurred it yet
          visible: false
          // Scale it nicely
          smooth: true
        }
        // And now we blur the image
        FastBlur {
          // Set it to fill the image
          anchors.fill: backImg
          // And the source as the image
          source: backImg
          // Set the blur radius to 48, so it's easy to tell where the cover is.
          radius: 48
        }
      }
      Card {
        width: mainStack.width
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: mainStack.width*.9
        Layout.minimumHeight: 200
        Layout.preferredHeight: bookInfo.height
        BookInfo {
          id: bookInfo
          anchors.fill: parent
          width: parent.width
        }
      }
    }
  }
}