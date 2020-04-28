#pragma once
# include <memory>
# include <QAbstractListModel>
# include <QDebug>
# include <QList>
# include <QByteArray>
# include <QHash>
# include <QRandomGenerator>

class           MovesList;
class           DataBase;

struct          Figure {
    bool        side;
    unsigned    type;
    int         x;
    int         y;
    bool isHit;
};

class Logic: public QAbstractListModel
{
    Q_OBJECT
public:

    enum GlobalConstants {
        BOARD_SIZE = 8
    };

    enum Roles {
        Side = Qt::UserRole,
        Type,
        PositionX,
        PositionY
    };

    enum Types {
        Pawn,
        Rook,
        Bishop,
        Knight,
        Queen,
        King
    };

public:
    explicit   Logic(QObject *parent = 0);
    ~Logic();

    Q_PROPERTY(int boardSize READ boardSize CONSTANT);
    int                       boardSize(void) const;
    Q_PROPERTY(int gamesSaved READ gamesSaved CONSTANT);
    int                       gamesSaved(void) const;

    Q_INVOKABLE void          clear(void);
    Q_INVOKABLE bool          move(int fromX, int fromY, int toX, int toY);
    Q_INVOKABLE void          newGame(void);
    Q_INVOKABLE void          saveGame(void);
    Q_INVOKABLE void          selectGame(int index);
    Q_INVOKABLE QString       gameName(int index);
    Q_INVOKABLE void          next(void);
    Q_INVOKABLE void          prev(void);
    Q_INVOKABLE bool          isWhiteTurn(void);
    Q_INVOKABLE bool          isValidMove(int fromX, int fromY, int toX, int toY);
    Q_INVOKABLE void          doAiTurn(void);
    Q_INVOKABLE int 		  getSteps(void);

    int pieceScore(unsigned);
    int hitScore(int fromX, int fromY, int toX, int toY);

protected:
    int                       rowCount(const QModelIndex & parent) const override;
    QVariant                  data(const QModelIndex & index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray>    roleNames() const override;

private:
    struct                     Impl;
    std::unique_ptr<Impl>      impl;
    std::unique_ptr<MovesList> movesList;
    std::unique_ptr<DataBase>  db;
    int32_t                    _turn;
    void                       _applyChanges(int32_t x, int32_t y, int32_t index);
    void                       _saveMove(int32_t listID, int32_t listIDH, int32_t isHit, int32_t toX, int32_t toY);
};
