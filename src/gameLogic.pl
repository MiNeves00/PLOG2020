/**Start Game */
%gameStart(+TypeOfPlayer1, +TypeOfPlayer2)
gameStart('Player','Player'):-
    write('Starting Player vs Player game...'),
    nl,
    initial(GameState), %Gets initial game state
    gameLoop(GameState,'Player','Player').

/*
gameStart('Player','Com'):- %To Do
    write('Starting Player vs Com game...'),
    nl,
    initial(InitialMap),
    write('Initialized...'),
    nl,
    display_game(InitialMap).

gameStart('Com','Com'):- %To Do
    write('Starting Com vs Com game...'),
    nl,
    initial(InitialMap),
    write('Initialized...'),
    nl,
    display_game(InitialMap).
*/

/**Game Loop*/
%gameLoop(-GameState, +TypeOfPlayer1, +TypeOfPlayer2)
gameLoop(GameState,'Player','Player'):- %Each player has a turn in a loop
    display_game(GameState,'White'), %Displays game
    player_move(GameState,'White',NewGameState),
    checkIfWin(NewGameState,'White',HasWon),
    (HasWon = 'False' ->  
        display_game(NewGameState,'Black'),
        player_move(NewGameState,'Black',NewGameState2),
        checkIfWin(NewGameState2,'Black',HasWon2),
        (HasWon2 = 'False' ->
            gameLoop(NewGameState2,'Player','Player') %Recursive call to continue to next player turns
            ; 
            won('Black')
        )
        ;
        won('White')
    )
    .

/**Player Move*/
%Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd]

%player_move(+GameState,+Player,-NewGameState)
player_move(GameState,Player,NewGameState):-
    insertMove(Move),
    handleMove(GameState,Move,Player,NewGameState).


/**Insert Move*/
%insertMove(-Move)
insertMove(Move):-
    nl,
    readMove(Move),
    write('Move has been read successfuly').

%readMove(-Move)
readMove(Move):-
    write('Insert the coordinates of the piece you want to move (1-5 for Row Col)'),
    nl,
    write('If the piece is not yet on the Board use the coordinates 0 for Row and Col'),
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
readRowCoordinate(Coordinate):-
    nl,
    write('Row: '),
    read(NewCoordinate),
    (NewCoordinate < 0 -> write('Number cannot be smaller than 0'), nl,
        readRowCoordinate(Coordinate) 
        ;
        (NewCoordinate > 5 -> write('Number cannot be bigger than 5'), nl,
            readRowCoordinate(Coordinate) 
            ;
            Coordinate = NewCoordinate
        ),
        nl
    ).

readColCoordinate(Coordinate):-
    write('Col: '),
    read(NewCoordinate),
    (NewCoordinate < 0 -> write('Number cannot be smaller than 0'), nl,
        readRowCoordinate(Coordinate) 
        ;
        (NewCoordinate > 5 -> write('Number cannot be bigger than 5'), nl,
            readRowCoordinate(Coordinate) 
            ;
            Coordinate = NewCoordinate
        ),
        nl
    ).




/**Handle Move (for now not accurate) TO DO*/
%handleMove(+GameState,+Move,+Player,-NewGameState) TO DO
handleMove([Board, AllPieces],[0,0,ColIndexEnd,RowIndexEnd], Player,[NewBoard, NewAllPieces]):-
    (Player = 'White' ->
        addValueInMap(Board, RowIndexEnd, ColIndexEnd, whiteRing, NewBoard),
        AllPieces = [[_Played|NewWhitePieces], BlackPieces],
        NewAllPieces = [NewWhitePieces, BlackPieces]
        ;
        (Player = 'Black' ->
            addValueInMap(Board, RowIndexEnd, ColIndexEnd, blackRing, NewBoard),
            AllPieces = [WhitePieces, [_Played|NewBlackPieces]],
            NewAllPieces = [WhitePieces, NewBlackPieces]
            ;
            nl
        ),
        nl
    ).

/**
handleMove([Board, AllPieces],[ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd], Player,[NewBoard, AllPieces]):-
    removeValueFromMap(Board, RowIndexBegin, ColumnIndexBegin, IntermediateBoard, Removed),
    Player = 'White' ->
        Removed = 'WhiteRing' ->
            addValueInMap(IntermediateBoard, RowIndexEnd, ColIndexEnd, Removed, NewBoard),
            !
            ;
            player_move(GameState,Player,NewGameState). %deu borrada chama-se isto
*/





/**Check Win TO DO*/
/**
%checkIfWin(+GameState, -HasWon)
checkIfWin(GameState,HasWon):- %Updates HasWon If Someone Wins
    nl,
    write('Checking if win'),
    read(Input),
    winInput(Input,HasWon).

%winInput(+Input, -HasWon)
winInput(0,HasWon):- HasWon='None'.
winInput(1,HasWon):- HasWon='B'.
winInput(2,HasWon):- HasWon='W'.
*/

%checkIfWin(+GameState,+Player,-HasWon)
checkIfWin(GameState,Player,HasWon):-
    nl,
    write('Checking if its a win'),
    getBoard(GameState,Board),
    areBallsOnOpositeBase(Board,Player,Bool),
    HasWon = Bool.

%areBallsOnOpositeBase(+Board,+Player,-Bool)
areBallsOnOpositeBase(Board,'White',Bool):-
    getOpponentBaseStack(Board,'White',Base1,Base2,Base3),
    isBallOfColorOnTop(Base1,'White',Bool1),
    isBallOfColorOnTop(Base2,'White',Bool2),
    isBallOfColorOnTop(Base3,'White',Bool3),
    arefirst3BoolsTrue(Bool1,Bool2,Bool3,Bool).



areBallsOnOpositeBase(Board,'Black',Bool):-
    getOpponentBaseStack(Board,'Black',Base1,Base2,Base3),
    isBallOfColorOnTop(Base1,'Black',Bool1),
    isBallOfColorOnTop(Base2,'Black',Bool2),
    isBallOfColorOnTop(Base3,'Black',Bool3),
    arefirst3BoolsTrue(Bool1,Bool2,Bool3,Bool).  




%isBallOfColorOnTop(+Stack,+Player,-Bool)
isBallOfColorOnTop([Head|_Tail],'White',Bool):-
    (Head = whiteBall -> Bool = 'True' ; Bool = 'False').

isBallOfColorOnTop([Head|_Tail],'Black',Bool):-
    (Head = blackBall -> Bool = 'True' ; Bool = 'False').

%arefirst3BoolsTrue(+Bool1,+Bool2,+Bool3,-Bool)
arefirst3BoolsTrue(Bool1,Bool2,Bool3,Bool):-
    Bool1 = 'True',
    Bool2 = 'True',
    Bool3 = 'True',
    Bool = 'True'.

arefirst3BoolsTrue(Bool1,Bool2,Bool3,Bool):-
    Bool = 'False'.


%getOpponentBaseStack(+Board,+Player,-Base1,-Base2,-Base3)
getOpponentBaseStack(Board,'White',Base1,Base2,Base3):-
    getValueInMapStackPosition(Board,0,3,Base1),
    getValueInMapStackPosition(Board,0,4,Base2),
    getValueInMapStackPosition(Board,1,4,Base3).
    

getOpponentBaseStack(Board,'Black',Base1,Base2,Base3):-
    getValueInMapStackPosition(Board,4,0,Base1),
    getValueInMapStackPosition(Board,4,1,Base2),
    getValueInMapStackPosition(Board,3,0,Base3).

%won(+WhoWon)
won('White'):-
    nl,
    write('White wins'),nl.

won('Black'):-
    nl,
    write('Black wins'),nl.
