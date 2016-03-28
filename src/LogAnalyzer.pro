#-------------------------------------------------
#
# Project created by QtCreator 2016-03-16T09:03:49
#
#-------------------------------------------------

QT       += core gui printsupport

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = LogAnalyzer
TEMPLATE = app
RC_FILE = LogAnalyzer.rc
CONFIG += c++11

SOURCES += main.cpp \
        version.h \
        release.h \
        mainwindow.cpp \
        qtexteditsearchwidget.cpp \
    dialogs/settingsdialog.cpp

HEADERS  += mainwindow.h \
        qtexteditsearchwidget.h \
    dialogs/settingsdialog.h

FORMS    += mainwindow.ui \
    dialogs/settingsdialog.ui

RESOURCES += \
    media.qrc
