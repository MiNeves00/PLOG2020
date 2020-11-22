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
    checkIfWin(NewGameState,HasWon),
    (HasWon = 'None' ->  
        display_game(GameState,'Black'),
        player_move(GameState,'Black',NewGameState2),
        checkIfWin(NewGameState2,HasWon2),
        (HasWon2 = 'None' ->
            gameLoop(GameState,'Player','Player') %Recursive call to continue to next player turns
            ; 
            won(HasWon2)
        )
        ;
        won(HasWon)
    )
    .

/**Player Move*/
%Move = [ColIndexBegin,RowIndexBegin,ColIndexEnd,RowIndexEnd]

%player_move(+GameState,+Player,-NewGameState)
player_move(GameState,Player,NewGameState):-
    insertMove(Move).
    %handleMove(GameState,Move,NewGameState).


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
%handleMove(+GameState,+Move,-NewGameState) TO DO
handleMove(GameState,Move,NewGameState):-
    player_move(GameState,Player,NewGameState). %deu borrada chama-se isto

/**Check Win (for now not accurate) TO DO*/
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

%won(+WhoWon)
won('W'):-
    nl,
    write('White wins').

won('B'):-
    nl,
    write('Black wins').
