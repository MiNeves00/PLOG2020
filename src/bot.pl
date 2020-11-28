/**Evaluate GameState*/
%value(+GameState, +Player, -Value)​
value(GameState,Player,Value):-
    getBallsPositions(GameState,Player,[Row1|Col1],[Row2|Col2],[Row3|Col3]),
    nl,write('BALL POS -Col|Row'),nl,
    write('Ball1 : '), write(Col1),write(' | '),write(Row1),nl,
    write('Ball2 : '), write(Col2),write(' | '),write(Row2),nl,
    write('Ball3 : '), write(Col3),write(' | '),write(Row3),nl,
    Value = 0.




%getBallsPositions(+GameState,+Player,-BallPos1,-BallPos2,-BallPos3)
getBallsPositions([Board|Pieces],Player,BallPos1,BallPos2,BallPos3):-
    getBallsPositionsAux(Board,Player,BallPos1Row,BallPos1Col,4,4),
    Num1 is BallPos1Row-1,
    getBallsPositionsAux(Board,Player,BallPos2Row,BallPos2Col,Num1,BallPos1Col),
    Num2 is BallPos2Row-1,
    getBallsPositionsAux(Board,Player,BallPos3Row,BallPos3Col,Num2,BallPos2Col),
    BallPos1 = [BallPos1Row|BallPos1Col],
    BallPos2 = [BallPos2Row|BallPos2Col],
    BallPos3 = [BallPos3Row|BallPos3Col].
    



%getBallsPositionsAux(+Board,+Player,-BallRow1,-BallCol1,+Row,+Col)
getBallsPositionsAux(Board,Player,BallRow1,BallCol1,-1,-1):-
    getValueInMapStackPosition(Board,0,0,Stack),
    isBallOfColorOnTop(Stack,Player,Bool),
    (Bool = 'True' -> 
        BallRow1 = 0, BallCol1 = 0
    ;
        write('panic getting balls')
    ).

getBallsPositionsAux(Board,Player,BallRow1,BallCol1,-1,Col):-
    Col > -1, Col1 is Col-1,
    getBallsPositionsAux(Board,Player,BallRow1,BallCol1,4,Col1).

getBallsPositionsAux(Board,Player,BallRow1,BallCol1,Row,Col):-
    Row > -1, Row1 is Row-1,
    getValueInMapStackPosition(Board,Row,Col,Stack),
    isBallOfColorOnTop(Stack,Player,Bool),
    (Bool = 'True' -> 
        BallRow1 = Row, BallCol1 = Col
    ;
        getBallsPositionsAux(Board,Player,BallRow1,BallCol1,Row1,Col)
    ).
