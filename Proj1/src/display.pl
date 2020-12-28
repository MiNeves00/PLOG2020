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

/**Intermediate Game State Examples*/
intermediateMap(
    [
        [ %Tabuleiro
            [[empty],[empty],[whiteRing | [empty]],[blackBall | [blackRing | [blackBase | [empty]]]], [blackRing | [blackBase | [empty]]]],
            [[empty],[empty], [empty],[empty],[blackBall | [blackRing | [blackBase | [empty]]]]],
            [[whiteRing | [empty]],[empty],[whiteBall | [whiteRing | [empty]]],[empty],[blackRing | [empty]]],
            [[whiteBall | [whiteRing | [whiteBase | [empty]]]],[whiteRing | [empty]],[blackBall | [blackRing | [empty]]],[empty],[empty]],
            [[whiteBall | [whiteRing | [whiteBase | [empty]]]],[whiteRing | [whiteBase | [empty]]],[whiteRing | [empty]],[empty],[empty]]
        ], 
        [ %PecasDeCadaJogador
            [],%White
            [blackRing,blackRing,blackRing] %Black
        ]
    ]
).

intermediateMapV2(
    [
        [ %Tabuleiro
            [[empty],[blackRing | [empty]],[whiteRing | [empty]],[blackBall | [blackRing | [blackBase | [empty]]]], [blackRing | [blackBase | [empty]]]],
            [[whiteRing | [empty]],[empty],[blackBall | [blackRing | [empty]]],[empty],[blackBall | [blackRing | [blackBase | [empty]]]]],
            [[whiteRing | [empty]],[empty],[whiteBall | [whiteRing | [empty]]],[empty],[whiteBall| [whiteRing | [empty]]]],
            [[whiteRing | [whiteBase | [empty]]],[whiteRing | [empty]],[blackBall | [blackRing | [empty]]],[empty],[empty]],
            [[whiteBall | [whiteRing | [whiteBase | [empty]]]],[whiteBall | [whiteRing | [whiteBase | [empty]]]],[whiteBall | [whiteRing | [empty]]],[empty],[empty]]
        ], 
        [ %PecasDeCadaJogador
            [whiteRing],%White
            [blackRing,blackRing,blackRing] %Black
        ]
    ]
).

intermediateMapV3(
    [
        [ %Tabuleiro
            [[empty],[blackBall | [blackRing | [blackBase | [empty]]]],[whiteRing | [empty]],[whiteBall | [whiteRing | [whiteBase | [empty]]]], [whiteBall | [whiteRing | [whiteBase | [empty]]]]],
            [[whiteRing | [empty]],[empty],[blackBall | [blackRing | [empty]]],[empty],[blackRing | [empty]]],
            [[whiteRing | [empty]],[empty],[whiteBall | [whiteRing | [empty]]],[empty],[whiteBall| [whiteRing | [empty]]]],
            [[whiteRing | [whiteBase | [empty]]],[whiteRing | [empty]],[blackBall | [blackRing | [empty]]],[empty],[empty]],
            [[blackRing | [blackBase | [empty]]],[blackBall | [blackRing | [blackBase | [empty]]]],[whiteBall | [whiteRing | [empty]]],[empty],[empty]]
        ], 
        [ %PecasDeCadaJogador
            [whiteRing],%White
            [blackRing,blackRing,blackRing] %Black
        ]
    ]
).


endMap(
    [
        [ %Tabuleiro
            [[empty],[empty],[whiteBall | [whiteRing | [empty]]],[blackRing | [blackBase | [empty]]], [blackRing | [blackBase | [empty]]]],
            [[empty],[empty], [empty],[empty],[blackRing | [blackBase | [empty]]]],
            [[whiteRing | [empty]],[empty],[whiteBall | [whiteRing | [empty]]],[empty],[blackRing | [empty]]],
            [[blackBall | [blackRing | [whiteRing | [whiteBase | [empty]]]]],[whiteBall | [whiteRing | [empty]]],[blackRing | [empty]],[empty],[empty]],
            [[blackBall | [blackRing | [whiteBase | [empty]]]],[blackBall | [blackRing | [whiteBase | [empty]]]],[whiteRing | [empty]],[empty],[empty]]
        ], 
        [ %PecasDeCadaJogador
            [whiteRing, whiteRing],%White
            [] %Black
        ]
    ]
).


/**Atom to letter correspondence*/
%character(+Atom, -Character) Atom->Atomo Representativo Character->Carater a ser Imprimido
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
    getBoard(GameState,Board), %Obtem tabuleiro para o poder imprimir
    nl,
    write('       |   0   |   1   |   2   |   3   |   4   |\n'), %Escreve o numero da coluna para cada coluna
    write('-------|-------|-------|-------|-------|-------|\n'),
    printMatrix(Board, 1), %Imprime a matriz
    getPieces(GameState,Pieces), % Obtem pecas em mao de cada jogador
    printPiecesOnHand(Pieces), %Imprime as pecas
    printWhoMoves(Player). %Imprime quem joga

/**Next Move*/
/**Prints who will move next*/
%printWhoMoves(+Player)
printWhoMoves('White'):-
    nl,
    write('White moves...').

printWhoMoves('Black'):-
    nl,
    write('Black moves...').

/**Print Pieces*/
/**Prints pieces on hand*/
%printPiecesOnHand(+Pieces)
printPiecesOnHand(Pieces):-
    nl,
    getPiecesByPlayer('White',Pieces,WhitePieces),
    write('White Pieces: '),
    printRow(WhitePieces), %If player has no pieces left, no pieces will be printed, just '*Player* Pieces: ' 
    nl,
    getPiecesByPlayer('Black',Pieces,BlackPieces),
    write('Black Pieces: '),
    printRow(BlackPieces),
    nl.


/**GameState Utils*/
%getBoard(+GameState,-Board)
getBoard([Board|T],Board). %Board is the Head of the GameState List

%getPieces(+GameState,-Pieces)
getPieces([H|[Pieces]],Pieces). %Pieces is the Last Item of the GameState List

%getPiecesByPlayer(+Player,+Pieces,-PlayerPieces)
getPiecesByPlayer('White',[PlayerPieces|T],PlayerPieces). %White pieces first
getPiecesByPlayer('Black',[H|[PlayerPieces]],PlayerPieces). %Black pieces 2nd

/**Print Board*/
%printMatrix(-List, +N)
printMatrix([],6).

printMatrix([H|T],N):-
    character(N,C),
    write('   '),
    write(C), %Escreve o numero da linha antes de cada linha
    write('   |  '),
    N1 is N + 1,
    printStackRow(H), %Imprime a linha do tabuleiro
    write('\n-------|-------|-------|-------|-------|-------|\n'),
    printMatrix(T,N1).

printStackRow([]).

printStackRow([H|T]):-
    top(H, P),
    character(P, C),
    write(C), %Escreve cada carater no seu espaco
    write('  |  '),
    printStackRow(T).

%top(+L, -H)
top([], empty).

top([H | T], H).

printRow([]).

printRow([Head|Tail]) :-
    character(Head, C),
    write(C), %Escreve sempre a cabeca da lista
    write(' | '),
    printRow(Tail).