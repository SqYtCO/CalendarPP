#ifndef EVENT_H
#define EVENT_H

#include <QObject>
#include <QDateTime>
#include <QList>
#include <QtAlgorithms>

#include <algorithm>		// std::sort; only available on Desktop

struct ReminderClass;

class Event : public QObject
{
	Q_OBJECT

	Q_PROPERTY(int ID READ getID WRITE setID NOTIFY IDChanged)
	Q_PROPERTY(QString eventName READ getName WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QDateTime startTime READ getStart WRITE setStart NOTIFY startChanged)
	Q_PROPERTY(QDateTime endTime READ getEnd WRITE setEnd NOTIFY endChanged)
	Q_PROPERTY(QString eventDescription READ getDescription WRITE setDescription NOTIFY descriptionChanged)
	Q_PROPERTY(int frequency READ getFrequency WRITE setFrequency NOTIFY frequencyChanged)
	Q_PROPERTY(QDateTime firstFrequentEvent READ getFirstFrequentEvent WRITE setFirstFrequentEvent NOTIFY firstFrequentEventChanged)
	Q_PROPERTY(QList<int> reminders READ getReminders WRITE setReminders NOTIFY remindersChanged)

	int ID;
	QString eventName;
	QDateTime startTime;
	QDateTime endTime;
	QString eventDescription;
	int frequency;					// frequency in days: startTime + frequency = nextEvent
/*	FREQUENCY:
 *	0: no repetition
 *	1-30: every x. day
 * 	31 * x: every x. month
 * 	365 * x: every x. year
 */
	QDateTime firstFrequentEvent;

	QList<int> reminders;	// reminder in minutes: startTime - reminder = reminderNotification; max. reminder: 2 week (20160 min)

public:
	explicit Event(QObject *parent = nullptr);
	~Event() = default;

	operator ReminderClass() const;
	bool operator==(const Event& oth) const;

	const int& getID() const { return ID; }
	const QString& getName() const { return eventName; }
	const QDateTime& getStart() const { return startTime; }
	const QDateTime& getEnd() const { return endTime; }
	const QString& getDescription() const { return eventDescription; }
	const int& getFrequency() const { return frequency; }
	const QDateTime& getFirstFrequentEvent() const { return firstFrequentEvent; }
	const QList<int>& getReminders() const { return reminders; }
	const int& getReminder(const int& index) const { return reminders.at(index); }


	void addReminder(int min) { reminders.push_back(min); }
	void removeReminderAt(int index) { reminders.removeAt(index); }
	void sortReminders() { std::sort(reminders.begin(), reminders.end()); }

signals:
	void IDChanged();
	void nameChanged();
	void startChanged();
	void endChanged();
	void descriptionChanged();
	void frequencyChanged();
	void firstFrequentEventChanged();
	void remindersChanged();

public slots:
	void setID(const int& id) { ID = id; }
	void setName(const QString& name) { eventName = name; }
	void setStart(const QDateTime& start) { startTime = start; }
	void setEnd(const QDateTime& end) { endTime = end; }
	void setDescription(const QString& description) { eventDescription = description; }
	void setFrequency(const int& frequency) { this->frequency = frequency; }
	void setFirstFrequentEvent(const QDateTime& firstEvent) { firstFrequentEvent = firstEvent; }
	void setReminders(const QList<int>& reminders) { this->reminders = reminders; }
};

Q_DECLARE_METATYPE(Event*)

struct ReminderClass
{
	QString name;
	QString description;
	QDateTime start;
	QDateTime remind;
	int timeToStart;
};

#endif // EVENT_H
