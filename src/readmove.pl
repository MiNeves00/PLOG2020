/**Read Move TO DO posicao inicial nao pode ser a final*/
%readMove(-Move)
readRingMove(Move):-
    nl, write('Place or move one of your Rings'),
    nl, write('If the piece is not yet on the Board use the coordinates -1 for Row and Col'),
    nl, write('Insert the coordinates of the piece you want to move (0-4 for Row Col)'),
    nl,nl,
    write('Insert Row of the piece to move'),
    readRingRowCoordinate(RowIndexBegin),
    nl,
    write('Insert Col of the piece to move'),
    readRingColCoordinate(ColIndexBegin),
    nl,
    write('Insert Row of your move'),
    readRowCoordinate(RowIndexEnd),
    nl,
    write('Insert Col of your move'),
    readColCoordinate(ColIndexEnd),
    Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd],
    write('Ring Move has been read successfuly').

readBallMove(Move):-
    nl, write('Insert the coordinates of the ball you want to move (0-4 for Row Col)'),
    nl,nl,
    write('Insert Row of the piece to move'),
    readRowCoordinate(RowIndexBegin),
    nl,
    write('Insert Col of the piece to move'),
    readColCoordinate(ColIndexBegin),
    nl,
    write('Insert Row of your move'),
    readRowCoordinate(RowIndexEnd),
    nl,
    write('Insert Col of your move'),
    readColCoordinate(ColIndexEnd),
    Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd].



%readCoordinate(-Coordinate)
readRingRowCoordinate(Coordinate):-
    nl,
    write('Row: '),
    read(NewCoordinate),
    (NewCoordinate < -1 -> write('Number cannot be smaller than -1'), nl,
        readRowCoordinate(Coordinate) 
        ;
        (NewCoordinate > 4 -> write('Number cannot be bigger than 5'), nl,
            readRowCoordinate(Coordinate) 
            ;
            Coordinate = NewCoordinate
        ),
        nl
    ).

readRingColCoordinate(Coordinate):-
    nl,
    write('Col: '),
    read(NewCoordinate),
    (NewCoordinate < -1 -> write('Number cannot be smaller than 0'), nl,
        readRowCoordinate(Coordinate) 
        ;
        (NewCoordinate > 4 -> write('Number cannot be bigger than 5'), nl,
            readRowCoordinate(Coordinate) 
            ;
            Coordinate = NewCoordinate
        ),
        nl
    ).

readRowCoordinate(Coordinate):-
    nl,
    write('Row: '),
    read(NewCoordinate),
    (NewCoordinate < 0 -> write('Number cannot be smaller than -1'), nl,
        readRowCoordinate(Coordinate) 
        ;
        (NewCoordinate > 4 -> write('Number cannot be bigger than 5'), nl,
            readRowCoordinate(Coordinate) 
            ;
            Coordinate = NewCoordinate
        ),
        nl
    ).

readColCoordinate(Coordinate):-
    nl,
    write('Col: '),
    read(NewCoordinate),
    (NewCoordinate < 0 -> write('Number cannot be smaller than 0'), nl,
        readRowCoordinate(Coordinate) 
        ;
        (NewCoordinate > 4 -> write('Number cannot be bigger than 5'), nl,
            readRowCoordinate(Coordinate) 
            ;
            Coordinate = NewCoordinate
        ),
        nl
    ).
