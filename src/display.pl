initialMap([
[empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty],
[empty,empty,empty,empty,empty]]).

colLetter(1, L) :- L='A'.
colLetter(2, L) :- L='B'.
colLetter(3, L) :- L='C'.
colLetter(4, L) :- L='D'.
colLetter(5, L) :- L='E'.

character(empty,C):- C='.'.
character(whiteRing,C):- C='W'.
character(whiteBall,C):- C='(W)'.
character(whiteBase,S):- S='WoW'.
character(blackRing,C):- C='B'.
character(blackBall,C):- C='(B)'.
character(blackBase,S):- S='BoB'.

printBoard(X) :-
    nl,
    write('   ||  1  |  2  |  3  |  4  | 5 ||\n'),
    write('---||---|---|---|---|---|---|---||\n'),
    printMatrix(X, 1).
