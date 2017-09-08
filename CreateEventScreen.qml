import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import Event 1.0

Rectangle {
	id: root
	anchors.fill: parent
	color: "#FFFF00"
	gradient: Gradient {
		GradientStop { position: 0.0; color: "#EEEE00" }
		GradientStop { position: 1.0; color: "#FFFFFF" }
	}

	property Event event
	property alias datechooser: dateChooser
	property alias timechooser: timeChooser

	function hideKeyboard() {
		nameInput.focus = false
		descriptionInput.focus = false
	}

	ScrollView {
		id: scroller
	//	anchors.topMargin: parent.height / 30
		anchors.fill: parent
		flickableItem.boundsBehavior: Flickable.StopAtBounds
		horizontalScrollBarPolicy: ScrollBar.AlwaysOff
		verticalScrollBarPolicy: ScrollBar.AlwaysOn
	//	ScrollBar.horizontal.interactive: false
	//	ScrollBar.vertical.interactive: false

		contentItem:  Rectangle {
			height: root.height
			width: root.width
			color: "transparent"
			MouseArea {
				anchors.fill: parent

				onClicked: {
					hideKeyboard()
				}
			}

			Column {
			id: column
			y: spacing
			spacing: viewHeight / 50
			property int viewHeight: scroller.viewport.height
			property int viewWidth: scroller.viewport.width

			Rectangle {
			//	anchors.horizontalCenter: parent.horizontalCenter
				x: parent.viewWidth / 2 - width / 2
				height: column.viewHeight / 20
				width: column.viewWidth * 0.9
				border.color: "#D0D0D0"
				border.width: 1
				color: Qt.lighter(root.color, 1.8)

				TextInput {
					id: nameInput
					anchors.fill: parent
					anchors.leftMargin: height * 0.3
					anchors.rightMargin: height * 0.3
					anchors.horizontalCenter: parent.horizontalCenter
					verticalAlignment: Text.AlignVCenter
				//	text: qsTr("Event Name")
					font.pixelSize: height * 0.7
					selectByMouse: true
					layer.enabled: true

					onTextChanged: {
						event.eventName = text
					}

					onAccepted: focus = false
				}

				Label {
					visible: (nameInput.length <= 0)
					anchors.fill: parent
					anchors.leftMargin: height * 0.3
					anchors.rightMargin: height * 0.3
					anchors.horizontalCenter: parent.horizontalCenter
					verticalAlignment: Text.AlignVCenter
					text: qsTr("Event Name")
					font.pixelSize: height * 0.7
					color: "#D0D0D0"
				}
			}

			Rectangle {
			//	anchors.horizontalCenter: parent.horizontalCenter
				x: parent.viewWidth / 2 - width / 2
				height: column.viewHeight / 20
				width: column.viewWidth * 0.8
				border.color: "#D0D0D0"
				border.width: 1
				color: Qt.lighter(root.color, 1.8)

				TextInput {
					id: descriptionInput
					anchors.fill: parent
					anchors.leftMargin: height * 0.3
					anchors.rightMargin: height * 0.3
					anchors.horizontalCenter: parent.horizontalCenter
					verticalAlignment: Text.AlignVCenter
				//	text: qsTr("Description")
					font.pixelSize: height * 0.7
					selectByMouse: true
					layer.enabled: true

					onTextChanged: {
						event.eventDescription = text
					}

					onAccepted: focus = false
				}

				Label {
					visible: (descriptionInput.length <= 0)
					anchors.fill: parent
					anchors.leftMargin: height * 0.3
					anchors.rightMargin: height * 0.3
					anchors.horizontalCenter: parent.horizontalCenter
					verticalAlignment: Text.AlignVCenter
					text: qsTr("Description")
					font.pixelSize: height * 0.7
					color: "#D0D0D0"
				}
			}

			Label {
				id: fromLabel
			//	anchors.horizontalCenter: parent.horizontalCenter
				x: parent.viewWidth / 2 - width / 2
				text: qsTr("FROM")
			}

			Row {
			//	anchors.horizontalCenter: parent.horizontalCenter
				x: parent.viewWidth / 2 - width / 2
				spacing: parent.spacing

				Rectangle {
					id: startTime
					height: column.viewHeight / 20
					width: column.viewWidth * 0.4

					Label {
						id: startTimeLabel
						anchors.centerIn: parent
						text: Qt.formatTime(event.startTime, "hh:00")
					}

					MouseArea {
						anchors.fill: parent

						onClicked: {
							root.hideKeyboard()
							timeChooser.label = startTimeLabel
							timeChooser.start = true
							timeChooser.state = "shown"
						}
					}
				}

				Rectangle {
					id: startDate
					height: column.viewHeight / 20
					width: column.viewWidth * 0.4

					Label {
						id: startDateLabel
						anchors.centerIn: parent
						text: Qt.formatDate(event.startTime, "dd.MM.yyyy")
					}

					MouseArea {
						anchors.fill: parent

						onClicked: {
							root.hideKeyboard()
							dateChooser.label = startDateLabel
							dateChooser.start = true
							dateChooser.state = "shown"
						}
					}
				}
			}

			Label {
				id: toLabel
			//	anchors.horizontalCenter: parent.horizontalCenter
				x: parent.viewWidth / 2 - width / 2
				text: qsTr("TO")
			}

			Row {
			//	anchors.horizontalCenter: parent.horizontalCenter
				x: parent.viewWidth / 2 - width / 2
				spacing: parent.spacing

				Rectangle {
					id: endTime
					height: column.viewHeight / 20
					width: column.viewWidth * 0.4

					Label {
						id: endTimeLabel
						anchors.centerIn: parent
						text: Qt.formatTime(event.endTime, "hh:mm")
					}

					MouseArea {
						anchors.fill: parent

						onClicked: {
							root.hideKeyboard()
							timeChooser.label = endTimeLabel
							timeChooser.start = false
							timeChooser.state = "shown"
						}
					}
				}

				Rectangle {
					id: endDate
					height: column.viewHeight / 20
					width: column.viewWidth * 0.4

					Label {
						id: endDateLabel
						anchors.centerIn: parent
						text: Qt.formatDate(event.endTime, "dd.MM.yyyy")
					}

					MouseArea {
						z: 6
						anchors.fill: parent

						onClicked: {
							root.hideKeyboard()
							dateChooser.label = endDateLabel
							dateChooser.start = false
							dateChooser.state = "shown"
						}
					}
				}
			}
		}
		}
	}

	Rectangle {
		id: chooserBackground
	//	width: root.width
	//	height: root.height
		anchors.fill: parent
		color: "#D0D0D0"
		opacity: 0.7
		visible: dateChooser.visible || timeChooser.visible

		MouseArea {
			anchors.fill: parent

			onClicked: {
				dateChooser.state = ""
				timeChooser.state = ""
			}
		}
	}

	DateChooser {
		id: dateChooser
		anchors.centerIn: parent
		width: parent.width * 0.8
		height: width * 1.2
		event: parent.event
	}

	TimeChooser {
		id: timeChooser
		anchors.centerIn: parent
		width: parent.width * 0.8
		height: width
		event: parent.event
	}
}
