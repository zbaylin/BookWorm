import QtQuick 2.11
import QtCharts 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.11
import QtQuick.Controls.Material 2.2
import QtGraphicalEffects 1.0
import "../convenience"
import "../convenience/NetworkState.js" as NetworkState

Card {
  Component.onCompleted: function() {
    IssuanceReportViewModel.start_fetch()
  }

  id: issuanceReportCard
  ColumnLayout {
    id: mainColumn
    width: parent.width
    Text {
      Layout.alignment: Qt.AlignLeft
      text: "Issuances"
      font.pointSize: 18.0
    }
    WebContent {
      id: webContent
      Layout.preferredWidth: parent.width
      Layout.preferredHeight: webContentColumn.implicitHeight
      ColumnLayout {
        id: webContentColumn
        visible: false
        width: mainColumn.width

        property int numIssuances
        property int numRedeemed

        Text {
          Layout.alignment: Qt.AlignHCenter
          text: "Number of issuances created in the past week"
          font.pointSize: 12.0
          font.bold: true
        }

        Text {
          Layout.alignment: Qt.AlignHCenter
          text: webContentColumn.numIssuances ? webContentColumn.numIssuances : ""
          font.pointSize: 24.0
        }

        ToolSeparator {
          Layout.alignment: Qt.AlignHCenter
          Layout.preferredWidth: mainColumn.width - 100
          orientation: Qt.Horizontal
        }

        Text {
          Layout.alignment: Qt.AlignHCenter
          text: "Redeemed vs. Non-redeemed"
          font.pointSize: 12.0
          font.bold: true
        }

        ChartView {
          Layout.alignment: Qt.AlignHCenter
          Layout.preferredWidth: mainColumn.width * .6
          Layout.preferredHeight: 400
          antialiasing: true
          legend.visible: false

          PieSeries {
            id: pieSeries
            PieSlice {
              property int currentVal: webContentColumn.numRedeemed ? webContentColumn.numRedeemed : 0
              label: "Redeemed: " + currentVal
              labelVisible: true
              value: currentVal
            }

            PieSlice {
              property int currentVal: webContentColumn.numIssuances ?  webContentColumn.numIssuances - webContentColumn.numRedeemed : 0
              label: "Non-redeemed: " + currentVal
              labelVisible: true
              value: currentVal
            }
          } 
        }

      }
    }
  }

  Connections {
    target: IssuanceReportViewModel
    onNetwork_state: function(state) {
      switch (state.state) {
        case NetworkState.active:
          webContent.loadingIndicator.visible = true
          break
        case NetworkState.error:
          webContent.loadingIndicator.visible = false
          webContent.errorMessage.text = "Unable to generate weekly report."
          webContent.errorMessage.visible = true
          break
        case NetworkState.done:
          webContent.loadingIndicator.visible = false
          webContentColumn.visible = true
          webContentColumn.numIssuances = state.numIssuances
          webContentColumn.numRedeemed = state.numRedeemed
      }
    }
  }
}