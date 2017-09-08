#include "androidnotificationclient.h"
#include <QAndroidJniObject>

AndroidNotificationClient::AndroidNotificationClient(QObject *parent) : QObject(parent)
{
	QObject::connect(this, &AndroidNotificationClient::notificationChanged, this, &AndroidNotificationClient::updateNotification);
}

void AndroidNotificationClient::setNotification(const QString &notification)
{
	if (this->notification == notification)
		return;

	this->notification = notification;
	emit notificationChanged();
}

void AndroidNotificationClient::setTitle(const QString &title)
{
	if(this->title == title)
		return;

	this->title = title;
	emit titleChanged();
}

const QString& AndroidNotificationClient::getNotification() const
{
	return notification;
}

const QString& AndroidNotificationClient::getTitle() const
{
	return title;
}

void AndroidNotificationClient::updateNotification()
{
	QAndroidJniObject javaNotification = QAndroidJniObject::fromString(notification);
	QAndroidJniObject javaTitle = QAndroidJniObject::fromString(title);
	QAndroidJniObject::callStaticMethod<void>("org/co/sqyt/calendarpp/CalendarPPActivity", "notify", "(Ljava/lang/String;Ljava/lang/String;)V", javaTitle.object<jstring>(), javaNotification.object<jstring>());
}
