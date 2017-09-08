import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.1
import Event 1.0

Rectangle {
	id: menuBarRoot
	property NavigationDrawer drawer
	property Event event
	property PageController controller

	anchors.left: parent.left
	anchors.right: parent.right
	height: parent.height / 12
//	color: "#0000FF"
	color: "#0A2AEA"		// = "blue"
//	color: "darkblue"

	states: [
		State {
			name: "createEvent"

			PropertyChanges {
				target: saveButton
				visible: true
			}

			PropertyChanges {
				target: cancelButton
				visible: true
			}
		}
	]

	Rectangle {
		id: menuButton
		anchors.left: parent.left
		width: height * 1.2
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		color: parent.color

		Rectangle {
			id: firstRect
			anchors.verticalCenter: parent.verticalCenter
			anchors.horizontalCenter: parent.horizontalCenter
			height: parent.height / 10
			width: height * 5
		//	color: "#FFFFFF"
		}

		Rectangle {
			x: firstRect.x
			y: firstRect.y - height * 1.75
		//	anchors.verticalCenter: parent.verticalCenter
		//	anchors.horizontalCenter: parent.horizontalCenter
		//	height: firstRect.height
		//	width: firstRect.width
			height: parent.height / 10
			width: height * 5
		//	color: "#00FF00"
		}

		Rectangle {
			x: firstRect.x
			y: firstRect.y + height * 1.75
		//	anchors.verticalCenter: parent.verticalCenter
		//	anchors.horizontalCenter: parent.horizontalCenter
		//	height: firstRect.height
		//	width: firstRect.width
			height: parent.height / 10
			width: height * 5
		//	color: "#FF0000"
		}

		states: [
			State {
				name: "pressedMenu"

				PropertyChanges {
					target: menuButton
				//	color: Qt.lighter(menuButton.color, 1.2)
					color: "#7777FF"
				}
			},

			State {
				name: "pressedSave"

				PropertyChanges {
					target: saveButton
					color: "#7777FF"
				}
			},

			State {
				name: "pressedCancel"

				PropertyChanges {
					target: cancelButton
					color: "#7777FF"
				}
			}
		]

		transitions: [
			Transition {
				from: ""
				to: "pressedMenu"

				ColorAnimation {
					duration: 700
				}
			},

			Transition {
				from: ""
				to: "pressedSave"

				ColorAnimation {
					duration: 700
				}
			},

			Transition {
				from: ""
				to: "pressedCancel"

				ColorAnimation {
					duration: 700
				}
			}
		]

		MouseArea {
			anchors.fill: parent

			onPressed: {
				menuButton.state = "pressedMenu"
			}

			onReleased: {
				menuButton.state = ""
			}

			onClicked: {
				menuBarRoot.drawer.show()
			//	drawer.toggle()
				menuBarRoot.drawer.completeSlideDirection()
			}
		}
	}

	Rectangle {
		id: cancelButton
		visible: false
		anchors.right: saveButton.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom
	//	width: cancelButtonText.width * 1.3
		anchors.left: menuButton.right
		color: parent.color
	//	color: Qt.lighter(parent.color, 1.1)

		property alias mousearea: mouseareaCancel

		Text {
			id: cancelButtonText
			anchors.centerIn: parent
			text: "Cancel"
			color: "#FFFFFF"
		}

		MouseArea {
			id: mouseareaCancel
			anchors.fill: parent

			onPressed: {
				menuButton.state = "pressedCancel"
			}

			onReleased: {
				menuButton.state = ""
			}

			onClicked: {
				controller.createLoader.item.hideKeyboard()
				controller.state = "main"
			}
		}
	}

	Rectangle {
		id: saveButton
		visible: false
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.bottom: parent.bottom
//		width: saveButtonText.width * 1.3
		width: (menuBarRoot.width - menuButton.width) / 2
		color: parent.color
	//	color: Qt.lighter(parent.color, 1.1)

		Text {
			id: saveButtonText
			anchors.centerIn: parent
			text: "Save"
			color: "#FFFFFF"
		}

		MouseArea {
			id: mouseareaSave
			anchors.fill: parent

			onPressed: {
				menuButton.state = "pressedSave"
			}

			onReleased: {
				menuButton.state = ""
			}

			onClicked: {
				database.writeEvent(event)
				backgroundwork.updateBackground()
				controller.createLoader.item.hideKeyboard()
				controller.state = "main"
			}
		}
	}
}
