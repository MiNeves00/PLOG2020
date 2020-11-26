/**Initial Game State*/
%initial(-GameState) GameState->Tabuleiro,PecasDeCadaJogador
initial(
    [
        [ %Tabuleiro
            [[empty],[empty],[empty],[blackBall | [blackRing | [blackBase | [empty]]]],[blackBall | [blackRing | [blackBase | [empty]]]]],
            [[empty],[empty],[empty],[empty],[blackBall | [blackRing | [blackBase | [empty]]]]],
            [[empty],[empty],[empty],[empty],[empty]],
            [[whiteBall | [whiteRing | [whiteBase | [empty]]]],[empty],[empty],[empty],[empty]],
            [[whiteBall | [whiteRing | [whiteBase | [empty]]]],[whiteBall | [whiteRing | [whiteBase | [empty]]]],[empty],[empty],[empty]]
        ], 
        [ %PecasDeCadaJogador
            [whiteRing,whiteRing,whiteRing,whiteRing,whiteRing],%White
            [blackRing,blackRing,blackRing,blackRing,blackRing] %Black
        ]
    ]
).

/**Game state examples TO DO*/
intermediateMap(
    [
        [ %Tabuleiro
            [[empty],[empty],[whiteBall | [empty]],[blackBall | [blackRing | [blackBase | [empty]]]],[blackBall | [blackRing | [blackBase | [empty]]]]],
            [[whiteRing | [empty]],[empty],[empty],[empty],[blackBall | [blackRing | [blackBase | [empty]]]]],
            [[whiteRing | [empty]],[empty],[empty],[empty],[blackRing | [empty]]],
            [[whiteBall | [whiteRing | [whiteBase | [empty]]]],[whiteRing | [empty]],[empty],[empty],[empty]],
            [[whiteBall | [whiteRing | [whiteBase | [empty]]]],[whiteBall | [whiteRing | [whiteBase | [empty]]]],[empty],[empty],[empty]]
        ], 
        [ %PecasDeCadaJogador
            [whiteRing,whiteRing,whiteRing,whiteRing,whiteRing],%White
            [blackRing,blackRing,blackRing,blackRing,blackRing] %Black
        ]
    ]
).

endMap(
    [
        [ %Tabuleiro
            [[],[],[],[blackBall | [blackRing | [blackBase | []]]],[blackBall | [blackRing | [blackBase | []]]]],
            [[],[],[],[],[blackBall | [blackRing | [blackBase | []]]]],
            [[],[],[],[],[]],
            [[blackBall | [whiteRing | [whiteBase | []]]],[],[],[],[]],
            [[blackBall | [whiteRing | [whiteBase | []]]],[blackBall | [whiteRing | [whiteBase | []]]],[],[],[]]
        ], 
        [ %PecasDeCadaJogador
            [whiteRing,whiteRing,whiteRing,whiteRing,whiteRing],%White
            [blackRing,blackRing,blackRing,blackRing,blackRing] %Black
        ]
    ]
).


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
character(1,'0').
character(2,'1').
character(3,'2').
character(4,'3').
character(5,'4').

/**Display Game*/
%display_game(+GameState,+Player) GameState->Tabuleiro,PecasDeCadaJogador Player->QuemJoga.ex:White
display_game(GameState,Player) :-
    getBoard(GameState,Board),
    nl,
    write('       |   0   |   1   |   2   |   3   |   4   |\n'), %Writes the column number for each column
    write('-------|-------|-------|-------|-------|-------|\n'),
    %TO DO display pieces available to player
    printMatrix(Board, 1),
    getPieces(GameState,Pieces),
    printPiecesOnHand(Pieces),
    printWhoMoves(Player).

/**Next Move*/
%printWhoMoves(+Player)
printWhoMoves('White'):-
    nl,
    write('White moves...').

printWhoMoves('Black'):-
    nl,
    write('Black moves...').

/**Print Pieces*/
%printPiecesOnHand(+Pieces)
printPiecesOnHand(Pieces):-
    nl,
    getPiecesByPlayer('White',Pieces,WhitePieces),
    write('White Pieces: '),
    printRow(WhitePieces),
    nl,
    getPiecesByPlayer('Black',Pieces,BlackPieces),
    write('Black Pieces: '),
    printRow(BlackPieces),
    nl.


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