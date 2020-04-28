#ifndef DATABASE_H
# define DATABASE_H

# include "logic.h"
# include <QSqlDatabase>
# include <QSqlQuery>
# include <QSqlRecord>
# include <QVector>
# include <QSqlError>
# include <QDateTime>
# include <iostream>
# include <utility>

# define PREV       false
# define DBPATH     "chess.db"

struct Position {
    int32_t x;
    int32_t y;
    int32_t index;
};

typedef Position    PrevPosition;
typedef Position    NextPosition;

class DataBase
{
public:
    DataBase(void);
    ~DataBase(void);
    // saves move to vector
    void            addToMovesHistory(Figure *figure, int32_t listID, int32_t toX, int32_t toY);
    void            addToMovesHistory(Figure *prevFigure, int32_t p_listID, Figure *nextFigure, int32_t n_listID);
    // clear moves history
    void            clearMovesHistory(void);
    // saves to db moves history
    void            serializeMovesHistory(void);
    // work with sql tables
    int32_t         tablesSize(void);
    QString         getTableName(int32_t index);
    void            setCurrentTable(int32_t index);
    // set & get for recordIndex
    void            setRecordIndex(int32_t set);
    int32_t         getRecordIndex(void);
    // gets data from db
    bool            getRecord(int32_t &x, int32_t &y, bool flag);
    bool            getFigureIndexRecord(int32_t &figureIndex, bool flag);
    bool            isRecordOfHIt(void);

private:
    void            _createTable(void);
    int32_t         _countRows(void);
    void            _insertMove(const PrevPosition &prev, const NextPosition &next, const int32_t isHit);
    QSqlDatabase    _chessDatabase;
    QString         _currentTable;
    int32_t         _recordIndex;
    int32_t         _maxRecordIndex;
    QVector<std::tuple<PrevPosition, NextPosition, int32_t>> _movesHistory;
};

#endif
