/**Read Move*/
/**Reads a move associated with a player*/
%readMove(+Player, -Move)
/**Read Ring Move*/
/**
Solicits user for input
Reads a ring move, coordinate by coordinate, associated with a player
Returns move to caller
*/
readRingMove(Player ,Move):-
    nl, write('Place or move one of your Rings'),
    nl, write('If the piece is not yet on the Board use the coordinates -1 for Row and Col'),
    nl, write('Insert the coordinates of the piece you want to move (0-4 for Row Col)'),
    nl,nl,
    write('Insert Row of the ring to move'),
    readRingRowCoordinate(RowIndexBegin),
    nl,
    write('Insert Col of the ring to move'),
    readRingColCoordinate(ColIndexBegin),
    nl,
    write('Insert Row of your move'),
    readRowCoordinate(RowIndexEnd),
    nl,
    write('Insert Col of your move'),
    readColCoordinate(ColIndexEnd),
    (RowIndexBegin = RowIndexEnd ->
        (ColIndexBegin = ColIndexEnd -> %Staring and ending position cannot be the same
            write('Selected start coordinates and destination coordinates are the same'), nl,
            write('Cannot move piece to its own place'), nl,
            write('Insert different start and destination spaces'), nl,
            readRingMove(Player, Move),
            nl
        ;
            (ColIndexBegin = -1 ->
                (RowIndexBegin = -1 -> %If one coordinate (Row or Col) is -1, the other has to be -1
                    (Player = 'White' ->
                        Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, whiteRing] %White player means blackRing
                    ;
                        Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, blackRing] %Black player means whiteRing
                    ),
                    write('Ring Move has been read successfuly')
                ;
                    write('Wrong input'), nl,
                    readRingMove(Player, Move),
                    nl
                )
            ;
                (RowIndexBegin = -1 -> %If one coordinate (Row or Col) is -1, if the other is not -1, call readRingMove again
                    write('Wrong input'), nl,
                    readRingMove(Player, Move),
                    nl
                ;
                    (Player = 'White' ->
                        Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, whiteRing]
                    ;
                        Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, blackRing]
                    ),
                    write('Ring Move has been read successfuly')
                )
            )
        )
    ;
        (ColIndexBegin = -1 ->
            (RowIndexBegin = -1 ->
                (Player = 'White' ->
                    Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, whiteRing]
                ;
                    Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, blackRing]
                ),
                write('Ring Move has been read successfuly')
            ;
                write('Wrong input'), nl,
                readRingMove(Player, Move),
                nl
            )
        ;
            (RowIndexBegin = -1 ->
                write('Wrong input'), nl,
                readRingMove(Player, Move),
                nl
            ;
                (Player = 'White' ->
                    Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, whiteRing]
                ;
                    Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, blackRing]
                ),
                write('Ring Move has been read successfuly')
            )
        )
    ).

/**Read Ball Move*/
/**
Solicits user for input
Reads a ball move, coordinate by coordinate, associated with a player
Returns move to caller
*/
readBallMove(Player, Move):-
    nl, write('Insert the coordinates of the ball you want to move (0-4 for Row Col)'),
    nl,nl,
    write('Insert Row of the ball to move'),
    readRowCoordinate(RowIndexBegin),
    nl,
    write('Insert Col of the ball to move'),
    readColCoordinate(ColIndexBegin),
    nl,
    write('Insert Row of your move'),
    readRowCoordinate(RowIndexEnd),
    nl,
    write('Insert Col of your move'),
    readColCoordinate(ColIndexEnd),
    (RowIndexBegin = RowIndexEnd ->
        (ColIndexBegin = ColIndexEnd ->
            write('Selected start coordinates and destination coordinates are the same'), nl,
            write('Cannot move piece to its own place'), nl,
            write('Insert different start and destination spaces'), nl,
            readBallMove(Player, Move),
            nl
        ;
            (Player = 'White' ->
                Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, whiteBall] %White player means whiteBall
                ;
                Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, blackBall] %Black player means blackBall
            ),
            write('Ball Move has been read successfuly')
        )
    ;
        (Player = 'White' -> 
            Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, whiteBall]
            ;
            Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd, blackBall]
        ),
        write('Ball Move has been read successfuly')
    ).


/**Read Coordinate*/
/**
Solicits user for input
Reads a value
Verifies if it can be associated to that coordinate
If so, associates it
*/

%readCoordinate(-Coordinate)
/**Ring Row must be between -1 and 4*/
readRingRowCoordinate(Coordinate):-
    nl,
    write('Row: '),
    read(NewCoordinate),
    (NewCoordinate < -1 -> write('Number cannot be smaller than -1'), nl,
        readRowCoordinate(Coordinate) 
        ;
        (NewCoordinate > 4 -> write('Number cannot be bigger than 4'), nl,
            readRowCoordinate(Coordinate) 
            ;
            Coordinate = NewCoordinate
        ),
        nl
    ).

/**Ring Col must be between -1 and 4*/
readRingColCoordinate(Coordinate):-
    nl,
    write('Col: '),
    read(NewCoordinate),
    (NewCoordinate < -1 -> write('Number cannot be smaller than -1'), nl,
        readRowCoordinate(Coordinate) 
        ;
        (NewCoordinate > 4 -> write('Number cannot be bigger than 4'), nl,
            readRowCoordinate(Coordinate) 
            ;
            Coordinate = NewCoordinate
        ),
        nl
    ).

/**Ball Row must be between 0 and 4*/
readRowCoordinate(Coordinate):-
    nl,
    write('Row: '),
    read(NewCoordinate),
    (NewCoordinate < 0 -> write('Number cannot be smaller than 0'), nl,
        readRowCoordinate(Coordinate) 
        ;
        (NewCoordinate > 4 -> write('Number cannot be bigger than 4'), nl,
            readRowCoordinate(Coordinate) 
            ;
            Coordinate = NewCoordinate
        ),
        nl
    ).

/**Ball Col must be between 0 and 4*/
readColCoordinate(Coordinate):-
    nl,
    write('Col: '),
    read(NewCoordinate),
    (NewCoordinate < 0 -> write('Number cannot be smaller than 0'), nl,
        readRowCoordinate(Coordinate) 
        ;
        (NewCoordinate > 4 -> write('Number cannot be bigger than 4'), nl,
            readRowCoordinate(Coordinate) 
            ;
            Coordinate = NewCoordinate
        ),
        nl
    ).

/**Read Level*/
/**
Solocits user for input
Reads input as level of difficulty
*/
%readLevel(-Level)
readLevel(Level):-
    nl,nl,write('|| Difficulty Level ||'),nl,nl,
    write('1. Easy      2. Meddium      3. Hard'),nl,nl,
    readLevelAux(Level).

/**Difficulty level must be between 1 and 3*/
readLevelAux(Level):-
    nl,write('Choose Number of Com Level of Difficulty:'),nl,
    read(NewLevel),
    (NewLevel < 1 -> write('Number cannot be smaller than 1'), nl,
        readLevelAux(Level)
    ;
        (NewLevel > 3 -> write('Number cannot be bigger than 3'),nl,
            readLevelAux(Level)
        ;
            Level = NewLevel
        ),
        nl
    ).

/**Read Who's Who*/
/**
Solocits user for input
Reads input as to who is black and who is white, between computer and player
*/
%readWhosWho(-White,-Black)
readWhosWho(White, Black):-
    nl,nl,write('|| Who Moves First? White always moves first ||'),nl,nl,
    write('1. Player              2. Com'),nl,nl,
    readWhosWhite(WhiteNum),
    (WhiteNum = 1 -> White = 'Player', Black = 'Com' 
    ; White = 'Com', Black = 'Player').

/**Validates input and returns who is White*/
%readWhosWhite(-WhiteNum)
readWhosWhite(White):-
    nl,write('Choose Number:'),nl,
    read(NewWhite),
    (NewWhite < 1 -> write('Number cannot be smaller than 1'), nl,
        readWhosWhite(White)
    ;
        (NewWhite > 2 -> write('Number cannot be bigger than 2'),nl,
            readWhosWhite(White)
        ;
            White = NewWhite
        ),
        nl
    ).



