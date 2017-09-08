import QtQuick 2.7
import QtQuick.Controls 2.1
import Event 1.0

Item {
	id: menuContentRoot
	property NavigationDrawer drawer
	property Event event
	property PageController controller

	Rectangle {
		id: head
		z: 2
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		height: parent.height / 4

	//	color: "#FF0000"
		Image {
			anchors.fill: parent
			source: "qrc:/images/background.jpg"
		}
	}

	ListView {
		id: menuList
		anchors.top: head.bottom
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		highlightFollowsCurrentItem: true

		model: ListModel {
			ListElement {
			//	page: "qrc:/MainScreen.qml"
				page: "main"
				option: "Overview"
			}

			ListElement {
			//	page: "qrc:/MainScreen.qml"
				page: "nexts"
				option: "Next Events"
			}

			ListElement {
			//	page: "qrc:/SettingsScreen.qml"
				page: "settings"
				option: "Settings"
			}

			ListElement {
			//	page: "qrc:/CreateEventScreen_2.qml"
				page: "create"
				option: "Add Event"
			}

			ListElement {
				page: "clearAllEvents"
				option: "Clear Database"
			}

			ListElement {
			//	page: "qrc:/CalendarView.qml"
				page: "calendar"
				option: "Calendar View"
			}
		}

		delegate: ItemDelegate {
			height: parent.width / 4
			width: parent.width
			text: option
		//	hightlighted:
		//	border.color: "#000000"
		//	border.width: 5

			onClicked: {
				if(page == "clearAllEvents")
					database.clearDatabase()
				else
					controller.state = page
			//	else if(page == "qrc:/CreateEventScreen.qml" || page == "qrc:/CreateEventScreen_2.qml") {
				//	menuContentRoot.pageLoader.setSource(page, { event: event } )
				//	menuContentRoot.pageLoader.whichScreen = 1
				//	menuContentRoot.pageLoader.visible = false
				menuContentRoot.drawer.hide()
				menuContentRoot.drawer.completeSlideDirection()
			}
		}

		boundsBehavior: Flickable.DragOverBounds	// standard
		orientation: Qt.Vertical					// standard
		spacing: 0
	}
}
