import QtQuick 2.2
import QtQuick.Controls 2.1
import QtQml 2.2
import QtTest 1.0
import QtQuick.Controls 1.4

Rectangle {
//	width: parent.width
//	height: parent.height / 5

  color: "#0000FF"

  ListView {
  //	anchors.fill: parent

		width: parent.width
		height: parent.height

		model: eventModel

		section.property: "time"
		section.criteria: ViewSection.FullString
		section.labelPositioning: ViewSection.InlineLabels//ViewSection.NextLabelAtEnd
		section.delegate: ItemDelegate {
			id: sectionDelegate
			width: parent.width
			height: parent.width / 15
	//		color: "#04AEEA"
	//		border.color: "#D0D0D0"
	//		border.width: 1
			font.pixelSize: height * 0.7
			highlighted: false

			text: section

			onClicked: {
				if(sectionLabel.text != "+") {
					sectionLabel.font.pixelSize = parent.height * 0.9
					sectionLabel.text = "+"
				}
				else {
					eventModel.append( { eventName: "Appended: " + section, time: section } )
				//	eventModel.Component.onCompleted = sort()
				//	eventModel.sortLast()
					eventModel.sort()
					sectionLabel.font.pixelSize = parent.height * 0.7
					sectionLabel.text = section
					notificationClient.title = "Added" + eventModel.count
					notificationClient.notification = "Event added" + section
				}
			}
		}

		delegate: ItemDelegate {
			id: delegateRect
		//	y: parent.width / 15
			width: parent.width
			height: (eventName === "") ? 0 : parent.width / 10
		//	border.color: "#C0C0C0"
		//	border.width: 1
			text: eventName
			background: Rectangle {
				anchors.fill: parent
				color: (parent.down) ? "#A0A0A0": "#FFFFFF"
			}
			highlighted: ListView.isCurrentItem
		}

		boundsBehavior: Flickable.StopAtBounds
//		boundsBehavior: Flickable.DragOverBounds	// standard
		orientation: Qt.Vertical					// standard
		cacheBuffer: 1000000//Math.pow(2, 31) - 1
		clip: true
		spacing: 0
	}

	ListModel {
		id: eventModel
		ListElement {
			eventName: ""
			/*readonly*/ time: "00:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "01:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "02:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "03:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "04:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "05:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "06:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "07:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "08:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "09:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "10:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "11:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "12:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "13:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "14:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "15:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "16:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "17:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "18:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "19:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "20:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "21:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "22:00"
		}
		ListElement {
			eventName: "Hi"
			/*readonly*/ time: "01:00"
		}
		ListElement {
			eventName: ""
			/*readonly*/ time: "23:00"
		}
		ListElement {
			eventName: "Hi"
			/*readonly*/ time: "01:00"
		}
		ListElement {
			eventName: "First"
			/*readonly*/ time: "00:00"
		}

		function sort() {
			for(var i = 0; i < count; ++i) {
				for(var j = 0; j < count; ++j) {
					if(get(i).time === get(j).time)
						move(j, i, 1)
				}
			}
		}

		/*function sortLast() {
			for(var i = 0; i < count; ++i) {
				if(get(i).time === get(count - 1).time)
					move(count - 1, i, 1)
			}
		}*/

		Component.onCompleted: sort()
	}
}
