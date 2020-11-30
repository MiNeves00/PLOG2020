/**Choose Move*/
%choose_move(+GameState, +Player, +Level, +ListOfValidMoves, -Move)​

/**
Hard Level
Calculates the game state value of each move from the list of Valid Moves and tries to
max this value, returns a move which maxes this
*/
choose_moveRing(GameState,Player,3,ListOfValidMoves,Move):-
    valueOfEachValidMoveRing(GameState,Player,3,ListOfValidMoves,[],ListOfValues),
    max_list(ListOfValues,MaxValue), nl,write('MAX: '),write(MaxValue),nl, %TO DO
    indexOf(ListOfValues,MaxValue,Position), nl,write('Pos: '),write(Position),nl,
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move), nl,write('Move: '),write(Move),nl.

/**
Medium Level
Calculates the game state value of each move from the list of Valid Moves and tries to
max this value, returns a move which maxes this
*/
choose_moveRing(GameState,Player,2,ListOfValidMoves,Move):-
    valueOfEachValidMoveRing(GameState,Player,1,ListOfValidMoves,[],ListOfValues),
    max_list(ListOfValues,MaxValue), nl,write('MAX: '),write(MaxValue),nl, %TO DO
    indexOf(ListOfValues,MaxValue,Position), nl,write('Pos: '),write(Position),nl,
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move), nl,write('Move: '),write(Move),nl.

/**
Easy Level
Randomly returns a move to play from the list of Valid Moves
*/
choose_moveRing(GameState,Player,1,ListOfValidMoves,Move):-
    valueOfEachValidMoveRing(GameState,Player,1,ListOfValidMoves,[],ListOfValues),
    max_list(ListOfValues,MaxValue), nl,write('MAX: '),write(MaxValue),nl, %TO DO
    indexOf(ListOfValues,MaxValue,Position), nl,write('Pos: '),write(Position),nl,
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move), nl,write('Move: '),write(Move),nl.



/**
Hard Level
Calculates the game state value of each move from the list of Valid Moves and tries to
max this value, returns a move which maxes this
*/
choose_moveBall(GameState,Player,3,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues), nl,write('Values: '),write(ListOfValues),nl,
    max_list(ListOfValues,MaxValue), nl,write('MAX: '),write(MaxValue),nl,
    indexOf(ListOfValues,MaxValue,Position), nl,write('Pos: '),write(Position),nl,
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move), nl,write('Move: '),write(Move),nl.


/**
Medium Level
Calculates the game state value of each move from the list of Valid Moves and tries to
max this value, returns a move which maxes this
*/
choose_moveBall(GameState,Player,2,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues), nl,write('Values: '),write(ListOfValues),nl,
    max_list(ListOfValues,MaxValue), nl,write('MAX: '),write(MaxValue),nl,
    indexOf(ListOfValues,MaxValue,Position), nl,write('Pos: '),write(Position),nl,
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move), nl,write('Move: '),write(Move),nl.

/**
Easy Level
Randomly returns a move to play from the list of Valid Moves
*/
choose_moveBall(GameState,Player,1,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues), nl,write('Values: '),write(ListOfValues),nl,
    max_list(ListOfValues,MaxValue), nl,write('MAX: '),write(MaxValue),nl,
    indexOf(ListOfValues,MaxValue,Position), nl,write('Pos: '),write(Position),nl,
    (Position > 0 -> Position1 is Position - 1; Position1 is Position),write('Pos1: '),write(Position1),nl,
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position1,RListOfValidMoves,Move), nl,write('Move: '),write(Move),nl.

/**
Hard Level
Calculates the game state value of each move from the list of Valid Moves and tries to
max this value, returns a move which maxes this
*/
choose_moveBallRelocate(GameState,Player,3,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues), nl,write('Values: '),write(ListOfValues),nl,
    min_list(ListOfValues,MinValue), nl,write('MIN: '),write(MinValue),nl,
    indexOf(ListOfValues,MinValue,Position), nl,write('Pos: '),write(Position),nl,
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move), nl,write('Move: '),write(Move),nl.

/**
Medium Level
Calculates the game state value of each move from the list of Valid Moves and tries to
minize this value so that the opponent gets the worst possible ball positioning, returns a move which minimizes this
*/
choose_moveBallRelocate(GameState,Player,2,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues), nl,write('Values: '),write(ListOfValues),nl,
    min_list(ListOfValues,MinValue), nl,write('MIN: '),write(MinValue),nl,
    indexOf(ListOfValues,MinValue,Position), nl,write('Pos: '),write(Position),nl,
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move), nl,write('Move: '),write(Move),nl.


/**
Easy Level
Randomly returns a move to play from the list of Valid Moves
*/
choose_moveBallRelocate(GameState,Player,1,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues), nl,write('Values: '),write(ListOfValues),nl,
    min_list(ListOfValues,MinValue), nl,write('MIN: '),write(MinValue),nl,
    indexOf(ListOfValues,MinValue,Position), nl,write('Pos: '),write(Position),nl,
    (Position > 1 -> Position1 is Position - 1; Position1 is Position),
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position1,RListOfValidMoves,Move), nl,write('Move: '),write(Move),nl.


%valueOfEachValidMoveBall(+GameState,+Player,+ListOfValidMoves,+OldListOfValues,-NewListOfValues)
valueOfEachValidMoveBall(GameState,Player,[],OldListOfValues,OldListOfValues).

valueOfEachValidMoveBall(GameState,Player,[ValidMove|TailListOfValidMoves],OldListOfValues,NewListOfValues):-
    move(GameState,ValidMove,Player,NewGameState),
    value(NewGameState,Player,Value),
    valueOfEachValidMoveBall(GameState,Player,TailListOfValidMoves,[Value|OldListOfValues],NewListOfValues).


%valueOfEachValidMoveRing(+GameState,+Player,Level,+ListOfValidMoves,+OldListOfValues,-NewListOfValues)
valueOfEachValidMoveRing(GameState,Player,Level,[],OldListOfValues,OldListOfValues).

valueOfEachValidMoveRing(GameState,Player,Level,[ValidMove|TailListOfValidMoves],OldListOfValues,NewListOfValues):-
    move(GameState,ValidMove,Player,NewGameState),
    (Player = 'White' -> 
        valid_moves(NewGameState,'WhiteBall',ListOfBallMoves)
    ;
        valid_moves(NewGameState,'BlackBall',ListOfBallMoves)
    ),
    (ListOfBallMoves = [] ->
        valueOfEachValidMoveRing(GameState,Player,Level,TailListOfValidMoves,[0|OldListOfValues],NewListOfValues)
    ;
        choose_moveBall(GameState,Player,Level,ListOfBallMoves,BallMove),
        move(NewGameState,BallMove,Player,NewBallGameState),
        value(NewBallGameState,Player,Value),
        valueOfEachValidMoveRing(GameState,Player,Level,TailListOfValidMoves,[Value|OldListOfValues],NewListOfValues)
    ).



/**Evaluate GameState*/
%value(+GameState, +Player, -Value)​ Calculates value based on proximity of balls to enemy base
value(GameState,'White',Value):-
    getBallsPositions(GameState,'White',[Row1|Col1],[Row2|Col2],[Row3|Col3]),
    nl,write([Row1|Col1]),write([Row2|Col2]),write([Row3|Col3]),
    Res1 is 4-Row1+Col1,
    Res2 is 4-Row2+Col2,
    Res3 is 4-Row3+Col3,
    Res is Res1 + Res2 + Res3,

    getBoard(GameState,Board),
    getOpponentBaseStack(Board,'White',Base1,Base2,Base3),
    isBallOfColorOnTop(Base1,'White',Bool1),
    isBallOfColorOnTop(Base2,'White',Bool2),
    isBallOfColorOnTop(Base3,'White',Bool3),
    (Bool1 = 'True' -> ValueBool1 is 20; ValueBool1 is 0),
    (Bool2 = 'True' -> ValueBool2 is 20; ValueBool2 is 0),
    (Bool3 = 'True' -> ValueBool3 is 20; ValueBool3 is 0),

    Value is Res + ValueBool1 + ValueBool2 +ValueBool3,

    nl,write('Current Board Value for White : '),write(Value),nl.



value(GameState,'Black',Value):-
    getBallsPositions(GameState,'Black',[Row1|Col1],[Row2|Col2],[Row3|Col3]),
    nl,write([Row1|Col1]),write([Row2|Col2]),write([Row3|Col3]),
    Res1 is Row1+4-Col1,
    Res2 is Row2+4-Col2,
    Res3 is Row3+4-Col3,
    Res is Res1 + Res2 + Res3,

    getBoard(GameState,Board),
    getOpponentBaseStack(Board,'Black',Base1,Base2,Base3),
    isBallOfColorOnTop(Base1,'Black',Bool1),
    isBallOfColorOnTop(Base2,'Black',Bool2),
    isBallOfColorOnTop(Base3,'Black',Bool3),
    (Bool1 = 'True' -> ValueBool1 is 20; ValueBool1 is 0),
    (Bool2 = 'True' -> ValueBool2 is 20; ValueBool2 is 0),
    (Bool3 = 'True' -> ValueBool3 is 20; ValueBool3 is 0),

    Value is Res + ValueBool1 + ValueBool2 +ValueBool3,

    nl,write('Current Board Value for Black : '),write(Value),nl.



