/**Evaluate GameState*/
%value(+GameState, +Player, -Value)​ Calculates value based on proximity of balls to enemy base and substracts baded on the opponent balls
value(GameState,'White',Value):-
    getBallsPositions(GameState,'White',[Row1|Col1],[Row2|Col2],[Row3|Col3]),
    Res1 is 4-Row1+Col1,
    Res2 is 4-Row2+Col2,
    Res3 is 4-Row3+Col3,
    Value1 is Res1 + Res2 + Res3,

    getBallsPositions(GameState,'Black',[BRow1|BCol1],[BRow2|BCol2],[BRow3|BCol3]),
    BRes1 is BRow1+4-BCol1,
    BRes2 is BRow2+4-BCol2,
    BRes3 is BRow3+4-BCol3,
    Value2 is BRes1 + BRes2 + BRes3,

    Value is Value1 - Value2,
    nl,write('->Advantage<-     If value is larger than 0 than the team moving next has an advantage'),nl,
    nl,write('Current Value : '),write(Value),nl.

value(GameState,'Black',Value):-
    getBallsPositions(GameState,'Black',[Row1|Col1],[Row2|Col2],[Row3|Col3]),
    Res1 is Row1+4-Col1,
    Res2 is Row2+4-Col2,
    Res3 is Row3+4-Col3,
    Value1 is Res1 + Res2 + Res3,

    getBallsPositions(GameState,'White',[WRow1|WCol1],[WRow2|WCol2],[WRow3|WCol3]),
    WRes1 is 4-WRow1+WCol1,
    WRes2 is 4-WRow2+WCol2,
    WRes3 is 4-WRow3+WCol3,
    Value2 is WRes1 + WRes2 + WRes3,

    Value is Value1 - Value2,
    nl,write('->Advantage<-     If value is larger than 0 than the team moving next has an advantage'),nl,
    nl,write('Current Value : '),write(Value),nl.




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
