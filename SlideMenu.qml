import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
	id: root

	property int _BORDER: 40

	property bool shown: false
	property bool runningInside: false
	property alias animation: animation

	x: -width
	y: 0
	z: 101

	width: parent.width * (5./7)
	height: parent.height

	color: "#0AFAF0"

	Behavior on x {
		PropertyAnimation {
			id: animation
			duration: 500
		}
		enabled: true
	}

	Button {
		text: "Hide Menu"

		onClicked: {
			menu.x = -menu.width
		}
	}

	function showMenu() {
		x = 0
		shown = true
	}

	function hideMenu() {
		x = -width
		shown = false
	}
}
