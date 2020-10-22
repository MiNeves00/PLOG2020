menu:-
    printMenu,
    write('>>> Insert your Game Mode or Exit the Game: '),
    readInput(Input), %TO DO
    handleInput(Input).

printMenu:-
    nl,nl,
    write('___________________________________________________________________________'),nl,
    write('||-----------------------------------------------------------------------||'),nl,
    write('||                                                                       ||'),nl,
    write('||                                                                       ||'),nl,
    write('||                             ##############                            ||'),nl,
    write('||                             ##MITSUDOMOE##                            ||'),nl,
    write('||                             ##############                            ||'),nl,
    write('||                                                                       ||'),nl,
    write('||                                 _______                               ||'),nl,
    write('||                                 Made By                               ||'),nl,
    write('||                                                                       ||'),nl,
    write('||                           Miguel Carreira Neves                       ||'),nl,
    write('||                              Jose Miguel Macaes                       ||'),nl,
    write('||                   ====================================                ||'),nl,
    write('||                                                                       ||'),nl,
    write('||         # 1. Player vs Player             # 2. Player vs Computer     ||'),nl,
    write('||                                                                       ||'),nl,
    write('||                                                                       ||'),nl,
    write('||         # 3. Computer vs Computer         # 0. Exit                   ||'),nl,
	write('||                                                                       ||'),nl,
    write('||                                                                       ||'),nl,
    write('||-----------------------------------------------------------------------||'),nl,
    write('___________________________________________________________________________'),nl,nl,nl.

handleInput(1):-
    gameStart('Player','Player').

handleInput(2):-
    gameStart('Player','Com').

handleInput(3):-
    gameStart('Com','Com').

handleInput(0):-
    write('Exiting Game... See you soon!').

handleInput(_SomeOther):-
    write('Input incorrect please insert you option again: '),
    readInput(Input),
    handleInput(Input).

