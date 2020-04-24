#include "database.h"

DataBase::DataBase() {
    _chessDatabase = QSqlDatabase::addDatabase("QSQLITE");
    _chessDatabase.setDatabaseName("chess.db");

    if (_chessDatabase.open())
        qDebug() << "Database: connection ok";
    else
        qDebug() << "DataBase: connection failed";
}

DataBase::~DataBase(void) {
    if (_chessDatabase.isOpen()) {
        _chessDatabase.close();
        qDebug() << "Database: closed connection";
    }
}

void    DataBase::addToMovesHistory(Figure *figure, int32_t listID, int32_t toX, int32_t toY) {
    _movesHistory << std::make_tuple(PrevPosition {figure->x, figure->y, listID}, 
                                    NextPosition {toX, toY, listID}, 
                                    0);
    qDebug() << "Database: adding move to vector";
    qDebug() << "Database: p_list id :" << listID << "prev x:" << figure->x << "prev y:" 
             << figure->y << "next x:" << toX << "next y:" << toY;
}

void    DataBase::addToMovesHistory(Figure *prevFigure, int32_t p_listID, Figure *nextFigure, int32_t n_listID) {
    _movesHistory << std::make_tuple(PrevPosition {prevFigure->x, prevFigure->y, p_listID},
                                    NextPosition {nextFigure->x, nextFigure->y, n_listID},
                                    1);
    qDebug() << "Database: adding hit move to vector";
    qDebug() << "Database: p_list id :" << p_listID << "prev x:"<<  prevFigure->x << "prev y:" << prevFigure->y
             << "n_list id :" << n_listID << "next x:" << nextFigure->x << "next y:" << nextFigure->y; 
}

void    DataBase::clearMovesHistory(void) {
    _movesHistory.clear();
    qDebug() << "Database: cleared history vector";
}

void    DataBase::serializeMovesHistory(void) {
    _createTable();

    for (auto i = 0; i < _movesHistory.size(); ++i){
        _insertMove(std::get<0>(_movesHistory[i]),
                    std::get<1>(_movesHistory[i]),
                    std::get<2>(_movesHistory[i]));
        qDebug() << "Database: inserted [" << i << "] move";
    }
}

int32_t DataBase::tablesSize(void) {
    qDebug() << "Database:" << _chessDatabase.tables().size() << "tables";
    return (_chessDatabase.tables().size());
}

QString DataBase::getTableName(int32_t index) {
    QString name(_chessDatabase.tables().at(index).toLocal8Bit().constData());

    if (!name.compare("sqlite_sequence"))
        return (QString(""));
    return (name);
}

void    DataBase::setCurrentTable(int32_t index) {
    _currentTable = getTableName(index);
    _recordIndex = 0;
    _maxRecordIndex = _countRows();
}

void    DataBase::setRecordIndex(int32_t set) {

    if (set <= _maxRecordIndex && set >= 0)
        _recordIndex = set;
}

int32_t DataBase::getRecordIndex(void) {
    return (_recordIndex);
}

bool    DataBase::getRecord(int32_t &x, int32_t &y, bool flag) {
    QSqlQuery   query;

    if (flag == PREV)
        query.prepare("select PrevPosX, PrevPosY from " + _currentTable + " where id = :index;");
    else
        query.prepare("select NextPosX, NextPosY from " + _currentTable + " where id = :index;");
    query.bindValue(":index", _recordIndex);

    if (!query.exec()) {
        qDebug() << "Database: failed to get record" << query.lastError().text();
        return (false);
    }
    query.first();
    if (flag == PREV) {
        x = query.value(query.record().indexOf("PrevPosX")).toInt();
        y = query.value(query.record().indexOf("PrevPosY")).toInt();
    }
    else {
        x = query.value(query.record().indexOf("NextPosX")).toInt();
        y = query.value(query.record().indexOf("NextPosY")).toInt();
    }
    return (true);
}

bool    DataBase::getFigureIndexRecord(int32_t &figureIndex, bool flag) {
    QSqlQuery   query;

    if (flag == PREV)
        query.prepare("select PrevListID from " + _currentTable + " where id = :index");
    else
        query.prepare("select NextListID from " + _currentTable + " where id = :index");
    query.bindValue(":index", _recordIndex);
    if (_recordIndex == 0 || !query.exec()) {
        qDebug() << "Failed to get record";
        return (false);
    }
    query.first();
    if (flag == PREV)
        figureIndex = query.value(query.record().indexOf("PrevListID")).toInt();
    else
        figureIndex = query.value(query.record().indexOf("NextListID")).toInt();
    return (true);
}

bool    DataBase::isRecordOfHIt(void) {
    QSqlQuery   query;

    query.prepare("select isHit from " + _currentTable + " where id = :index");
    query.bindValue(":index", _recordIndex);

    if (!query.exec())
        qDebug() << "Database: failed to get figure index from record" << query.lastError().text();
    query.first();
    return (query.value(0).toBool());
}

void    DataBase::_createTable(void) {
    QString     tableName(QDateTime::currentDateTime().toString("HH_mm_ss_dd_MM_yy"));
    QSqlQuery   query;

    _currentTable = tableName;
    query.prepare("CREATE TABLE game_" + tableName +  " (   ID INTEGER PRIMARY KEY AUTOINCREMENT, \
                                                            PrevListID  INTEGER, \
                                                            PrevPosX    INTEGER, \
                                                            PrevPosY    INTEGER, \
                                                            NextListID  INTEGER, \
                                                            NextPosX    INTEGER, \
                                                            NextPosY    INTEGER, \
                                                            isHit       INTEGER);");
    if (!query.exec())
        qDebug() << "Database: couldn't create the table" << query.lastError().text();
    qDebug() << "Database: created table named:" << tableName;
}

int32_t DataBase::_countRows(void) {
    int32_t     count;
    QSqlQuery   query("select count(*) from " + _currentTable);

    query.first();
    count = query.value(0).toInt();
    return (count);
}

void    DataBase::_insertMove(const PrevPosition &prev, const NextPosition &next, const int32_t isHit) {
    QSqlQuery   query;

    query.prepare("insert into game_" + _currentTable + " ( PrevListID, \
                                                            PrevPosX, \
                                                            PrevPosY, \
                                                            NextListID, \
                                                            NextPosX, \
                                                            NextPosY, \
                                                            isHit) \
                                                values    ( :PrevListID, \
                                                            :PrevPosX, \
                                                            :PrevPosY, \
                                                            :NextListID,\
                                                            :NextPosX, \
                                                            :NextPosY, \
                                                            :isHit);");
    query.bindValue(":PrevListID", prev.index);
    query.bindValue(":PrevPosX",   prev.x);
    query.bindValue(":PrevPosY",   prev.y);
    query.bindValue(":NextListID", next.index);
    query.bindValue(":NextPosX",   next.x);
    query.bindValue(":NextPosY",   next.y);
    query.bindValue(":isHit",      isHit);
    if (!query.exec())
        qDebug() << "Database: couldn't insert figure" << query.lastError().text();
}



