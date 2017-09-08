#ifndef JNIFUNCTIONS_H
#define JNIFUNCTIONS_H

#ifdef Q_OS_LINUX
#include <android-sources/src/jni_md.h>
#else
#include <android-sources/src/jni.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

JNIEXPORT /*jobjectArray*/jstring JNICALL Java_org_co_sqyt_calendarpp_CalendarPPService_checkNext(JNIEnv* env, jobject obj, jstring path)
{
	Q_UNUSED(obj);

	const char* cstr = env->GetStringUTFChars(path, 0);
	QString filePath(cstr);
	env->ReleaseStringUTFChars(path, cstr);
	qDebug() << filePath;
	EventDatabase database(filePath + QString(DB_NAME));

//	QVector<QString> reminderClassVector;
	QString qresult;
	for(const auto& a : database.nextReminder())
	{
		qresult += a.name;
		qresult += '\t';
		qresult += a.description;
		qresult += '\t';
		qresult += a.start.toLocalTime().toString("yyyy-MM-dd-HH-mm");
		qresult += '\t';
		qresult += a.remind.toLocalTime().toString("yyyy-MM-dd-HH-mm");
		qresult += '\t';
		qresult += QString::number(a.timeToStart);
		qresult += '\t';
	/*	reminderClassVector.push_back(QString());
		reminderClassVector.last() += a.name;
		reminderClassVector.last() += '\t';
		reminderClassVector.last() += a.description;
		reminderClassVector.last() += '\t';
		reminderClassVector.last() += a.start.toLocalTime().toString();
		reminderClassVector.last() += '\t';
		reminderClassVector.last() += a.remind.toLocalTime().toString();
		reminderClassVector.last() += '\t';
		reminderClassVector.last() += QString::number(a.timeToStart);
		reminderClassVector.last() += '\t';*/
	}

	jstring result = env->NewStringUTF(qresult.toLatin1().data());

/*	jstring str;
	jobjectArray result;

	result = env->NewObjectArray(reminderClassVector.size(), env->FindClass("java/lang/String"), 0);

	for(int i = 0; i < reminderClassVector.size(); ++i)
	{
		str = env->NewStringUTF(reminderClassVector[i].toLatin1().data());
		env->SetObjectArrayElement(result, i, str);
	}*/

	return result;
}

#ifdef __cplusplus
}
#endif

#endif // JNIFUNCTIONS_H
