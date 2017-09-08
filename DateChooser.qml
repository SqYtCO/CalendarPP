import QtQuick 2.7
import QtQuick.Controls 2.1
import Event 1.0

Rectangle {
	id: dateChooser
	visible: false
	border.color: "#D0D0D0"
	border.width: 1
	opacity: 0.0

	property Event event
	property Label label
	property bool start

	onVisibleChanged: {
		if(visible)
			calendar.selectedDate = (start) ? event.startTime : event.endTime
	}

	states: [
		State {
			name: "shown"

			PropertyChanges {
				target: dateChooser
				visible: true
				opacity: 1.0
			}
		}
	]

/*		transitions: [
		Transition {
			from: "shown"
			to: ""

			OpacityAnimator {
				duration: 1000
				easing.type: Easing.OutElastic
			}
		},

		Transition {
			from: ""
			to: "shown"

			OpacityAnimator {
				duration: 1000
				easing.type: Easing.InBack
			}
		}

	]
*/

	Rectangle {
		id: dateInput
		enabled: false
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		height: parent.height * 0.07

		TextInput {
			anchors.fill: parent
			anchors.rightMargin: height * 0.3
			anchors.leftMargin: height * 0.3
			layer.enabled: true
		//	font.pixelSize: parent.height * 0.7
			font.pointSize: 14
		}
	}

	CalendarView {
		id: calendar
		anchors.top: (dateInput.enabled) ? dateInput.bottom : parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		height: (dateInput.enabled) ? parent.height * 0.85 - dateInput.height : parent.height * 0.85
	}

	Rectangle {
		id: dateChooserCancel
		anchors.top: calendar.bottom
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		width: parent.width / 2
		border.color: "#D0D0D0"
		border.width: 1

		Label {
			anchors.centerIn: parent
			text: "Cancel"
		}

		MouseArea {
			anchors.fill: parent

			onClicked: {
				dateChooser.state = ""
			}
		}
	}

	Rectangle {
		id: dateChooserOk
		anchors.top: calendar.bottom
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		width: parent.width / 2
		border.color: "#D0D0D0"
		border.width: 1

		Label {
			anchors.centerIn: parent
			text: "Ok"
		}

		MouseArea {
			anchors.fill: parent

			onClicked: {
			//	event.startTime.setDate(calendar.selectedDate.getDate())
			//	event.startTime.setMonth(calendar.selectedDate.getMonth())
			//	event.startTime.setYear(calendar.selectedDate.getYear())
				if(start) {
					var temp = event.startTime
					temp.setDate(calendar.selectedDate.getDate())
					temp.setMonth(calendar.selectedDate.getMonth())
					temp.setFullYear(calendar.selectedDate.getFullYear())
					event.startTime = temp
					dateChooser.label.text = Qt.formatDate(event.startTime, "dd.MM.yyyy")
				}
				else {
					var temp = event.endTime
					temp.setDate(calendar.selectedDate.getDate())
					temp.setMonth(calendar.selectedDate.getMonth())
					temp.setFullYear(calendar.selectedDate.getFullYear())
					event.endTime = temp
					dateChooser.label.text = Qt.formatDate(event.endTime, "dd.MM.yyyy")
				}

				dateChooser.state = ""
			}
		}
	}
}
