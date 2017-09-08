#include "androidnotificationclient.h"
#include "background.h"
#include "eventdatabase.h"
#include "nexteventsmodel.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDateTime>
#include <QDebug>
#include <QAndroidJniObject>

#include "jnifunctions.h"

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
//	app.setApplicationName("Calendar++");

	QQmlApplicationEngine engine;

	EventDatabase database;
	engine.rootContext()->setContextProperty("database", &database);
	database.addEventsForNextSevenDays(QDate::currentDate());

	NextEventsModel model(&database.nextEvents);
	engine.rootContext()->setContextProperty("nextEventsModel", &model);

	Background background(&database);
	engine.rootContext()->setContextProperty("backgroundwork", &background);

	qmlRegisterType<Event>("Event", 1, 0, "Event");

	engine.load(QUrl("qrc:/main.qml"));

#ifdef Q_OS_ANDROID
	AndroidNotificationClient androidNotificationClient;
	engine.rootContext()->setContextProperty(QLatin1String("notificationClient"), &androidNotificationClient);
#endif

	if (engine.rootObjects().isEmpty())
		return -1;

	return app.exec();
}
