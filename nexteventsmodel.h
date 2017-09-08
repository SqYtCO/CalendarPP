#ifndef NEXTEVENTSMODEL_H
#define NEXTEVENTSMODEL_H

#include "eventdatabase.h"
#include <QAbstractListModel>

class NextEventsModel : public QAbstractListModel
{
	Q_OBJECT

public:
	explicit NextEventsModel(QList<Event *> *model, QObject* parent = nullptr);
	~NextEventsModel() = default;

	int rowCount(const QModelIndex&) const override;
	QVariant data(const QModelIndex& index, int role) const override;
//	bool removeColumns(int column, int count, const QModelIndex &parent);
//	bool insertRow(int row, const QModelIndex &parent);

public slots:
	void insert(Event *item);
	void remove(Event* item);
	void updateModel();

protected:
	QHash<int, QByteArray> roleNames() const override;

private:
	QList<Event*>* nextEvents;

	enum { NAME = Qt::UserRole + 1, DESCRIPTION, START, END, FREQUENCY };
};

#endif // NEXTEVENTSMODEL_H
