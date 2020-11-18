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
    checkIfWin(GameState,HasWon),
    (HasWon = 'None' ->  
        display_game(GameState,'Black'),
        checkIfWin(GameState,HasWon2),
        (HasWon2 = 'None' ->
            gameLoop(GameState,'Player','Player') %Recursive call to continue to next player turns
            ; 
            won(HasWon2)
        )
        ;
        won(HasWon)
    )
    .

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


/**Handle Move (for now not accurate) TO DO*/
%handleMove(+Input) TO DO
handleMove(_Input).


