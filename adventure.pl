:- dynamic here/1.
:- dynamic have/1.
:- dynamic location/2.
:- dynamic turned_off/1.
:- dynamic turned_on/1.

here(kitchen).

room(kitchen).
room(office).
room(hall).
room('dining room').
room(cellar).

door(office, hall).
door(kitchen, office).
door(hall, 'dining room').
door(kitchen, cellar).
door('dining room', kitchen).

location(desk, office).
location(apple, kitchen).
location(flashlight, desk).
location('washing machine', cellar).
location(nani, 'washing machine').
location(broccoli, kitchen).
location(crackers, kitchen).
location(computer, office).

location(envelope, desk).
location(stamp, envelope).
location(key, envelope).

edible(apple).
edible(crackers).

tastes_yucky(broccoli).

turned_off(flashlight).

where_food(X, Y) :-
    location(X, Y),
    edible(X).

where_food(X, Y) :-
    location(X, Y),
    tastes_yucky(X).
    
connect(X,Y) :- door(X,Y).
connect(X,Y) :- door(Y,X).

list_things(Place) :-
    location(X, Place),
    tab(4),
    write(X),
    nl,
    fail.
list_things(_).

list_connections(Place) :-
    connect(Place, X),
    tab(4),
    write(X),
    nl,
    fail.
list_connections(_).

look :-
    here(Place),
    write('You are in the '), write(Place), nl,
    write('You can see:'), nl,
    list_things(Place),
    write('You can go to:'), nl,
    list_connections(Place).
    
goto(Place) :-
    can_go(Place),
    move(Place),
    look,
    !.
    
can_go(Place) :-
    here(X),
    connect(X, Place).
can_go(_) :-
    write('You can''t get there from here.'), nl,
    fail.
    
move(Place) :-
    retract(here(_)),
    asserta(here(Place)).
    
take(X) :-
    can_take(X),
    take_object(X),
    !.

can_take(Thing) :-
    here(Place),
    is_contained_in(Thing, Place).
can_take(Thing) :-
    write('There is no '), write(Thing) , write(' here'), nl,
    fail.
    
take_object(X) :-
    retract(location(X,_)),
    asserta(have(X)),
    write('Taken'), nl.
    
put(X) :-
    have(X),
    retract(have(X)),
    here(Place),
    asserta(location(X, Place)).
put(_) :-
    write('You don''t have that object'), nl,
    fail.

inventory :-
    write('You are carrying:'), nl,
    list_inventory.
    
list_inventory :-
    have(Thing),
    tab(4),
    write(Thing),
    nl,
    fail.

turn_on(Thing) :-
    retract(turned_off(Thing)),
    asserta(turned_on(Thing)).
turn_on(_) :-
    write('It''s already on.').
    
turn_off(Thing) :-
    retract(turned_on(Thing)),
    asserta(turned_off(Thing)).
turn_off(_) :-
    write('It''s already off.').
    
is_contained_in(T1, T2) :-
    location(T1, T2).
is_contained_in(T1, T2) :-
    location(X, T2),
    is_contained_in(T1, X).
    

    
    