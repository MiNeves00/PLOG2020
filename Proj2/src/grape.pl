:-consult('utils.pl').
:-consult('display.pl').
:- use_module(library(clpfd)).
:- use_module(library(system)).
:- use_module(library(lists)).





grape:-
    /*generate random solvable state*/
    state(InitialState), 
    printState(InitialState),
    getLength(InitialState,Length),
    printState(InitialState,Length,0),
    findSolution(InitialState, Solution).
    printState(Solution).

%findSolution(State,Solution)
findSolution([FirstRow|T], Solution):-
    declareVars([FirstRow|T],Vars),
    length(FirstRow,FirstRowLength),
    applyRestrictions(Vars,FirstRowLength).


%declareVars(-State,+Vars) Returns Vars ordered like State
declareVars([FirstRow|Tail],Vars):-
    write('\nDeclaring\n'),
    length(FirstRow,Length),
    flatten([FirstRow|Tail],Vars),
    MaxNum is 9*2^(Length-1),
    domain(Vars,1,MaxNum).

%applyRestrictions(-Vars,-FirstRowLength).
applyRestrictions(Vars, FirstRowLength):-
    sort(Vars,VarsDistinct),
    all_distinct(VarsDistinct),
    restrictFirstRow(Vars,FirstRowLength),
    restrictSum(Vars, FirstRowLength, 1).


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
    write(PosRes),
    write('\n'),
    nth_membro(PosRes,Vars,Res),
    Res #= Summed1 + Summed2,
    Index1 is Index + 1,    /* Avancar para o proximo numero na linha */
    N1 is N + 1,
    restrictSumOnRow(Vars, RowLength, Index1, N1).







