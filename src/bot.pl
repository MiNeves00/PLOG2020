/**Choose Move*/
%choose_move(+GameState, +Player, +Level, +ListOfValidMoves, -Move)​
choose_moveRing(GameState,Player,1,[Move|ListOfValidMoves],Move).


choose_moveBall(GameState,Player,1,ListOfValidMoves,Move):-
    valueOfEachValidMove(GameState,Player,ListOfValidMoves,[],ListOfValues), nl,write('Values: '),write(ListOfValues),nl,
    max_list(ListOfValues,MaxValue), nl,write('MAX: '),write(MaxValue),nl,
    indexOf(ListOfValues,MaxValue,Position), nl,write('Pos: '),write(Position),nl,
    reverseL(ListOfValidMoves,RListOfValidMoves,[]),
    nth0(Position,RListOfValidMoves,Move), nl,write('Move: '),write(Move),nl.



%valueOfEachValidMove(+GameState,+Player,+ListOfValidMoves,+OldListOfValues,-NewListOfValues)
valueOfEachValidMove(GameState,Player,[],OldListOfValues,OldListOfValues).

valueOfEachValidMove(GameState,Player,[ValidMove|TailListOfValidMoves],OldListOfValues,NewListOfValues):-
    move(GameState,ValidMove,Player,NewGameState),
    value(NewGameState,Player,Value),
    valueOfEachValidMove(GameState,Player,TailListOfValidMoves,[Value|OldListOfValues],NewListOfValues).

%posOfHighestValue(+ListOfValues,MaxValue,+Index,-Pos)
posOfHighestValue([MaxValue|TailListOfValues],MaxValue,0,0).
posOfHighestValue([MaxValue|TailListOfValues],MaxValue,Index,Pos):- Pos is Index - 1.

posOfHighestValue([H|TailListOfValues],MaxValue,Index,Pos):-
    Index1 is Index+1,
    posOfHighestValue(TailListOfValidMoves,MaxValue,Index1,Pos).
    



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



