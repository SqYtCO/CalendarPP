#ifndef BACKGROUND_H
#define BACKGROUND_H

#include "eventdatabase.h"
#include <QObject>

class Background : public QObject
{
	Q_OBJECT

	EventDatabase* database;

public:
#ifndef Q_OS_ANDROID
	explicit Background(QObject* parent = nullptr);
#else
	explicit Background(EventDatabase* database, QObject* parent = nullptr);
#endif

public slots:
	void updateBackground();
};

#endif // BACKGROUND_H
