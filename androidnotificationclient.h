#ifndef ANDROIDNOTIFICATIONCLIENT_H
#define ANDROIDNOTIFICATIONCLIENT_H

#include <QObject>

class AndroidNotificationClient : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString title READ getTitle WRITE setTitle NOTIFY titleChanged)
	Q_PROPERTY(QString notification READ getNotification WRITE setNotification NOTIFY notificationChanged)

public:
	explicit AndroidNotificationClient(QObject *parent = 0);

	void setNotification(const QString &notification);	// connected to updateNotification()
	void setTitle(const QString &title);				// not connected
	const QString& getTitle() const;
	const QString& getNotification() const;

signals:
    void notificationChanged();
	void titleChanged();

private slots:
	void updateNotification();

private:
	QString notification;
	QString title;
};

#endif // ANDROIDNOTIFICATIONCLIENT_H
