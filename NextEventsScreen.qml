import QtQuick 2.7
import QtQuick.Controls 2.1
import Event 1.0

Rectangle {
	id: root
	anchors.fill: parent
	color: "#9CFADA"

	Rectangle {
		id: refreshButton
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		anchors.left: parent.left
		height: parent.height / 15

		Label {
			anchors.centerIn: parent

			text: "Refresh"
		}

		MouseArea {
			anchors.fill: parent

			onClicked: {
				database.deleteNextEventsList()
				database.addEventsForNextSevenDays(new Date())
				nextEventsModel.updateModel()
			}
		}
	}

	ListView {
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: refreshButton.top
		model: nextEventsModel
		visible: true
		header: Rectangle {
			height: root.height / 10
			width: root.width

			Label {
				anchors.centerIn: parent
				text: "Next Events"
			}
		}

		delegate: ItemDelegate {
			height: root.height / 5
			width: root.width
			text: "Name: " + name + "\nStart: " + Qt.formatDateTime(start, "hh:mm, dd.MM.yyyy") + "\nEnd: " + Qt.formatDateTime(end, "hh:mm, dd.MM.yyyy")

			background: Rectangle {
				anchors.fill: parent
				color: "#FF0000"
			}

			onClicked: {
				parent.height = parent.height / 2
			}
		}
	}
}
