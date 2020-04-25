#include "P2PClient.h"
#include "tools.h"

#include <QJsonObject>
#include <QJsonDocument>

P2PClient::P2PClient(QObject *parent):QAbstractListModel (parent)
{
    messageSender = new QUdpSocket();
    messageReader = new QUdpSocket();

    messageReader->bind(DEFAULT_MESSAGE_PORT,QUdpSocket::ShareAddress | QUdpSocket::ReuseAddressHint );
    connect(messageReader,SIGNAL(readyRead()),this,SLOT(readAllMessage()));

}

int P2PClient::rowCount(const QModelIndex & ) const {
    return onlineUsersSet.count();
}

void P2PClient::clearPeers()
{
    if(onlineUsersSet.count()==0)
        return;
    beginRemoveRows(QModelIndex(),0,onlineUsersSet.count()-1);
    for (QString key:userIpSet.uniqueKeys()) {
        onlineUsersSet.remove(key);
        userIpSet.remove(key);
    }
    endRemoveRows();
}

QHash<int, QByteArray> P2PClient::roleNames(void) const {
    QHash<int, QByteArray> names;
    names.insert(Roles::Username , "username");
    names.insert(Roles::IP , "ip");
    return (names);
}

QVariant P2PClient::data(const QModelIndex & modelIndex, int role) const {
    if (!modelIndex.isValid()) {
        return (QVariant());
    }

    int index = static_cast<int>(modelIndex.row());

    if (index >= onlineUsersSet.count() || index < 0) {
        return (QVariant());
    }

    qDebug() << index << " was queried";
    switch (role) {
        case Roles::Username     : return onlineUsersSet.toList()[index];
        case Roles::IP     : return userIpSet.value(onlineUsersSet.toList()[index]).toString();
    }


    return (QVariant());
}

void P2PClient::login(QString nickname)
{
    USER_NAME=nickname;
    sendJson(P2PClient::MT_LOGIN,USER_NAME);
    qDebug()<<"logged in";
}

void P2PClient::disconnect()
{
    sendJson(P2PClient::MT_LOGOUT,USER_NAME);
    qDebug()<<"logged out";
}

void P2PClient::sendJson(message_t type, QString nick_name, QString content)
{
    QJsonObject obj;

    if(nick_name.isEmpty())
        return;

    if(type == MT_CHAT)
        obj.insert("type","chat");
    else if(type == MT_LOGIN)
        obj.insert("type","login");
    else if(type == MT_LOGOUT)
        obj.insert("type","logout");
    else if(type == MT_INVOLVE)
        obj.insert("type","involved");
    else if(type == MT_HOSTRESPONSE)
        obj.insert("type","hostresponse");
    else if(type==MT_OPPONENTMOVE)
    {
        obj.insert("type","opponentmove");
        obj.insert("to",content.split(";")[0]);
        obj.insert("move",content.split(";")[1]);
    }

    if( !content.isEmpty() )
        obj.insert("content",content);

    obj.insert("nick-name",nick_name);

    QJsonDocument doc;
    doc.setObject(obj);

    QByteArray data = doc.toJson();

    messageSender->writeDatagram(data.data(),data.size(),QHostAddress(MASK),DEFAULT_MESSAGE_PORT);
}

void P2PClient::readAllMessage()
{
    while (messageReader->hasPendingDatagrams())
    {
        QByteArray data;
        data.resize(messageReader->pendingDatagramSize());
        QHostAddress source;
        messageReader->readDatagram(data.data(),data.size(),&source);

        QJsonParseError jsonError;
        QJsonDocument doc = QJsonDocument::fromJson(data,&jsonError);
        if(jsonError.error == QJsonParseError::NoError && doc.isObject())
        {
            QJsonObject obj = doc.object();
            if(obj.contains("type") && obj.contains("nick-name"))
            {
                QJsonValue type = obj.take("type");
                QString senderNick = obj.value("nick-name").toString();
                QString info = obj.take("nick-name").toString() + "(" + Tools::toIPv4(source.toIPv4Address()) + ")" ;

                if(senderNick==USER_NAME)
                    return;
                qDebug() << "received message from:" << senderNick << " " <<type;
                if(type.toString() == "chat" && obj.contains("content"))
                {
                    emit messageShowReady(P2PClient::MT_CHAT,info,obj.take("content").toString());
                }
                else if(type.toString() == "login")
                {
                    if( !onlineUsersSet.contains(info))
                    {
                        beginInsertRows(QModelIndex(),onlineUsersSet.count(),onlineUsersSet.count());
                        onlineUsersSet.insert(info);
                        userIpSet.insert(info,source);
                        endInsertRows();
                    }
                    if( currentStatusType == ST_ONLINE)
                        sendJson(P2PClient::MT_INVOLVE,USER_NAME);

                    emit messageShowReady(P2PClient::MT_LOGIN,info,tr(" -- enter the chat room"));
                }
                else if(type.toString() == "logout")
                {
                    if(onlineUsersSet.contains(info))
                    {
                        beginRemoveRows(QModelIndex(),onlineUsersSet.count()-1,onlineUsersSet.count()-1);
                        onlineUsersSet.remove(info);
                        userIpSet.remove(info);
                        endRemoveRows();
                    }
                    emit messageShowReady(P2PClient::MT_LOGOUT,info,tr(" quit the room"));
                }
                else if(type.toString() == "involved")
                {
                    if(!onlineUsersSet.contains(info))
                    {
                        beginInsertRows(QModelIndex(),onlineUsersSet.count(),onlineUsersSet.count());
                        onlineUsersSet.insert(info);
                        userIpSet.insert(info,source);
                        endInsertRows();
                    }
                }else if(type.toString()=="hostresponse")
                {
                    emit receivedHostResponse(senderNick);
                }else if(type.toString()=="opponentmove" && obj.value("to")==USER_NAME)
                {
                    emit receivedOpponentMove(obj.value("move").toString());
                }

            }
            emit onlineUsersUpdateReady(onlineUsersSet);
        }
    }

}
void P2PClient::sendMove(QString opponent,QString move)
{
    sendJson(MT_OPPONENTMOVE,USER_NAME,opponent+";"+move);
}


QVariantMap P2PClient::get(int row) {
    QHash<int,QByteArray> names = roleNames();
    QHashIterator<int, QByteArray> i(names);
    QVariantMap res;
    while (i.hasNext()) {
        i.next();
        QModelIndex idx = index(row, 0);
        QVariant data = idx.data(i.key());
        res[i.value()] = data;
    }
    return res;
}
