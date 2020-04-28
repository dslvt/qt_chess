#include "moveslist.h"

MovesList::MovesList(void) {
    qDebug() << "Moveslist: created list";
}

MovesList::~MovesList(void) {

}

int         MovesList::_pawn_move(int x_start, int y_start, int x_end, int y_end, bool side) {

    int     delta = (side == true) ? -1 : 1;

    if ((y_start == WHITE_SP && side == WHITE) || (y_start == BLACK_SP && side == BLACK))
    {
        if ((x_start == x_end) && ((delta * 2) == (y_end - y_start)))
            return (1);
    }
    if (x_start == x_end && delta == (y_end - y_start))
        return (1);
    return(0);
}

int         MovesList::_rook_move(int x_direction, int y_direction) {

    if (y_direction == 0 || x_direction == 0)
        return (1);
    return (0);
}

int         MovesList::_bishop_move(int x_direction, int y_direction) {

    if (x_direction == y_direction && y_direction != 0)
        return (1);
    return (0);

}

int         MovesList::_knight_move(int x_direction, int y_direction) {

    if ((y_direction == 2 && x_direction == 1) || (y_direction == 1 && x_direction == 2))
        return (1);
    return (0);
}

int         MovesList::_queen_move(int x_direction, int y_direction) {

    if ((y_direction == 0 || x_direction == 0) ^ (x_direction == y_direction && y_direction != 0))
        return (1);
    return (0);
}

int         MovesList::_king_move(int x_direction, int y_direction) {

    if (y_direction <= 1 && x_direction <= 1)
        return (1);
    return (0);
}

//write abs macros
int         MovesList::basicMoves(int x_start, int y_start, int x_end, int y_end, bool side, int type) {

    int     ret_value;
    int     y_direction = abs(y_start - y_end);
    int     x_direction = abs(x_start - x_end);

    switch (type) {
    case Logic::Pawn:
        ret_value = _pawn_move(x_start, y_start, x_end, y_end, side);
        break;
    case Logic::Rook:
        ret_value = _rook_move(x_direction, y_direction);
        break;
    case Logic::Bishop:
        ret_value = _bishop_move(x_direction, y_direction);
        break;
    case Logic::Knight:
        ret_value = _knight_move(x_direction, y_direction);
        break;
    case Logic::Queen:
        ret_value = _queen_move(x_direction, y_direction);
        break;
    case Logic::King:
        ret_value = _king_move(x_direction, y_direction);
        break;
    default:
        ret_value = 0;
        break;
    }
    return (ret_value);
}

int         MovesList::pawnHit(int x_start, int y_start, int x_end, int y_end, bool side) {

    int     delta = (side == true) ? 1 : -1;
    int     y_direction = y_start - y_end;
    int     x_direction = abs(x_start - x_end);

    if (x_direction == 1 && delta == y_direction) {
        return (1);
    }
    return (0);
}
