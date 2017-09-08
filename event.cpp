#include "event.h"
#include "eventdatabase.h"
#include <QSqlDatabase>
#include <QDebug>

Event::Event(QObject *parent) : QObject(parent), startTime(QDateTime::currentDateTimeUtc()), endTime(QDateTime::currentDateTimeUtc().addSecs(60 * 60))
{
	ID = 0;
	frequency = 0;
}

Event::operator ReminderClass() const
{
	ReminderClass temp;
	temp.name = this->eventName;
	temp.description = this->eventDescription;
	temp.start = this->startTime;
//	temp.remind = this->startTime - this->reminders.last();
	temp.remind = QDateTime::currentDateTimeUtc();

	return temp;
}

bool Event::operator==(const Event& oth) const
{
	if(this->eventName == oth.eventName && this->startTime == oth.startTime &&
			this->endTime == oth.endTime && this->frequency == oth.frequency &&
			this->eventDescription == oth.eventDescription)
		return true;
	else
		return false;
}
