:- dynamic(colour/2).
:-consult('utils.pl').
:-consult('display.pl').
:-consult('generate.pl').
:- use_module(library(clpfd)).
:- use_module(library(system)).
:- use_module(library(lists)).
:- use_module(library(random)).


grape:-
    write('Generating a random problem to solve\n'),
    write('>>> Insert number of rows: '),
    read(Input),
    handleInput(Input),
    write('\nGenerating With Values\n\n'),
    generateFirstRow(Input, FirstRow),
    completeBoard(FirstRow, Input, Board, [FirstRow | T]),
    printGeneratedBoard([FirstRow | T], Input, 0),
    makeNumbersSameColour([FirstRow | T], ListOfPairs),
    write('\nPairs\n\n'),
    printRow(ListOfPairs),
    write('\nGenerating Without Values\n\n'),
    generateBoard([FirstRow | T], Input, [], GeneratedBoard),
    printState(GeneratedBoard, Input, 0),
    write('\nAssigning Colours\n\n'),
    length(ListOfPairs, PairLen),
    flatten(GeneratedBoard, FlatBoard),
    assignColoursToBoard(FlatBoard, ListOfPairs, PairLen),
    printStateList(FlatBoard, Input, Input, 1),
    write('\nSolution for Generated Problem\n\n'),
    findSolution(FlatBoard, Input, Solution),
    %testStats(FlatBoard, Input).
    printSolution(Solution, Input, Input, 1).



%findSolution(+Vars, +Length, -Solution)
findSolution(Vars, Length, Vars):-
    declareVars(Vars, Length),
    applyRestrictions(Vars,Length),
    labeling([], Vars).


%declareVars(+Vars, +Lenght) Returns Vars ordered like State
declareVars(Vars, Length):-
    MaxNum is (9*2^(Length-1)),
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

handleInput(Input):-
    Input > 0.

handleInput(_SomeOther):-
    write('Input incorrect please insert your option again: '),
    read(Input),
    handleInput(Input).
