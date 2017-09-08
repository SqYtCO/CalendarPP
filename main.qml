import QtQuick 2.9
import QtQuick.Window 2.0
import QtQuick.Controls 2.1
import Event 1.0

ApplicationWindow {
	id: app
	visible: true
//	width: Screen.width
//	height: Screen.height
	width: 400
	height: 600

	onClosing: {		// back-button
		if(controller.state == "create") {
			if(controller.createLoader.item.datechooser.state == "shown" || controller.createLoader.item.timechooser.state == "shown") {
				controller.createLoader.item.datechooser.state = ""
				controller.createLoader.item.timechooser.state = ""
			}
			else
				controller.state = "main"
			close.accepted = false
		}
		else if(drawer.open) {
			drawer.toggle()
			drawer.completeSlideDirection()
			close.accepted = false
		}
		else if(controller.state != "main") {
			controller.state = "main"
			close.accepted = false
		}
		else {
			close.accepted = true
		}
	}

	Event {
		id: event
		frequency: 0
	}

	Rectangle {
		id: mainRect
		anchors.bottom: parent.bottom
		anchors.top: menubar.bottom
		anchors.left: parent.left
		anchors.right: parent.right

		PageController {
			id: controller
			anchors.fill: parent
		}

/*		Loader {
			id: pageLoader
		//	anchors.fill: parent
			visible: false
		}
			property int whichScreen: 0

			onSourceChanged: {
				if(source == "qrc:/CreateEventScreen.qml")
					menubar.state = "createEvent"
				else
					menubar.state = ""
			}

			onLoaded: {
			//	mainLoader.setSource("qrc:/MainScreen.qml")
			//	createLoader.setSource("qrc:/CreateEventScreen_2.qml", {event: event })
			}

			onVisibleChanged: {
				if(visible) {
					createLoader.visible = false
					mainLoader.visible = false
				}
				else {
					if(whichScreen == 0) {
						createLoader.visible = false
						mainLoader.visible = true
					}
					else if(whichScreen == 1) {
						mainLoader.visible = false
						createLoader.visible = true
					}
				}
			}
		}

		Loader {
			id: createLoader
			anchors.fill: parent
			visible: false
		}

		Loader {
			id: mainLoader
			anchors.fill: parent
			visible: true
			Component.onCompleted: setSource("qrc:/MainScreen.qml", { calendar: app.calendar })
		//	source: "qrc:/MainScreen.qml"

			onLoaded: createLoader.setSource("qrc:/CreateEventScreen_2.qml", {event: event })
		}
*/	}

	NavigationDrawer {
		id: drawer
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		position: Qt.LeftEdge
		visualParent: mainRect

		MenuContent {
			anchors.fill: parent
			controller: controller
			drawer: drawer
			event: event
		}
	}

	MenuBar {
		id: menubar
		drawer: drawer
		controller: controller
		event: event
	}
}
