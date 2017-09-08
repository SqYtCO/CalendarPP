import QtQuick 2.7
import QtQuick.Controls 2.1

Rectangle {
	anchors.fill: parent

	color: "#00FF00"

	TimeView {
		id: timeView
		anchors.top: selectedDateView.bottom
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
	}

	CalendarView {
		id: calendar
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		height: parent * (3./5.)
		navigationBarVisible: false
	}

	Rectangle {
		id: selectedDateView
		anchors.right: parent.right
		anchors.left: parent.left
		anchors.top: calendar.bottom
	//	anchors.bottom: timeView.top
		height: parent.height / 18
		color: "#C0C0C0"

		Label {
			anchors.fill: parent
			color: "#FF0000"
			text: Qt.formatDate(calendar.selectedDate, "ddd, dd.MM.yyyy")
			font.pixelSize: parent.height * 0.8
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}

		HoverButton {
			id: previousMonth
			width: height * 1.5
			height: parent.height
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			source: "qrc:/images/leftanglearrow.png"
			onClicked: calendar.showPreviousMonth()
		}

		HoverButton {
			id: nextMonth
			width: height * 1.5
			height: parent.height
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			source: "qrc:/images/rightanglearrow.png"
			onClicked: calendar.showNextMonth()
		}
	}
}
