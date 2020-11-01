initial([
[empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty]
]).

%intermediate state example
intermediateMap([
[empty,empty,empty,blackBase,blackBall],
[empty,empty,empty,blackBall,blackBase],
[whiteBall,empty,whiteRing,empty,blackBall],
[whiteBase,empty,whiteBall,empty,blackRing],
[whiteBase,whiteBall,empty,empty,empty]
]).

%end state example
endMap([
[empty,empty,blackBall,whiteBall,whiteBall],
[empty,empty,empty,whiteRing,whiteBall],
[empty,empty,whiteRing,blackBall,blackBall],
[whiteBase,empty,empty,empty,blackRing],
[whiteBase,whiteBase,empty,empty,empty]
]).

colLetter(1, LE) :- LE='A'.
colLetter(2, LE) :- LE='B'.
colLetter(3, LE) :- LE='C'.
colLetter(4, LE) :- LE='D'.
colLetter(5, LE) :- LE='E'.

character(empty,C):- C=' . '.
character(whiteRing,C):- C=' W '.
character(whiteBall,C):- C='(W)'.
character(whiteBase,S):- S='WoW'.
character(blackRing,C):- C=' B '.
character(blackBall,C):- C='(B)'.
character(blackBase,S):- S='BoB'.

display_game(X) :-
    nl,
    write('       |   1   |   2   |   3   |   4   |   5   |\n'),
    write('-------|-------|-------|-------|-------|-------|\n'),
    printMatrix(X, 1).

printMatrix([],6).

printMatrix([H|T],N):-
    colLetter(N,LE),
    write('   '),
    write(LE),
    write('   |  '),
    N1 is N + 1,
    printRow(H),
    write('\n-------|-------|-------|-------|-------|-------|\n'),
    printMatrix(T,N1).

printRow([]).

printRow([H|T]):-
    character(H, C),
    write(C),
    write('  |  '),
    printRow(T).
