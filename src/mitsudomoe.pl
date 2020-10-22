:- consult('display.pl').
:- consult('gameLogic.pl').
:- consult('menu.pl').
:- use_module(library(system)).

mitsudomoe :-
    write('Begin Game'),
    nl,
    menu.