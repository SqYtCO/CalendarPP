#include "nexteventsmodel.h"

NextEventsModel::NextEventsModel(QList<Event*>* model, QObject *parent) : QAbstractListModel(parent), nextEvents(model)
{

}

void NextEventsModel::updateModel()
{
	beginResetModel();
	endResetModel();
}

int NextEventsModel::rowCount(const QModelIndex&) const
{
	return nextEvents->size();
}

QVariant NextEventsModel::data(const QModelIndex& index, int role) const
{
	if(index.row() < nextEvents->size() && index.row() >= 0)
	{
		if(role == NextEventsModel::NAME)
			return QVariant::fromValue(nextEvents->operator[](index.row())->getName());
		else if(role == NextEventsModel::DESCRIPTION)
			return QVariant::fromValue(nextEvents->operator[](index.row())->getDescription());
		else if(role == NextEventsModel::START)
			return QVariant::fromValue(nextEvents->operator[](index.row())->getStart());
		else if(role == NextEventsModel::END)
			return QVariant::fromValue(nextEvents->operator[](index.row())->getEnd());
		else if(role == NextEventsModel::FREQUENCY)
			return QVariant::fromValue(nextEvents->operator[](index.row())->getFrequency());
	}

	return QVariant();
}

void NextEventsModel::insert(Event* item)
{
	beginInsertRows(QModelIndex(), 0, 0);
	nextEvents->push_front(item);
	endInsertRows();
}

void NextEventsModel::remove(Event* item)
{
	for(int i = 0; i < nextEvents->size(); ++i)
	{
		if(nextEvents->operator[](i) == item) {
			beginRemoveRows(QModelIndex(), i, i);
			nextEvents->removeAt(i);
			endRemoveRows();
			break;
		}
	}
}

QHash<int, QByteArray> NextEventsModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[NextEventsModel::NAME] = "name";
	roles[NextEventsModel::DESCRIPTION] = "description";
	roles[NextEventsModel::START] = "start";
	roles[NextEventsModel::END] = "end";
	roles[NextEventsModel::FREQUENCY] = "frequency";
	return roles;
}
