#include "background.h"
#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif
#include <QDebug>

Background::Background(EventDatabase* database, QObject *parent) : QObject(parent), database(database)
{

}

void Background::updateBackground()
{
	qDebug() << "Update Service";
#ifdef Q_OS_ANDROID
	QAndroidJniObject::callStaticMethod<void>("org/co/sqyt/calendarpp/CalendarPPActivity", "updateService");
	database->resetConnection();
#endif
}
