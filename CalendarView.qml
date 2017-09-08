import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Private 1.0
import Event 1.0
//import EventDatabase 1.0

Calendar {
	id: calendar

	readonly property date today: new Date()

	Label {
		id: monthLabel
		anchors.centerIn: parent
	//	color: "#20000000"
		color: "#000000"
		opacity: 0.1
		font.pixelSize: parent.width * 0.14
		font.bold: true
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		text: calendar.__locale.standaloneMonthName(calendar.visibleMonth)

		onTextChanged: {
		//	font.pixelSize = parent.width * 0.2
			while(implicitWidth > parent.width) {
				font.pixelSize *= 0.8
			}
		}
	}

	Label {
	//	anchors.left: monthLabel.left
	//	anchors.right: monthLabel.right
		anchors.top: monthLabel.bottom
		anchors.margins: height * 0.7
		opacity: 0.1
		color: "#000000"
		font.pixelSize: monthLabel.font.pixelSize * 0.6
		anchors.horizontalCenter: parent.horizontalCenter
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		text: calendar.visibleYear // new Date(calendar.visibleYear, calendar.visibleMonth, 1).toLocaleDateString(calendar.__locale, "yyyy")
	}

	style: CalendarStyle {
		gridVisible: false		//	== __gridLineWidth: 0

		/*!
			The background of the calendar.

			The implicit size of the calendar is calculated based on the implicit size of the background delegate.
		*/
	/*	property Component background: Rectangle {
			color: "#fff"
			implicitWidth: Math.max(250, Math.round(TextSingleton.implicitHeight * 14))
			implicitHeight: Math.max(250, Math.round(TextSingleton.implicitHeight * 14))
		}//*/

		/*!
			The navigation bar of the calendar.

			Styles the bar at the top of the calendar that contains the
			next month/previous month buttons and the selected date label.

			The properties provided to the delegate are:
			\table
				\row \li readonly property string \b styleData.title
					 \li The title of the calendar.
			\endtable
		*/

	/*	property Component navigationBar: Rectangle {
			height: Math.round(TextSingleton.implicitHeight * 2.73)
			color: "#f9f9f9"

			Rectangle {
				color: Qt.rgba(1,1,1,0.6)
				height: 1
				width: parent.width
			}

			Rectangle {
				anchors.bottom: parent.bottom
				height: 1
				width: parent.width
				color: "#ddd"
			}
			HoverButton {
				id: previousMonth
				width: parent.height
				height: width
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				source: "images/leftanglearrow.png"
				onClicked: control.showPreviousMonth()
			}
			Label {
				id: dateText
				text: styleData.title
				elide: Text.ElideRight
				horizontalAlignment: Text.AlignHCenter
				font.pixelSize: TextSingleton.implicitHeight * 1.25
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: previousMonth.right
				anchors.leftMargin: 2
				anchors.right: nextMonth.left
				anchors.rightMargin: 2
			}
			HoverButton {
				id: nextMonth
				width: parent.height
				height: width
				anchors.verticalCenter: parent.verticalCenter
				anchors.right: parent.right
				source: "images/rightanglearrow.png"
				onClicked: control.showNextMonth()
			}
		}//*/

		/*property Component */navigationBar: Rectangle {
			id: customNavigationBar
			height: calendar.height * 0.125
			visible: navigationBarVisible
			color: "#F4F4F4"

			Rectangle {		// gray line at the top
				color: Qt.rgba(1,1,1,0.6)
				height: 1
				width: parent.width
			}

			Rectangle {		// gray line at the bottom
				anchors.bottom: parent.bottom
				height: 1
				width: parent.width
				color: "#D0D0D0"
			}
			HoverButton {
				id: previousMonth
				width: parent.height
				height: width
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				source: "qrc:/images/leftanglearrow.png"
				onClicked: control.showPreviousMonth()
			}
			Label {
				id: dateText
				text: styleData.title
				elide: Text.ElideRight
				horizontalAlignment: Text.AlignHCenter
				font.pixelSize: parent.height * 0.5
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: previousMonth.right
				anchors.leftMargin: 2
				anchors.right: nextMonth.left
				anchors.rightMargin: 2

				onTextChanged: {
					font.pixelSize = parent.height * 0.5
					while(dateText.implicitWidth > navigationBarSwipeArea.width) {
						dateText.font.pixelSize *= 0.8
					}
				}
			}
			HoverButton {
				id: nextMonth
				width: parent.height
				height: width
				anchors.verticalCenter: parent.verticalCenter
				anchors.right: parent.right
				source: "qrc:/images/rightanglearrow.png"
				onClicked: control.showNextMonth()
			}

			MouseArea {
				id: navigationBarSwipeArea
				anchors.right: nextMonth.left
				anchors.left: previousMonth.right
				anchors.top: parent.top
				anchors.bottom: parent.bottom

				property int previousX

				onPressed: {
					navigationBarSwipeArea.previousX = mouseX
				}

				onMouseXChanged: {
					if(navigationBarSwipeArea.previousX < mouseX - navigationBarSwipeArea.width / 3) {
					//	showPreviousMonth()
						showPreviousYear()
						navigationBarSwipeArea.previousX = mouseX
					}
					else if(navigationBarSwipeArea.previousX > mouseX + navigationBarSwipeArea.width / 3) {
					//	showNextMonth()
						showNextYear()
						navigationBarSwipeArea.previousX = mouseX
					}
				}
			}
		}

		/*!
			The delegate that styles each date in the calendar.

			The properties provided to each delegate are:
			\table
				\row \li readonly property date \b styleData.date
					\li The date this delegate represents.
				\row \li readonly property bool \b styleData.selected
					\li \c true if this is the selected date.
				\row \li readonly property int \b styleData.index
					\li The index of this delegate.
				\row \li readonly property bool \b styleData.valid
					\li \c true if this date is greater than or equal to than \l {Calendar::minimumDate}{minimumDate} and
						less than or equal to \l {Calendar::maximumDate}{maximumDate}.
				\row \li readonly property bool \b styleData.today
					\li \c true if this date is equal to today's date.
				\row \li readonly property bool \b styleData.visibleMonth
					\li \c true if the month in this date is the visible month.
				\row \li readonly property bool \b styleData.hovered
					\li \c true if the mouse is over this cell.
						\note This property is \c true even when the mouse is hovered over an invalid date.
				\row \li readonly property bool \b styleData.pressed
					\li \c true if the mouse is pressed on this cell.
						\note This property is \c true even when the mouse is pressed on an invalid date.
			\endtable
		*/
		/*property Component */dayDelegate: Rectangle {
			anchors.fill: parent
		//	anchors.leftMargin: (!addExtraMargin || control.weekNumbersVisible) && styleData.index % CalendarUtils.daysInAWeek === 0 ? 0 : -1
		//	anchors.rightMargin: !addExtraMargin && styleData.index % CalendarUtils.daysInAWeek === CalendarUtils.daysInAWeek - 1 ? 0 : -1
		//	anchors.bottomMargin: !addExtraMargin && styleData.index >= CalendarUtils.daysInAWeek * (CalendarUtils.weeksOnACalendarMonth - 1) ? 0 : -1
		//	anchors.topMargin: styleData.selected ? -1 : 0
		//	anchors.margins: -1		// __gridLineWidth = 0
		//	color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"

			Rectangle {
				anchors.centerIn: parent
				height: (parent.height < parent.width) ? parent.height * 0.9 : parent.width * 0.9
				width: height
				radius: height * 0.5
				visible: database.isEventAt(styleData.date)
				color: (styleData.visibleMonth) ? "#FFFF00" : Qt.lighter("#FFFF00", 1.6)
			}

			color: {
				var color = "#FFFFFF"

				if(today.toDateString() === styleData.date.toDateString())
					color = (styleData.visibleMonth) ? "#04B404" : Qt.lighter("#04B404", 1.3)
				else if(styleData.selected)
					color = "#00FFFF"
		/*		if(database.isEventAt(styleData.date)) {
					if(today.toDateString() === styleData.date.toDateString())
						color = "#80FF00"
					else if(styleData.visibleMonth)
						color = "#FFFF00"
					else
						color = Qt.lighter("#FFFF00", 1.6)
				//	color = "#FF0000"
				}*/

				color
			}

		//	readonly property bool addExtraMargin: control.frameVisible && styleData.selected
		/*	readonly property color sameMonthDateTextColor: "#444"
			readonly property color selectedDateColor: Qt.platform.os === "osx" ? "#3778d0" : SystemPaletteSingleton.highlight(control.enabled)
			readonly property color selectedDateTextColor: "white"
			readonly property color differentMonthDateTextColor: "#bbb"
			readonly property color invalidDateColor: "#dddddd"//*/
			Label {
				id: dayDelegateText
				text: styleData.date.getDate()
				anchors.centerIn: parent
				horizontalAlignment: Text.AlignRight
			//	font.pixelSize: Math.min(parent.height/3, parent.width/3)
				font.pixelSize: Math.min(parent.height/2.2, parent.width/2.2)
				font.underline: styleData.selected
				font.overline: styleData.selected
				font.bold: styleData.selected

				color: {
				/*	var theColor = invalidDateColor;
					if (styleData.valid) {
						// Date is within the valid range.
						theColor = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
						if (styleData.selected)
							theColor = selectedDateTextColor;
					}
					theColor;//*/
					var color = "#FF0000"
					if (styleData.valid) {
						color = styleData.visibleMonth ? "#000000" : Qt.lighter(color, 1.3)
						if (styleData.selected) {
							color = "#FF00FF"
						}
					}
					color
				}
			}
		}

		/*!
			The delegate that styles each weekday.

			The height of the weekday row is calculated based on the maximum implicit height of the delegates.

			The properties provided to each delegate are:
			\table
				\row \li readonly property int \b styleData.index
					 \li The index (0-6) of the delegate.
				\row \li readonly property int \b styleData.dayOfWeek
					 \li The day of the week this delegate represents. Possible values:
						 \list
						 \li \c Locale.Sunday
						 \li \c Locale.Monday
						 \li \c Locale.Tuesday
						 \li \c Locale.Wednesday
						 \li \c Locale.Thursday
						 \li \c Locale.Friday
						 \li \c Locale.Saturday
						 \endlist
			\endtable
		*/
	/*	property Component dayOfWeekDelegate: Rectangle {
			color: gridVisible ? "#fcfcfc" : "transparent"
			implicitHeight: Math.round(TextSingleton.implicitHeight * 2.25)
			Label {
				text: control.__locale.dayName(styleData.dayOfWeek, control.dayOfWeekFormat)
				anchors.centerIn: parent
			}
		}//*/

		/*!
			The delegate that styles each week number.

			The width of the week number column is calculated based on the maximum implicit width of the delegates.

			The properties provided to each delegate are:
			\table
				\row \li readonly property int \b styleData.index
					 \li The index (0-5) of the delegate.
				\row \li readonly property int \b styleData.weekNumber
					 \li The number of the week this delegate represents.
			\endtable
		*/
	/*	property Component weekNumberDelegate: Rectangle {
			implicitWidth: Math.round(TextSingleton.implicitHeight * 2)
			Label {
				text: styleData.weekNumber
				anchors.centerIn: parent
				color: "#444"
			}
		}//*/

		/*! \internal */
		/*property Component */panel: Item {
			id: panelItem

			implicitWidth: backgroundLoader.implicitWidth
			implicitHeight: backgroundLoader.implicitHeight

		//	property alias navigationBarItem: navigationBarLoader.item

		//	property alias dayOfWeekHeaderRow: dayOfWeekHeaderRow

			readonly property int weeksToShow: 6
			readonly property int rows: weeksToShow
			readonly property int columns: CalendarUtils.daysInAWeek

			// The combined available width and height to be shared amongst each cell.
			readonly property real availableWidth: viewContainer.width
			readonly property real availableHeight: viewContainer.height

			property int hoveredCellIndex: -1
			property int pressedCellIndex: -1
			property int pressCellIndex: -1

			Rectangle {
				anchors.fill: parent
				color: "transparent"
				border.color: gridColor
				visible: control.frameVisible
			}

			Item {
				id: container
				anchors.fill: parent
				anchors.margins: control.frameVisible ? 1 : 0

				Loader {
					id: backgroundLoader
					anchors.fill: parent
					sourceComponent: background
				}

				Loader {
					id: navigationBarLoader
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.top: parent.top
					sourceComponent: navigationBar
					active: control.navigationBarVisible

					property QtObject styleData: QtObject {
						readonly property string title: control.__locale.standaloneMonthName(control.visibleMonth) + new Date(control.visibleYear, control.visibleMonth, 1).toLocaleDateString(control.__locale, " yyyy")
					}
				}

				Rectangle {
					id: navigationBarShadow
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.top: navigationBarLoader.bottom
					height: navigationBarLoader.height * 0.2
					gradient: Gradient {
						GradientStop { position: 0; color: "#D0D0D0" }
						GradientStop { position: 1; color: "#FFFFFF" }
					}
				}

				Row {
					id: dayOfWeekHeaderRow
					anchors.top: navigationBarLoader.bottom
					anchors.left: parent.left
					anchors.leftMargin: (control.weekNumbersVisible ? weekNumbersItem.width : 0)
					anchors.right: parent.right
					spacing: gridVisible ? __gridLineWidth : 0

					Repeater {
						id: repeater
						model: CalendarHeaderModel {
							locale: control.__locale
						}
						Loader {
							id: dayOfWeekDelegateLoader
							sourceComponent: dayOfWeekDelegate
							width: __cellRectAt(index).width

							readonly property int __index: index
							readonly property var __dayOfWeek: dayOfWeek

							property QtObject styleData: QtObject {
								readonly property alias index: dayOfWeekDelegateLoader.__index
								readonly property alias dayOfWeek: dayOfWeekDelegateLoader.__dayOfWeek
							}
						}
					}
				}

				Rectangle {
					id: topGridLine
					color: __horizontalSeparatorColor
					width: parent.width
					height: __gridLineWidth
					visible: gridVisible
					anchors.top: dayOfWeekHeaderRow.bottom
				}

				Row {
					id: gridRow
					width: weekNumbersItem.width + viewContainer.width
					height: viewContainer.height
					anchors.top: topGridLine.bottom

					Column {
						id: weekNumbersItem
						visible: control.weekNumbersVisible
						height: viewContainer.height
						spacing: gridVisible ? __gridLineWidth : 0
						Repeater {
							id: weekNumberRepeater
							model: panelItem.weeksToShow

							Loader {
								id: weekNumberDelegateLoader
								height: __cellRectAt(index * panelItem.columns).height
								sourceComponent: weekNumberDelegate

								readonly property int __index: index
								property int __weekNumber: control.__model.weekNumberAt(index)

								Connections {
									target: control
									onVisibleMonthChanged: __weekNumber = control.__model.weekNumberAt(index)
									onVisibleYearChanged: __weekNumber = control.__model.weekNumberAt(index)
								}

								Connections {
									target: control.__model
									onCountChanged: __weekNumber = control.__model.weekNumberAt(index)
								}

								property QtObject styleData: QtObject {
									readonly property alias index: weekNumberDelegateLoader.__index
									readonly property int weekNumber: weekNumberDelegateLoader.__weekNumber
								}
							}
						}
					}

					Rectangle {
						id: separator
						anchors.topMargin: - dayOfWeekHeaderRow.height - 1
						anchors.top: weekNumbersItem.top
						anchors.bottom: weekNumbersItem.bottom

						width: __gridLineWidth
						color: __verticalSeparatorColor
						visible: control.weekNumbersVisible
					}

					// Contains the grid lines and the grid itself.
					Item {
						id: viewContainer
						width: container.width - (control.weekNumbersVisible ? weekNumbersItem.width + separator.width : 0)
						height: container.height - navigationBarLoader.height - dayOfWeekHeaderRow.height - topGridLine.height

						Repeater {
							id: verticalGridLineRepeater
							model: panelItem.columns - 1
							delegate: Rectangle {
								x: __cellRectAt(index + 1).x - __gridLineWidth
								y: 0
								width: __gridLineWidth
								height: viewContainer.height
								color: gridColor
								visible: gridVisible
							}
						}

						Repeater {
							id: horizontalGridLineRepeater
							model: panelItem.rows - 1
							delegate: Rectangle {
								x: 0
								y: __cellRectAt((index + 1) * panelItem.columns).y - __gridLineWidth
								width: viewContainer.width
								height: __gridLineWidth
								color: gridColor
								visible: gridVisible
							}
						}

						MouseArea {
							id: mouseArea
							anchors.fill: parent

							hoverEnabled: Settings.hoverEnabled

							function cellIndexAt(mouseX, mouseY) {
								var viewContainerPos = viewContainer.mapFromItem(mouseArea, mouseX, mouseY);
								var child = viewContainer.childAt(viewContainerPos.x, viewContainerPos.y);
								// In the tests, the mouseArea sometimes gets picked instead of the cells,
								// probably because stuff is still loading. To be safe, we check for that here.
								return child && child !== mouseArea ? child.__index : -1;
							}

							onEntered: {
								hoveredCellIndex = cellIndexAt(mouseX, mouseY);
								if (hoveredCellIndex === undefined) {
									hoveredCellIndex = cellIndexAt(mouseX, mouseY);
								}

								var date = view.model.dateAt(hoveredCellIndex);
								if (__isValidDate(date)) {
									control.hovered(date);
								}
							}

							onExited: {
								hoveredCellIndex = -1;
							}

							onPositionChanged: {
								var indexOfCell = cellIndexAt(mouse.x, mouse.y);
								var previousHoveredCellIndex = hoveredCellIndex;
								hoveredCellIndex = indexOfCell;
								if (indexOfCell !== -1) {
									var date = view.model.dateAt(indexOfCell);
									if (__isValidDate(date)) {
										if (hoveredCellIndex !== previousHoveredCellIndex)
											control.hovered(date);

										// The date must be different for the pressed signal to be emitted.
										if (pressed && date.getTime() !== control.selectedDate.getTime()) {
											control.pressed(date);

											// You can't select dates in a different month while dragging.
											if (date.getMonth() === control.selectedDate.getMonth()) {
												control.selectedDate = date;
												pressedCellIndex = indexOfCell;
											}
										}
									}
								}
							}

							property int previousX

							onPressed: {
								pressCellIndex = cellIndexAt(mouse.x, mouse.y);
								if (pressCellIndex !== -1) {
									var date = view.model.dateAt(pressCellIndex);
									pressedCellIndex = pressCellIndex;
									if (__isValidDate(date)) {
										control.selectedDate = date;
										control.pressed(date);
									}
								}

								previousX = mouseX
							}

							onMouseXChanged: {
								if(pressed) {
									if(previousX < mouseX - parent.width / 2.5) {
										showPreviousMonth()
										__selectPreviousMonth()
										previousX = mouseX
									}
									else if(previousX > mouseX + parent.width / 2.5) {
										showNextMonth()
										__selectNextMonth()
										previousX = mouseX
									}
								}
							}

							onReleased: {
								var indexOfCell = cellIndexAt(mouse.x, mouse.y);
								if (indexOfCell !== -1) {
									// The cell index might be valid, but the date has to be too. We could let the
									// selected date validation take care of this, but then the selected date would
									// change to the earliest day if a day before the minimum date is clicked, for example.
									var date = view.model.dateAt(indexOfCell);
									if (__isValidDate(date)) {
										control.released(date);
									}
								}
								pressedCellIndex = -1;
							}

							onClicked: {
								var indexOfCell = cellIndexAt(mouse.x, mouse.y);
								if (indexOfCell !== -1 && indexOfCell === pressCellIndex) {
									var date = view.model.dateAt(indexOfCell);
									if (__isValidDate(date))
										control.clicked(date);
								}
							}

							onDoubleClicked: {
								var indexOfCell = cellIndexAt(mouse.x, mouse.y);
								if (indexOfCell !== -1) {
									var date = view.model.dateAt(indexOfCell);
									if (__isValidDate(date))
										control.doubleClicked(date);
								}
							}

							onPressAndHold: {
								var indexOfCell = cellIndexAt(mouse.x, mouse.y);
								if (indexOfCell !== -1 && indexOfCell === pressCellIndex) {
									var date = view.model.dateAt(indexOfCell);
									if (__isValidDate(date))
										control.pressAndHold(date);
								}
							}
						}

						Connections {
							target: control
							onSelectedDateChanged: view.selectedDateChanged()
						}

						Repeater {
							id: view

							property int currentIndex: -1

							model: control.__model

							Component.onCompleted: selectedDateChanged()

							function selectedDateChanged() {
								if (model !== undefined && model.locale !== undefined) {
									currentIndex = model.indexAt(control.selectedDate);
								}
							}

							delegate: Loader {
								id: delegateLoader

								x: __cellRectAt(index).x
								y: __cellRectAt(index).y
								width: __cellRectAt(index).width
								height: __cellRectAt(index).height
								sourceComponent: dayDelegate

								readonly property int __index: index
								readonly property date __date: date
								// We rely on the fact that an invalid QDate will be converted to a Date
								// whose year is -4713, which is always an invalid date since our
								// earliest minimum date is the year 1.
								readonly property bool valid: __isValidDate(date)

								property QtObject styleData: QtObject {
									readonly property alias index: delegateLoader.__index
									readonly property bool selected: control.selectedDate.getTime() === date.getTime()
									readonly property alias date: delegateLoader.__date
									readonly property bool valid: delegateLoader.valid
									// TODO: this will not be correct if the app is running when a new day begins.
									readonly property bool today: date.getTime() === new Date().setHours(0, 0, 0, 0)
									readonly property bool visibleMonth: date.getMonth() === control.visibleMonth
									readonly property bool hovered: panelItem.hoveredCellIndex == index
									readonly property bool pressed: panelItem.pressedCellIndex == index
									// todo: pressed property here, clicked and doubleClicked in the control itself
								}
							}
						}
					}
				}
			}
		}
	}
}
