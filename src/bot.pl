/**Choose Move*/
%choose_move(+GameState, +Player, +Level, +ListOfValidMoves, -Move)​

/**
Hard Level

Calls valueOfEachValidMoveRing to get a ListOfValues of the best possible value of the game (after a consequent ball move) for each ring move.

Finally using all of these values now in ListOfValues 
(which correspond to the best GameState value possible in case of a ring move of the index the same as the index in this ListOfValues after reversing ListOfValidMoves),
it finds the ring move which maxes this value after the ring move followed by a ballmove and returns this ring move.
*/
%choose_moveRing(+GameState, +Player, +Level, +ListOfValidMoves, -Move)​
choose_moveRing(GameState,Player,3,ListOfValidMoves,Move):-
    valueOfEachValidMoveRing(GameState,Player,3,ListOfValidMoves,[],ListOfValues),
    max_list(ListOfValues,MaxValue),
    indexOf(ListOfValues,MaxValue,Position),
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move).

/**
Medium Level

Uses the same function as for dificulty Easy
*/
choose_moveRing(GameState,Player,2,ListOfValidMoves,Move):-
    valueOfEachValidMoveRing(GameState,Player,1,ListOfValidMoves,[],ListOfValues),
    max_list(ListOfValues,MaxValue),
    indexOf(ListOfValues,MaxValue,Position),
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move).

/**
Easy Level

Simillar to the Hard function however it call valueOfEachValidMoveRing with Level 1 which causes the evaluation of the best ballmove after each ringmove to be
the one of easy level, calling choose_moveBall Easy version. Thus it won't make the best evaluation of the best ring move, making it easier for the opponent
*/
choose_moveRing(GameState,Player,1,ListOfValidMoves,Move):-
    valueOfEachValidMoveRing(GameState,Player,1,ListOfValidMoves,[],ListOfValues),
    max_list(ListOfValues,MaxValue),
    indexOf(ListOfValues,MaxValue,Position),
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move).



/**
Hard Level

Calculates the game state value of each move from the list of Valid Moves and tries to
max this value, first returns a list of values indexed the same way as the ListOfValidMoves (after reversing the ListOfValidMoves).
Then it returns the move which has the highest value. In case of a tie it returns the first one on the ListOfValidMoves.
*/
%choose_moveBall(+GameState, +Player, +Level, +ListOfValidMoves, -Move)​
choose_moveBall(GameState,Player,3,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues),
    max_list(ListOfValues,MaxValue),
    indexOf(ListOfValues,MaxValue,Position),
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move).


/**
Medium Level

Calculates the game state value of each move from the list of Valid Moves and tries to
max this value, returns a move which maxes this
*/
choose_moveBall(GameState,Player,2,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues),
    max_list(ListOfValues,MaxValue),
    indexOf(ListOfValues,MaxValue,Position),
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move).

/**
Easy Level

Randomly returns a move to play from the list of Valid Moves
*/
choose_moveBall(GameState,Player,1,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues),
    max_list(ListOfValues,MaxValue),
    indexOf(ListOfValues,MaxValue,Position),
    (Position > 0 -> Position1 is Position - 1; Position1 is Position),
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position1,RListOfValidMoves,Move).

/**
Hard Level

Simillar to choose_MoveBall however instead of trying to max the value of the GameState after the move,
it tries to minimize this value because this functions is called only to relocate the opponents balls so
it is in the players best interest to give its opponent the worst GameState possible
*/
%choose_moveBallRelocate(+GameState, +Player, +Level, +ListOfValidMoves, -Move)​
choose_moveBallRelocate(GameState,Player,3,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues),
    min_list(ListOfValues,MinValue),
    indexOf(ListOfValues,MinValue,Position),
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move).

/**
Medium Level

The same as Hard Level
*/
choose_moveBallRelocate(GameState,Player,2,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues),
    min_list(ListOfValues,MinValue),
    indexOf(ListOfValues,MinValue,Position),
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move).


/**
Easy Level

Simillar to Hard in its flow.
However instead of returning the worst move it randomly returns a move to play from the list of Valid Moves.
Actually its randomness is simply choosing always the move before the worst one exept if its the move in position 0, 
in which case it returns it
*/
choose_moveBallRelocate(GameState,Player,1,ListOfValidMoves,Move):-
    valueOfEachValidMoveBall(GameState,Player,ListOfValidMoves,[],ListOfValues),
    min_list(ListOfValues,MinValue),
    indexOf(ListOfValues,MinValue,Position),
    (Position > 1 -> Position1 is Position - 1; Position1 is Position),
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position1,RListOfValidMoves,Move).


/**
Calculates for each valid move the value of the GameState after this move and then saves it in a ListOfValues, 
indexed the reversed way from the ListOfValidMoves
Keeps calling itself until the ListOfValidMoves is empty
*/
%valueOfEachValidMoveBall(+GameState,+Player,+ListOfValidMoves,+OldListOfValues,-NewListOfValues)
valueOfEachValidMoveBall(GameState,Player,[],OldListOfValues,OldListOfValues).

valueOfEachValidMoveBall(GameState,Player,[ValidMove|TailListOfValidMoves],OldListOfValues,NewListOfValues):-
    move(GameState,ValidMove,Player,NewGameState),
    value(NewGameState,Player,Value),
    valueOfEachValidMoveBall(GameState,Player,TailListOfValidMoves,[Value|OldListOfValues],NewListOfValues).

/**
For each valid ring move calculates the NewGameState using that move and then using this
NewGameState it calculates all valid ball moves and it uses this valid ball moves to call
chooseMoveBall to get the best ball move for that ring move and calculates NewGameStateBall using this.
Returns a list of values with the values of the best possible ball moves for each ringMove, indexed the reversed way from the ListOfValidMoves
*/
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



/*
*Evaluate GameState

Based on a GameState and on the player which is moving next calculates the value of this GameState,
which simply means it calculates just how good is a GameState for said player. The higger this value the better for this player.
This value increases based on proximity to the enemy base positions and in case a ball is on the enemy base it increases by 20 for each ball there,
this is done in order to motivate playing the balls into the enemy base.
*/
%value(+GameState, +Player, -Value)​ Calculates value based on proximity of balls to enemy base
value(GameState,'White',Value):-
    getBallsPositions(GameState,'White',[Row1|Col1],[Row2|Col2],[Row3|Col3]),
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

    Value is Res + ValueBool1 + ValueBool2 +ValueBool3.



value(GameState,'Black',Value):-
    getBallsPositions(GameState,'Black',[Row1|Col1],[Row2|Col2],[Row3|Col3]),
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

    Value is Res + ValueBool1 + ValueBool2 +ValueBool3.



