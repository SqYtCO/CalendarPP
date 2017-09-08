#ifndef EVENTDATABASE_H
#define EVENTDATABASE_H

#include "event.h"
#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <memory>

#define DB_NAME "DB_calendarPP"

class EventDatabase : public QObject
{
	Q_OBJECT

	QSqlDatabase db;
	QSqlQuery* query;
	QVector<ReminderClass> nextReminds;

	operator ReminderClass() const;

public:
	explicit EventDatabase(QString databaseName = DB_NAME, QObject *parent = nullptr);
	~EventDatabase();
	const QVector<ReminderClass>& nextReminder();

	QList<Event*> nextEvents;

public slots:
	Q_INVOKABLE QList<Event*> eventsAt(const QDate& date);
	Q_INVOKABLE Event* eventAt(const QDateTime& time);
	Q_INVOKABLE bool isEventAt(const QDate& date);
	Q_INVOKABLE int writeEvent(const QVariant &event);
	void addEventsForNextSevenDays(const QDate& date);
	void clearDatabase();
	void resetConnection(QString databaseName = DB_NAME);
	void deleteNextEventsList();
};

#endif // EVENTDATABASE_H
