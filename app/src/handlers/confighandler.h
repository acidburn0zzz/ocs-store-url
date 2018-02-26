#pragma once

#include <QObject>
#include <QJsonObject>

#include "qtil_config.h"

class ConfigHandler : public QObject
{
    Q_OBJECT

public:
    explicit ConfigHandler(QObject *parent = nullptr);

public slots:
    QJsonObject getAppConfigApplication() const;
    QJsonObject getAppConfigInstallTypes() const;

private:
    void importAppConfigApplication();
    void importAppConfigInstallTypes();
    QString convertPathString(const QString &path) const;

    Qtil::Config appConfig_;
    QJsonObject appConfigApplication_;
    QJsonObject appConfigInstallTypes_;
};
