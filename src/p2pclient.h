#ifndef P2PClient_H
#define P2PClient_H

#include <QObject>
#include <QUdpSocket>
#include <QAbstractListModel>

class P2PClient : public QAbstractListModel
{
    Q_OBJECT

    enum Roles {
        Username = Qt::UserRole+1,
        IP
    };

protected:
    int                       rowCount(const QModelIndex & parent) const override;
    QVariant                  data(const QModelIndex & index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray>    roleNames() const override;

public:

    explicit P2PClient(QObject *parent = 0);
    Q_INVOKABLE void login(QString nickname);
    Q_INVOKABLE void disconnect();
    Q_INVOKABLE void clearPeers();

    enum message_t{MT_CHAT,MT_LOGIN,MT_LOGOUT,MT_INVOLVE,MT_SYSTEM,MT_HOSTRESPONSE,MT_OPPONENTMOVE};
    enum status_t{ST_ONLINE,ST_OFFLINE};

    void setMask(QString mask) { MASK = mask; }
    void setStatus(status_t status) { currentStatusType = status; }
    Q_INVOKABLE void setUserName(QString name) { USER_NAME = name; }
    Q_INVOKABLE void sendHostResponse(QString hostName){sendJson(MT_HOSTRESPONSE,USER_NAME,hostName);}
    Q_INVOKABLE QVariantMap get(int row);
    Q_INVOKABLE void sendMove(QString opponent,QString move);


    status_t status() { return currentStatusType; }

    void sendJson(message_t type, QString nick_name, QString content="");

private:

    QString MASK;
    QString USER_NAME;

    status_t currentStatusType;

    QSet<QString> onlineUsersSet;
    QHash<QString,QHostAddress> userIpSet;


    QUdpSocket * messageSender,* messageReader;
    const qint16 DEFAULT_MESSAGE_PORT = 6108;

signals:

    void messageShowReady(P2PClient::message_t type, QString hint, QString content);
    void onlineUsersUpdateReady(QSet<QString> set);
    void receivedHostResponse(QString responder);
    void receivedOpponentMove(QString move);

private slots:

    void readAllMessage();

};

#endif // P2PClient_H
