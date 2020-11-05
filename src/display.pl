%initial(-GameState)
initial([
[[],[],[],[blackBall | [blackRing | [blackBase | []]]],[blackBall | [blackRing | [blackBase | []]]]],
[[],[],[],[],[blackBall | [blackRing | [blackBase | []]]]],
[[],[],[],[],[]],
[[whiteBall | [whiteRing | [whiteBase | []]]],[],[],[],[]],
[[whiteBall | [whiteRing | [whiteBase | []]]],[whiteBall | [whiteRing | [whiteBase | []]]],[],[],[]]
]).

/**Intermediate game state example*/
intermediateMap([
[[],[],[],blackBase,blackBall],
[[],[],[],blackBall,blackBase],
[whiteBall,[],whiteRing,[],blackBall],
[whiteBase,[],whiteBall,[],blackRing],
[whiteBase,whiteBall,[],[],[]]
]).

/**End game state example*/
endMap([
[[],[],blackBall,whiteBall,whiteBall],
[[],[],[],whiteRing,whiteBall],
[[],[],whiteRing,blackBall,blackBall],
[whiteBase,[],[],[],blackRing],
[whiteBase,whiteBase,[],[],[]]
]).

/**Atom to letter correspondence*/
%character(+Atom, -Character)
character(empty,C):- C=' . '.
character([],C):- C=' . '.
character(whiteRing,C):- C=' W '.
character(whiteBall,C):- C='(W)'.
character(whiteBase,S):- S='WoW'.
character(blackRing,C):- C=' B '.
character(blackBall,C):- C='(B)'.
character(blackBase,S):- S='BoB'.
character(1, C) :- C='A'.
character(2, C) :- C='B'.
character(3, C) :- C='C'.
character(4, C) :- C='D'.
character(5, C) :- C='E'.

/**Display Game*/
%display_game(+GameState)
display_game(X) :-
    nl,
    write('       |   1   |   2   |   3   |   4   |   5   |\n'), %Writes the column number for each column
    write('-------|-------|-------|-------|-------|-------|\n'),
    printMatrix(X, 1).

%printMatrix(-List, +N)
printMatrix([],6).

printMatrix([H|T],N):-
    character(N,C),
    write('   '),
    write(C), %Writes the row letter before each row
    write('   |  '),
    N1 is N + 1,
    printRow(H),
    write('\n-------|-------|-------|-------|-------|-------|\n'),
    printMatrix(T,N1).

printRow([]).

printRow([H|T]):-
    top(H, P),
    character(P, C),
    write(C), %Writes each character in its space
    write('  |  '),
    printRow(T).

%top(+L, -H)
top([], empty).

top([H | T], H).