import QtQuick 2.7
import QtQuick.Controls 2.1
import Event 1.0

Rectangle {
	id: timeChooser
	visible: false
	opacity: 0.0
	color: "transparent"

	property Event event
	property Label label
	property bool start
	property color selectionColor: "#FF0000"
	property int selectedHour: (start) ? event.startTime.getHours() : event.endTime.getHours()
	property int selectedMin: (start) ? event.startTime.getMinutes() : event.endTime.getMinutes()

	onVisibleChanged: {
		if(visible) {
			selectedHour = (start) ? event.startTime.getHours() : event.endTime.getHours()
			selectedMin = (start) ? event.startTime.getMinutes() : event.endTime.getMinutes()
			for(var a = 0; a < clockAM.count; ++a)
				clockAM.itemAt(a).visible = true
			for(var b = 0; b < clockPM.count; ++b)
				clockPM.itemAt(b).visible = true
			for(var c = 0; c < clockMin.count; ++c)
				clockMin.itemAt(c).visible = false
			for(var d = 0; d < clockMins.count; ++d)
				clockMins.itemAt(d).visible = false
		}
	}

	states: [
		State {
			name: "shown"

			PropertyChanges {
				target: timeChooser
				visible: true
				opacity: 1.0
			}
		}
	]

/*	transitions: [
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
		anchors.bottom: parent.top
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottomMargin: parent.height / 7

		Label {
			anchors.centerIn: parent
			text: selectedHour + ":" + selectedMin
			font.pixelSize: timeChooser.height / 7
			font.bold: true
		}
	}

	Rectangle {
		height: width
		width: parent.width
		radius: 0.5 * height
		color: "#FFFFFF"
		border.color: "#D0D0D0"
		border.width: 1

		MouseArea {
			anchors.fill: parent

			onPositionChanged: {
				if(parent.childAt(mouseX, mouseY) != null) {
					if(parent.childAt(mouseX, mouseY).objectName == "numsAM" || parent.childAt(mouseX, mouseY).objectName == "numsPM") {
						selectedHour = parent.childAt(mouseX, mouseY).value
					}
					else if(parent.childAt(mouseX, mouseY).objectName == "lineMins") {
						selectedMin = parent.childAt(mouseX, mouseY).value
					}
					else if(parent.childAt(mouseX, mouseY).objectName == "numsMin") {
						selectedMin = parent.childAt(mouseX, mouseY).value
					}
				}
			}

			onReleased: {
				if(parent.childAt(mouseX, mouseY) != null) {
					if(parent.childAt(mouseX, mouseY).objectName == "numsAM" || parent.childAt(mouseX, mouseY).objectName == "numsPM") {
						selectedHour = parent.childAt(mouseX, mouseY).value
						for(var a = 0; a < clockAM.count; ++a)
							clockAM.itemAt(a).visible = false
						for(var b = 0; b < clockPM.count; ++b)
							clockPM.itemAt(b).visible = false
						for(var c = 0; c < clockMin.count; ++c)
							clockMin.itemAt(c).visible = true
						for(var d = 0; d < clockMins.count; ++d)
							clockMins.itemAt(d).visible = true
					}
					else if(parent.childAt(mouseX, mouseY).objectName == "numsMin") {
						if(parent.childAt(mouseX, mouseY).value == selectedMin)
							okMouseArea.clicked(mouse)
						else
							selectedMin = parent.childAt(mouseX, mouseY).value
					}
					else if(parent.childAt(mouseX, mouseY).objectName == "lineMins") {
						if(parent.childAt(mouseX, mouseY).value == selectedMin)
							okMouseArea.clicked(mouse)
						else
							selectedMin = parent.childAt(mouseX, mouseY).value
					}
				}
			}
		}

		Repeater {
			id: clockAM
			model: 12
			property bool startOnZero: false
			delegate: Rectangle {
				objectName: "numsAM"
				height: timeChooser.height / 7
				x: timeChooser.width / 2 - width / 2 + (Math.cos((value - 3) * 30 * Math.PI/180)) * (timeChooser.width / 2 - width / 1.7)
				y: timeChooser.width / 2 - width / 2 + (Math.sin((value - 3) * 30 * Math.PI/180)) * (timeChooser.width / 2 - width / 1.7)
				width: height
				radius: 0.5 * height
				color: (selected) ? "#00FFFF" : "#FFFF00"
				property int value: (clockAM.startOnZero) ? index : index + 1
				property bool selected: (selectedHour == value)

				Label {
					anchors.centerIn: parent
					text: parent.value
				}
			}
		}

		Repeater {
			id: clockPM
			model: 12
			delegate: Rectangle {
				objectName: "numsPM"
				height: timeChooser.height / 7 * 0.8
				x: timeChooser.width / 2 - width / 2 + (Math.cos((value - 3) * 30 * Math.PI/180)) * (timeChooser.width / 2 - width * 2)
				y: timeChooser.width / 2 - width / 2 + (Math.sin((value - 3) * 30 * Math.PI/180)) * (timeChooser.width / 2 - width * 2)
				width: height
				radius: 0.5 * height
				color: (selected) ? "#00FFFF" : "#FFFF00"
				property int value: (clockAM.startOnZero) ? index + 12 : (index == 11) ? 0 : index + 13
				property bool selected: (selectedHour == value)

				onSelectedChanged: {
					update()
				}

				Label {
					anchors.centerIn: parent

					text: value
				}
			}
		}

		Repeater {
			id: clockMin
			model: 12
			delegate: Rectangle {
				objectName: "numsMin"
				height: timeChooser.height / 10
				x: timeChooser.width / 2 - width / 2 + (Math.cos((index - 3) * 30 * Math.PI/180)) * (timeChooser.width / 2 - width * 0.6)
				y: timeChooser.width / 2 - width / 2 + (Math.sin((index - 3) * 30 * Math.PI/180)) * (timeChooser.width / 2 - width * 0.6)
				width: height
				radius: 0.5 * height
				color: (selected) ? "#00FFFF" : "#FFFF00"
				property int value: index * 5
				property bool selected: (selectedMin == value)
				visible: false

				Label {
					anchors.centerIn: parent
					text: value
				}
			}
		}

		Repeater {
			id: clockMins
			model: 60
			delegate: Rectangle {
				objectName: "lineMins"
				height: timeChooser.height / 10
				width: height / 2
				x: timeChooser.width / 2 - width / 2 - Math.cos((value + clockMins.count/4) * 360/clockMins.count * Math.PI/180) * (timeChooser.width / 2 - height / 2)
				y: timeChooser.width / 2 - height / 2 - Math.sin((value + clockMins.count/4) * 360/clockMins.count * Math.PI/180) * (timeChooser.width / 2 - height / 2)
				rotation: 360/clockMins.count * index
				property int value: index
				property bool selected: (selectedMin == value)
				color: "transparent"

				Rectangle {
					anchors.centerIn: parent
					visible: (index % 5 != 0)
					color: "#E0E0E0"
					height: timeChooser.height / 25
					width: height / 4
				}

				Rectangle {
					x: parent.width/2 - width/2
					y: height * 0.1
					visible: parent.selected && (index % 5 != 0)
					height: parent.height
					width: height
					radius: height * 0.5
					color: "#00FFFF"
				}
			}
		}

		Rectangle {
			id: okButton
			width: parent.width / 3
			height: parent.height / 3
			radius: 0.5 * height
			border.color: "#D0D0D0"
			border.width: 1
			x: timeChooser.width / 2 - width / 2
			y: timeChooser.width / 2 - width / 2

			Label {
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				anchors.topMargin: parent.height * 0.3

				text: "Ok"
				horizontalAlignment: Text.AlignHCenter
			}

			MouseArea {
				id: okMouseArea
				anchors.top: parent.top
				anchors.right: parent.right
				anchors.left: parent.left
				height: parent.height / 2

				onClicked: {
					if(timeChooser.start) {
						var temp = event.startTime
						temp.setMinutes(selectedMin)
						temp.setHours(selectedHour)
						event.startTime = temp
						timeChooser.label.text = Qt.formatTime(event.startTime, "hh:mm")
					}
					else {
						var temp = event.endTime
						temp.setMinutes(selectedMin)
						temp.setHours(selectedHour)
						event.endTime = temp
						timeChooser.label.text = Qt.formatTime(event.endTime, "hh:mm")
					}
					timeChooser.state = ""
				}
			}
		}

		Rectangle {
			id: cancelButton
			width: parent.width / 3
			height: parent.height / 3
			radius: 0.5 * height
			color: "transparent"
			border.color: "#D0D0D0"
			border.width: 1
			x: timeChooser.width / 2 - width / 2
			y: timeChooser.width / 2 - width / 2

			Label {
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.bottom: parent.bottom
				anchors.bottomMargin: parent.height * 0.3

				text: "Cancel"
				horizontalAlignment: Text.AlignHCenter
			}

			MouseArea {
				id: cancelMouseArea
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				anchors.left: parent.left
				height: parent.height / 2

				onClicked: {
					timeChooser.state = ""
				}
			}
		}

	}

	Rectangle {
		id: minusButton

		anchors.left: parent.left
		anchors.bottom: parent.bottom
		height: parent.height / 7
		width: height
		radius: 0.5 * height

		Image {
			id: minusImage
			anchors.fill: parent
			source: "qrc:/images/Math_Minus.png"
		}

		MouseArea {
			anchors.fill: parent

			onClicked: {
				if(clockAM.itemAt(0).visible)
					--selectedHour
				else
					--selectedMin
			}
		}
	}

	Rectangle {
		id: plusButton

		anchors.right: parent.right
		anchors.bottom: parent.bottom
		height: parent.height / 7
		width: height
		radius: 0.5 * height

		Image {
			id: plusImage
			anchors.fill: parent
			source: "qrc:/images/Math_Plus.png"
		}

		MouseArea {
			anchors.fill: parent

			onClicked: {
				if(clockAM.itemAt(0).visible) {
					if(selectedHour < 23)
						++selectedHour
					else
						selectedHour = 0
				}
				else {
					if(selectedMin < 59)
						++selectedMin
					else
						selectedMin = 0
				}
			}
		}
	}
}
