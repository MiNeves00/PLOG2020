:-consult('utils.pl').
:-consult('display.pl').
:- use_module(library(clpfd)).
:- use_module(library(system)).
:- use_module(library(lists)).





grape:-
    /*generate random solvable state*/
    state3(InitialState), 
    getLength(InitialState,Length),
    printState(InitialState,Length,0),
    findSolution(InitialState, Solution),
    printSolution(Solution, Length, Length, 1).

%findSolution(State,Solution)
findSolution([FirstRow|T], Vars):-
    declareVars([FirstRow|T],Vars),
    length(FirstRow,FirstRowLength),
    applyRestrictions(Vars,FirstRowLength),
    labeling([], Vars).


%declareVars(-State,+Vars) Returns Vars ordered like State
declareVars([FirstRow|Tail],Vars):-
    write('\nDeclaring\n\n'),
    length(FirstRow,Length),
    flatten([FirstRow|Tail],Vars),
    MaxNum is 9*2^(Length-1),
    domain(Vars,1,MaxNum).

%applyRestrictions(-Vars,-FirstRowLength)
applyRestrictions(Vars, FirstRowLength):-
    sort(Vars,VarsDistinct),
    all_distinct(VarsDistinct),
    restrictFirstRow(Vars,FirstRowLength),
    restrictSum(Vars, FirstRowLength, 1),
    restrictMaxMinValue(Vars, FirstRowLength, 1, FirstRowLength).


%restrictFirstRow(-List, -Length)
restrictFirstRow(_,0).

restrictFirstRow([Head|Tail],Length) :-
    Head #< 10,
    Length1 is Length - 1,
    restrictFirstRow(Tail,Length1).


/* Fazer isto FirstRowLenght - 1 vezes */
    /* Fazer isto num vezes = LengthRow - 1 vezes */
        /* Index + LengthRow is Index + Index + 1  */

%restrictSum(-Vars,-RowLength, -Index) RowNum = RowLength
restrictSum(Vars, 1, _).


restrictSum(Vars, RowLength, Index):-
    restrictSumOnRow(Vars, RowLength, Index, 1),
    RowLength1 is RowLength - 1,
    Index1 is Index + RowLength,    /* Vou para o primeiro indice da proxima linha */
    restrictSum(Vars, RowLength1, Index1).




    

%restrictSumOnRow(-Vars, -RowLength, -Index, -N)
restrictSumOnRow(Vars, RowLength, _, RowLength).

restrictSumOnRow(Vars, RowLength, Index, N):-
    PosSummed1 is Index,
    nth_membro(PosSummed1,Vars,Summed1),
    PosSummed2 is Index + 1,
    nth_membro(PosSummed2,Vars,Summed2),
    PosRes is Index + RowLength,
    nth_membro(PosRes,Vars,Res),
    Res #= Summed1 + Summed2,
    Index1 is Index + 1,    /* Avancar para o proximo numero na linha */
    N1 is N + 1,
    restrictSumOnRow(Vars, RowLength, Index1, N1).



%restrictMaxMinValue(-Vars, -RowLength, -Index, -TotalHeight)
restrictMaxMinValue(Vars, 0, _, TotalHeight).

restrictMaxMinValue(Vars, RowLength, Index, TotalHeight):-
    restrictMaxMinValueOfRow(Vars, RowLength, Index, 1, TotalHeight),
    RowLength1 is RowLength - 1,
    Index1 is Index + RowLength,
    restrictMaxMinValue(Vars, RowLength1, Index1, TotalHeight).


%restrictMaxMinValueOfRow(-Vars, -RowLength, -Index, -N, -TotalHeight)
restrictMaxMinValueOfRow(Vars, RowLength, _, N, TotalHeight):- N is RowLength + 1.

restrictMaxMinValueOfRow(Vars, RowLength, Index, N, TotalHeight):-
    nth_membro(Index, Vars, Value),
    MaxNum is 9*2^(TotalHeight - RowLength) + 1,
    Value #< MaxNum,
    MinNum is 2^(TotalHeight - RowLength) - 1,
    Value #> MinNum,
    Index1 is Index + 1,
    N1 is N + 1,
    restrictMaxMinValueOfRow(Vars, RowLength, Index1, N1, TotalHeight).


/* Restricoes de geração de problema a ser implementadas */

/*

1. 1ºa Linha minimo de 2 celulas e máximo grande
2. Em cada divisão de triangulos possivel o vertice inferior do triangulo nao pode ter a cor de nenhuma celula do triangulo
3. 

*/

