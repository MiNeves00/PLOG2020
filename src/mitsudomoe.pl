:- consult('display.pl').
:- consult('gameLogic.pl').
:- consult('menu.pl').
:- consult('utils.pl').
:- use_module(library(system)).

/**Play (main)*/
%play
play :-
    write('Begin Game'),
    nl,
    menu.