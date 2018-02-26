#pragma once

#include <QObject>
#include <QJsonObject>

namespace Qtil {
class NetworkResource;
}

class ConfigHandler;

class OcsUrlHandler : public QObject
{
    Q_OBJECT

public:
    explicit OcsUrlHandler(const QString &ocsUrl, ConfigHandler *configHandler, QObject *parent = nullptr);

signals:
    void started();
    void finishedWithSuccess(QJsonObject result);
    void finishedWithError(QJsonObject result);
    void downloadProgress(QString id, qint64 bytesReceived, qint64 bytesTotal);

public slots:
    QString ocsUrl() const;
    QJsonObject metadata() const;

    void process();
    bool isValid() const;
    void openDestination() const;

private slots:
    void networkResourceFinished(Qtil::NetworkResource *resource);

private:
    void parse();
    void saveDownloadedFile(Qtil::NetworkResource *resource);
    void installDownloadedFile(Qtil::NetworkResource *resource);

    QString ocsUrl_;
    ConfigHandler *configHandler_;
    QJsonObject metadata_;
};
