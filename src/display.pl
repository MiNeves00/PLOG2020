%initial(-GameState)
initial([
[empty,empty,empty,blackBase,blackBase],
[empty,empty,empty,empty,blackBase],
[empty,empty,empty,empty,empty],
[whiteBase,empty,empty,empty,empty],
[whiteBase,whiteBase,empty,empty,empty]
]).

/**Intermediate game state example*/
intermediateMap([
[empty,empty,empty,blackBase,blackBall],
[empty,empty,empty,blackBall,blackBase],
[whiteBall,empty,whiteRing,empty,blackBall],
[whiteBase,empty,whiteBall,empty,blackRing],
[whiteBase,whiteBall,empty,empty,empty]
]).

/**End game state example*/
endMap([
[empty,empty,blackBall,whiteBall,whiteBall],
[empty,empty,empty,whiteRing,whiteBall],
[empty,empty,whiteRing,blackBall,blackBall],
[whiteBase,empty,empty,empty,blackRing],
[whiteBase,whiteBase,empty,empty,empty]
]).

/**Row to letter correspondence*/
%rowLetter(+RowNum, -Letter)
rowLetter(1, LE) :- LE='A'.
rowLetter(2, LE) :- LE='B'.
rowLetter(3, LE) :- LE='C'.
rowLetter(4, LE) :- LE='D'.
rowLetter(5, LE) :- LE='E'.

/**Atom to letter correspondence*/
%character(+Atom, -Character)
character(empty,C):- C=' . '.
character(whiteRing,C):- C=' W '.
character(whiteBall,C):- C='(W)'.
character(whiteBase,S):- S='WoW'.
character(blackRing,C):- C=' B '.
character(blackBall,C):- C='(B)'.
character(blackBase,S):- S='BoB'.

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
    rowLetter(N,LE),
    write('   '),
    write(LE), %Writes the row letter before each row
    write('   |  '),
    N1 is N + 1,
    printRow(H),
    write('\n-------|-------|-------|-------|-------|-------|\n'),
    printMatrix(T,N1).

printRow([]).

printRow([H|T]):-
    character(H, C),
    write(C), %Writes each character in its space
    write('  |  '),
    printRow(T).
