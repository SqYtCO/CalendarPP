#include "eventdatabase.h"
#include <QDebug>
#include <QSqlError>
#include <QCoreApplication>
#include <memory>

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

QString operator"" _qstr(const char* literal, size_t n)
{
	Q_UNUSED(n)
	return QString(literal);
}

EventDatabase::EventDatabase(QString databaseName, QObject *parent) : QObject(parent), db(QSqlDatabase::addDatabase("QSQLITE")), query(new QSqlQuery(db))	// "QSQLITE" for SQLite3 or "QMYSQL" for MySQL
{
	if(QSqlDatabase::drivers().size() < 1)
	{
		QCoreApplication::addLibraryPath("/data/data/org.co.sqyt.calendarpp/qt-reserved-files/plugins");
		QCoreApplication::addLibraryPath("/data/app/org.co.sqyt.calendarpp-1/lib/x86");
		QCoreApplication::addLibraryPath("/data/app/org.co.sqyt.calendarpp-2/lib/x86");

		resetConnection();
	}
	db.setDatabaseName(databaseName);
	db.setHostName("AndroidDevice");
	db.setUserName("CalendarPP");
//	db.setPassword("");

	if(db.open())
	{
		if(!query->exec("CREATE TABLE IF NOT EXISTS Frequently "
					   "(Name TINYTEXT, Start DATETIME, End DATETIME, Frequency INT NOT NULL, Description TEXT, Reminders TEXT)"))
			qDebug("Create Error: Frequently");
		if(!query->exec("CREATE TABLE IF NOT EXISTS Events "
					   "(Name TINYTEXT, Start DATETIME, End DATETIME, Description TEXT, Reminders TEXT)"))
			qDebug("Create Error: Events");
	}
	else
	{
		qDebug("Can not open Database!");
		qDebug() << db.lastError() << " in " << db.databaseName();
		qDebug() << "Loaded Drivers: " << db.drivers();
	}
	db.close();
}

EventDatabase::~EventDatabase()
{
	deleteNextEventsList();
}

void EventDatabase::resetConnection(QString databaseName)
{
	QSqlDatabase::removeDatabase(QSqlDatabase::defaultConnection);
	delete query;
	db = QSqlDatabase::addDatabase("QSQLITE");
	query = new QSqlQuery(db);
	db.setDatabaseName(databaseName);
	db.setHostName("AndroidDevice");
	db.setUserName("CalendarPP");
	//	db.setPassword("");
}

void EventDatabase::deleteNextEventsList()
{
	for(const auto& a : nextEvents)
		delete a;
	nextEvents.clear();
}

void EventDatabase::clearDatabase()
{
	if(db.open())
	{
		if(!query->exec("DELETE FROM Frequently"))
			qDebug("Delete Error: Frequently in EventDatabase::clearDatabase");
		if(!query->exec("DELETE FROM Events"))
			qDebug("Delete Error: Events in EventDatabase::clearDatabase");
	}
	else
		qDebug("Can not open Database");
	db.close();
}

QList<Event*> EventDatabase::eventsAt(const QDate& date)
{
	QList<Event*> list;
	if(db.open())
	{
		if(!query->exec("SELECT Start, Frequency, Name, Description, End, Reminders FROM Frequently"))
			qDebug("Select Error: Frequently in EventDatabase::eventsAt");
		while(query->next())
		{
			QDateTime temp = query->value(0).toDateTime();
			temp.setTimeSpec(Qt::UTC);
			int days = date.daysTo(temp.toLocalTime().date());
			if(days % query->value(1).toInt() == 0 && days <= 0)
			{
				list.push_back(new Event());
			//	temp = query->value(0).toDateTime(); temp.setTimeSpec(Qt::UTC);
				list.last()->setFirstFrequentEvent(temp);

				while(date.daysTo(temp.toLocalTime().date()) < 0)
					temp = temp.addDays(query->value(1).toInt());
				list.last()->setStart(temp);

				list.last()->setFrequency(query->value(1).toInt());
				list.last()->setName(query->value(2).toString());
				list.last()->setDescription(query->value(3).toString());
				temp = query->value(4).toDateTime(); temp.setTimeSpec(Qt::UTC);
				list.last()->setEnd(temp);
				QString reminders = query->value(5).toString();
				QStringList reminderList = reminders.split(";", QString::SkipEmptyParts);
				for(const auto& a : reminderList)
					list.last()->addReminder(a.toInt());
			}
		}

		if(!query->exec("SELECT Start, Name, Description, End, Reminders FROM Events"))
			qDebug("Select Error: Events in EventDatabase::eventsAt");
		while(query->next())
		{
			QDateTime temp = query->value(0).toDateTime();
			temp.setTimeSpec(Qt::UTC);
			if(temp.toLocalTime().date() == date)
			{
				list.push_back(new Event());
			//	temp = query->value(0).toDateTime(); temp2.setTimeSpec(Qt::UTC);
				list.last()->setStart(temp);
				list.last()->setName(query->value(1).toString());
				list.last()->setDescription(query->value(2).toString());
				temp = query->value(3).toDateTime(); temp.setTimeSpec(Qt::UTC);
				list.last()->setEnd(temp);
				QString reminders = query->value(4).toString();
				QStringList reminderList = reminders.split(";", QString::SkipEmptyParts);
				for(const auto& a : reminderList)
					list.last()->addReminder(a.toInt());
			}
		}

		db.close();
		return list;
	}
	else
	{
		qDebug("Can not open Database!");
		db.close();
		return list;
	}
}

bool EventDatabase::isEventAt(const QDate& date)
{
	if(db.open())
	{
		if(!query->exec("SELECT Start, Frequency FROM Frequently"))
			qDebug("Select Error: Frequently in EventDatabase::isEventAt");
		while(query->next())
		{
			QDateTime temp = query->value(0).toDateTime();
			temp.setTimeSpec(Qt::UTC);
			int days = date.daysTo(temp.toLocalTime().date());
			if(days % query->value(1).toInt() == 0 && days <= 0)
			{
				db.close();
				return true;
			}
		}
		if(!query->exec("SELECT Start FROM Events"))
			qDebug("Select Error: Events in EventDatabase::isEventAt");
		while(query->next())
		{
			QDateTime temp = query->value(0).toDateTime();
			temp.setTimeSpec(Qt::UTC);
			if(temp.toLocalTime().date() == date)
			{
				db.close();
				return true;
			}
		}
		db.close();
		return false;
	}
	else
	{
		qDebug("Can not open Database!");
		db.close();
		return false;
	}
}

Event* EventDatabase::eventAt(const QDateTime &time)
{
	Q_UNUSED(time)
	return new Event(this);
}

void EventDatabase::addEventsForNextSevenDays(const QDate& date)
{
	for(int i = 0; i < 7; ++i)
	{
		for(const auto& a : eventsAt(date.addDays(i)))
		{
			if(a->getEnd() >= QDateTime::currentDateTimeUtc())
				nextEvents.push_back(a);
			else
				delete a;
		}
	}
}

const QVector<ReminderClass>& EventDatabase::nextReminder()
{
	// saved reminders have to be sorted
	nextReminds.clear();
	ReminderClass temp;
	temp.remind = QDateTime::currentDateTimeUtc().addDays(15);
	nextReminds.push_back(temp);

	for(int i = 0; i <= 15; ++i)
	{
		for(auto a : eventsAt(QDate::currentDate().addDays(i)))
		{
			if(a->getReminders().size() > 0)
			{
				const auto& reminderOfA = a->getStart().addSecs(-60 * a->getReminders().last());
				if(reminderOfA < nextReminds[0].remind && reminderOfA > QDateTime::currentDateTimeUtc()) // subtract reminder from start
				{
					nextReminds.clear();
					nextReminds.push_back(*a);
					nextReminds.last().remind = reminderOfA;
					nextReminds.last().timeToStart = a->getReminders().last();
				}
				else if(reminderOfA	== nextReminds[0].remind && reminderOfA > QDateTime::currentDateTimeUtc())
				{
					nextReminds.push_back(*a);
					nextReminds.last().remind = reminderOfA;
					nextReminds.last().timeToStart = a->getReminders().last();
				}
				else	// a > nextReminds
				{
					for(const auto& b : a->getReminders())
					{
						const auto& lesserReminderOfA = a->getStart().addSecs(-60 * b);
						if(lesserReminderOfA < nextReminds[0].remind && lesserReminderOfA > QDateTime::currentDateTimeUtc())
						{
							nextReminds.clear();
							nextReminds.push_back(*a);
							nextReminds.last().remind = lesserReminderOfA;
							nextReminds.last().timeToStart = b;
						}
						else if(lesserReminderOfA == nextReminds[0].remind && lesserReminderOfA > QDateTime::currentDateTimeUtc())
						{
							nextReminds.push_back(*a);
							nextReminds.last().remind = lesserReminderOfA;
							nextReminds.last().timeToStart = b;
						}
					}
				}
			}
			else
			{
				if(a->getStart() < nextReminds.last().remind && a->getStart() > QDateTime::currentDateTimeUtc())
				{
					nextReminds.clear();
					nextReminds.push_back(*a);
					nextReminds.last().remind = a->getStart();
				}
				else if(a->getStart() == nextReminds.last().remind && a->getStart() > QDateTime::currentDateTimeUtc())
				{
					nextReminds.push_back(*a);
					nextReminds.last().remind = a->getStart();
				}
			}
		}
	}
	return nextReminds;
}

int EventDatabase::writeEvent(const QVariant& event)
{
	if(!db.open())
	{
		qDebug("Can not open Database");
		return -1;
	}
	else
	{
		QString reminders;
		event.value<Event*>()->sortReminders();
		for(const auto& a: event.value<Event*>()->getReminders())
			reminders += QString::number(a) + ";";

		if(event.value<Event*>()->getID() <= 0)
		{
			if(event.value<Event*>()->getFrequency() <= 0)
			{
				qDebug("write event");
				if(!query->exec("INSERT INTO Events VALUES('"_qstr +
							   event.value<Event*>()->getName() + "', '"_qstr +
							   event.value<Event*>()->getStart().toUTC().toString("yyyy-MM-dd hh:mm:ss") + "', '"_qstr +
							   event.value<Event*>()->getEnd().toUTC().toString("yyyy-MM-dd hh:mm:ss") + "', '"_qstr +
							   event.value<Event*>()->getDescription() + "', '"_qstr +
							   reminders + "')"_qstr))
					qDebug("write error");
				db.close();
				return 1;	// new Event
			}
			else
			{
				qDebug("write frequent event");
				if(!query->exec("INSERT INTO Frequently VALUES('"_qstr +
							   event.value<Event*>()->getName() + "', '"_qstr +
							   event.value<Event*>()->getStart().toUTC().toString("yyyy-MM-dd hh:mm:ss") + "', '"_qstr +
							   event.value<Event*>()->getEnd().toUTC().toString("yyyy-MM-dd hh:mm:ss") + "', "_qstr +
							   QString::number(event.value<Event*>()->getFrequency()) + ", '"_qstr +
							   event.value<Event*>()->getDescription() + "', '"_qstr +
							   reminders + "')"_qstr))
					qDebug("write error");
				db.close();
				return 3;	// new repeating Event

			}
		}
		else
		{
			if(event.value<Event*>()->getFrequency() <= 0)
			{
				qDebug("replace event");

				if(!query->exec("REPLACE INTO Events(ROWID, Name, Start, End, Description) VALUES("_qstr +
							   QString::number(event.value<Event*>()->getID()) + ", '"_qstr +
							   event.value<Event*>()->getName() + "', '"_qstr +
							   event.value<Event*>()->getStart().toUTC().toString("yyyy-MM-dd hh:mm:ss") + "', '"_qstr +
							   event.value<Event*>()->getEnd().toUTC().toString("yyyy-MM-dd hh:mm:ss") + "', '"_qstr +
							   event.value<Event*>()->getDescription() + "', '"_qstr +
							   reminders + "')"_qstr))
					qDebug("write error");
				db.close();
				return 2;	// replaced Event
			}
			else
			{
				qDebug("replace frequent event");

				if(!query->exec("REPLACE INTO Frequently(ROWID, Name, Start, End, Frequency, Description) VALUES("_qstr +
							   QString::number(event.value<Event*>()->getID()) + ", '"_qstr +
							   event.value<Event*>()->getName() + "', '"_qstr +
							   event.value<Event*>()->getStart().toUTC().toString("yyyy-MM-dd hh:mm:ss") + "', '"_qstr +
							   event.value<Event*>()->getEnd().toUTC().toString("yyyy-MM-dd hh:mm:ss") + "', "_qstr +
							   QString::number(event.value<Event*>()->getFrequency()) + ", '"_qstr +
							   event.value<Event*>()->getDescription() + "', '"_qstr +
							   reminders + "')"_qstr))
					qDebug("write error");
				db.close();
				return 4;	// replaces repeating event
			}
		}
		db.close();
		return 0;
	}
}
