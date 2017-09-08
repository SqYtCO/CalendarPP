import QtQuick 2.7

Item {
	id: root

	property alias mainLoader: mainLoader
	property alias createLoader: createLoader
	property alias pageLoader: pageLoader

	state: "main"

	states: [
		State {
			name: "main"
			PropertyChanges {
				target: mainLoader
				visible: true
			}
		},

		State {
			name: "settings"
			PropertyChanges {
				target: pageLoader
				source: "qrc:/SettingsScreen.qml"
			}
			PropertyChanges {
				target: mainLoader
				visible: false
			}
			PropertyChanges {
				target: createLoader
				visible: false
			}
		},

		State {
			name: "create"
			PropertyChanges {
				target: createLoader
				visible: true
			}
			PropertyChanges {
				target: menubar
				state: "createEvent"
			}
			PropertyChanges {
				target: mainLoader
				visible: false
			}
			PropertyChanges {
				target: pageLoader
				visible: false
			}
		},

		State {
			name: "calendar"
			PropertyChanges {
				target: pageLoader
				source: "qrc:/CalendarView.qml"
			}
			PropertyChanges {
				target: mainLoader
				visible: false
			}
			PropertyChanges {
				target: createLoader
				visible: false
			}
		},

		State {
			name: "nexts"
			PropertyChanges {
				target: pageLoader
				source: "qrc:/NextEventsScreen.qml"
			}
			PropertyChanges {
				target: mainLoader
				visible: false
			}
			PropertyChanges {
				target: createLoader
				visible: false
			}
		}
	]

	Loader {
		id: pageLoader
		anchors.fill: parent
		active: true
	}

	Loader {
		id: mainLoader
		anchors.fill: parent
		active: true
		source: "qrc:/MainScreen.qml"

		onLoaded: {
			createLoader.setSource("qrc:/CreateEventScreen.qml", { event: event })
		}
	}

	Loader {
		id: createLoader
		anchors.fill: parent
		active: true
		visible: false

		onLoaded: {
			pageLoader.setSource("qrc:/CalendarView.qml")
		}
	}
}
