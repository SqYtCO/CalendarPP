TEMPLATE = app
TARGET = Calendar++

QT += qml quick sql

unix:android: QT += androidextras
else: {
QT += widgets
DEFINES += QT_WIDGETS_LIB
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources
# Q_IMPORT_PLUGIN(qsqlite)
# QTPLUGIN += qsqlite
# LIBS += -L"$$PWD" -lqsqlite

#unix:linux: {
#LIBS += -L"/usr/lib/jvm/java-1.8.0-openjdk-amd64/lib"
#INCLUDEPATH += "/usr/lib/jvm/java-1.8.0-openjdk-amd64/include/linux"
#}

CONFIG += c++11

SOURCES += \
    event.cpp \
    eventdatabase.cpp \
    main.cpp \
    androidnotificationclient.cpp \
    background.cpp \
    nexteventsmodel.cpp

RESOURCES += qml.qrc \
    images.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    event.h \
    eventdatabase.h \
    androidnotificationclient.h \
    android-sources/src/jni.h \
    android-sources/src/jni_md.h \
    jnifunctions.h \
    background.h \
    nexteventsmodel.h

DISTFILES += \
    android-sources/AndroidManifest.xml \
    android-sources/res/drawable/logo.png \
    android-sources/res/drawable/old_icon.png \
    android-sources/res/drawable/icon.png \
    android-sources/res/drawable/round_icon.png \
    android-sources/res/drawable/round_logo.png \
    android-sources/src/org/co/sqyt/calendarpp/CalendarPPService.java \
    android-sources/src/org/co/sqyt/calendarpp/CalendarPPActivity.java \
    android-sources/res/drawable/fullscreen_logo_1920x1080.png \
    README \
    android-sources/src/org/co/sqyt/calendarpp/CalendarPPBootReceiver.java \
    android-sources/src/org/co/sqyt/calendarpp/CalendarPPAlarmReceiver.java
