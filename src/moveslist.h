#ifndef MOVESLIST_H
# define MOVESLIST_H

# include "logic.h"

# define WHITE_SP  6
# define BLACK_SP  1
# define WHITE     true
# define BLACK     false

class MovesList
{
public:
    MovesList(void);
    ~MovesList(void);

    int32_t            basicMoves(int32_t x_start, int32_t y_start, int32_t x_end, int32_t y_end, bool side, int32_t type);
    int32_t            pawnHit(int32_t x_start, int32_t y_start, int32_t x_end, int32_t y_end, bool side);
private:
    int32_t            _pawn_move(int32_t x_start, int32_t y_start, int32_t x_end, int32_t y_end, bool side);
    int32_t            _rook_move(int32_t x_direction, int32_t y_direction);
    int32_t            _bishop_move(int32_t x_direction, int32_t y_direction);
    int32_t            _knight_move(int32_t x_direction, int32_t y_direction);
    int32_t            _queen_move(int32_t x_direction, int32_t y_direction);
    int32_t            _king_move(int32_t x_direction, int32_t y_direction);
};

#endif 
