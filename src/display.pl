/**Initial Game State*/
%initial(-GameState) GameState->Tabuleiro,PecasDeCadaJogador
initial(
    [
        [ %Tabuleiro
            [[],[],[],[blackBall | [blackRing | [blackBase | []]]],[blackBall | [blackRing | [blackBase | []]]]],
            [[],[],[],[],[blackBall | [blackRing | [blackBase | []]]]],
            [[],[],[],[],[]],
            [[whiteBall | [whiteRing | [whiteBase | []]]],[],[],[],[]],
            [[whiteBall | [whiteRing | [whiteBase | []]]],[whiteBall | [whiteRing | [whiteBase | []]]],[],[],[]]
        ], 
        [ %PecasDeCadaJogador
            [whiteRing,whiteRing,whiteRing,whiteRing,whiteRing],%White
            [blackRing,blackRing,blackRing,blackRing,blackRing] %Black
        ]
    ]
).

/**Game state examples TO DO*/
intermediateMap([
[[],[],[],blackBase,blackBall],
[[],[],[],blackBall,blackBase],
[whiteBall,[],whiteRing,[],blackBall],
[whiteBase,[],whiteBall,[],blackRing],
[whiteBase,whiteBall,[],[],[]]
]).

endMap([
[[],[],blackBall,whiteBall,whiteBall],
[[],[],[],whiteRing,whiteBall],
[[],[],whiteRing,blackBall,blackBall],
[whiteBase,[],[],[],blackRing],
[whiteBase,whiteBase,[],[],[]]
]).

/**Atom to letter correspondence TO DO*/
%character(+Atom, -Character)
character(empty,' . ').
character([],' . ').
character(whiteRing,' W ').
character(whiteBall,'(W)').
character(whiteBase,'WoW').
character(blackRing,' B ').
character(blackBall,'(B)').
character(blackBase,'BoB').
character(1,'A').
character(2,'B').
character(3,'C').
character(4,'D').
character(5,'E').

/**Display Game*/
%display_game(+GameState,+Player) GameState->Tabuleiro,PecasDeCadaJogador Player->QuemJoga.ex:White
display_game(GameState,Player) :-
    getBoard(GameState,Board),
    nl,
    write('       |   1   |   2   |   3   |   4   |   5   |\n'), %Writes the column number for each column
    write('-------|-------|-------|-------|-------|-------|\n'),
    %TO DO display pieces available to player
    printMatrix(Board, 1),
    getPieces(GameState,Pieces),
    printPiecesOnHand(Pieces),
    printAskNextMove(Player).

/**Next Move*/
%printAskNextMove(+Player)
printAskNextMove('White'):-
    nl,
    write('White moves...').

printAskNextMove('Black'):-
    nl,
    write('Black moves...').

/**Print Pieces*/
%printPiecesOnHand(+Pieces)
printPiecesOnHand(Pieces):-
    nl,
    getPiecesByPlayer('White',Pieces,WhitePieces),
    write('White Pieces: '),
    printPlayerPiecesOnHand(WhitePieces),
    nl,
    getPiecesByPlayer('Black',Pieces,BlackPieces),
    write('Black Pieces: '),
    printPlayerPiecesOnHand(BlackPieces),
    nl.

%printPlayerPiecesOnHand(+PlayerPieces)
printPlayerPiecesOnHand(PlayerPieces):-
    printRow(PlayerPieces).



/**GameState Utils*/
%getBoard(+GameState,-Board)
getBoard([Board|T],Board).

%getPieces(+GameState,-Pieces)
getPieces([H|[Pieces]],Pieces).

%getPiecesByPlayer(+Player,+Pieces,-PlayerPieces)
getPiecesByPlayer('White',[PlayerPieces|T],PlayerPieces).
getPiecesByPlayer('Black',[H|[PlayerPieces]],PlayerPieces).

/**Print Board*/

%printMatrix(-List, +N)
printMatrix([],6).

printMatrix([H|T],N):-
    character(N,C),
    write('   '),
    write(C), %Writes the row letter before each row
    write('   |  '),
    N1 is N + 1,
    printStackRow(H),
    write('\n-------|-------|-------|-------|-------|-------|\n'),
    printMatrix(T,N1).

printStackRow([]).

printStackRow([H|T]):-
    top(H, P),
    character(P, C),
    write(C), %Writes each character in its space
    write('  |  '),
    printStackRow(T).

%top(+L, -H)
top([], empty).

top([H | T], H).

printRow([]).

printRow([Head|Tail]) :-
    character(Head, C),
    write(C),
    write(' | '),
    printRow(Tail).