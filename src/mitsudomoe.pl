:- consult('display.pl').
:- consult('gameLogic.pl').
:- use_module(library(system)).

mitsudomoe :-
    write('Begin Game'),
    nl,
    gameStart.