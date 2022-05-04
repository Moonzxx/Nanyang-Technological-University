
/*

---------------- Game Functions -------------------------------

Initliase game variable
Asserts all dynamic facts iof the program

List = all the sports available in the game
Played:  All the sports that were already played
RemainingSports: A list of sports that player has not guessed correctly*/	
init_var(List) :-
	findnsols(100, A, already_played(A), Played),
	subtract(List, Played, RemainingSports),
	RemainingSports\==[],
	random_member(Sport, RemainingSports),
	assert(already_played(Sport)),
	retractall(gameselection(_)),
	assertz(gameselection(Sport)),
	retractall(counter(_)),
	assertz(counter(0));
	
	print('You guessed all the sports!'), nl,
	abort.
	
/* Put all facts of a given sport A into List B*/
retrieve_list(A, B) :-
	(A == football, football(B));
	(A == badminton, badminton(B));
	(A == tennis, tennis(B));
	(A == volleyball, volleyball(B));
	(A == karate, karate(B));
	(A == swimming, swimming(B));
	(A == diving, diving(B));
	(A == golf, golf(B)).
	
/*Keeping track that player can only ask 10 questions*/
check_counter() :-
	counter(A),
	(A < 10);
	
	nl,
	print('No more guessing! Reached maximum 10 questions!'), nl,
	print('The answer is '),
	gameselection(A),
	print(A), nl, nl,
	game_over().

/*Increase the value in counter*/
increment() :-
	counter(A),
	B is (A+1),
	retractall(counter(_)),
	assertz(counter(B)).

/*To put all sport facts into a single list using the append fucntion*/
concat_all_facts(L) :-
	football(LLL1),
	badminton(LLL2),
	tennis(LLL3),
	volleyball(LLL4),
	karate(LLL5),
	swimming(LLL6),
	diving(LLL7),
	golf(LLL8),
	append(LLL1,LLL2, LL1),
	append(LLL3,LLL4, LL2),
	append(LLL5,LLL6, LL3),
	append(LLL7,LLL8, LL4),
	append(LL1,LL2,L1 ),
	append(LL3,LL4, L2),
	append(L1,L2, L).

/* 
Printing of all facts that are available to be quieried
Ensure that the set creates has no duplicates
Invoked when game starts*/
all_options() :-
	concat_all_facts(TotalList),
	list_to_set(TotalList, S),
	print('All possible options: '), nl,
	print(S), nl, nl,
	print('Player can start guessing: '), nl,
	guess_game().

/*Game ends. It will ask the player if they would like to play a game again.*/
game_over() :-
	print('Would you like to play again? (y/n)'), read(Input), restart_game(Input).

/*Based on input in game_over function to restart the game*/
restart_game(A) :-
	(A==y, start_game());
	(A==n, abort);
	game_over().
	

	
	
	
	
	
start_game() :-
	sports(List),
	init_var(List), nl,
	print('Game has started!'), nl, nl,
	all_options(), nl,
	guess_game().
	
/* The user will submit queries at this portion of the code*/
guess_game() :-
	check_counter(),
	read(Input),
	Input;
	
	game_over().
	
/*A query that answers if if the current sport selected by game has that certain fact(characteristic)
Loads the selected sport
Retrieve list of facts about that sport and check with user's guess*/
has(Guess) :-
	gameselection(Sport),
	retrieve_list(Sport, List),
	member(Guess, List),
	print('Yes.'), nl,
	increment(),
	guess_game();
	
	concat_all_facts(TotalList),
	member(Guess, TotalList),
	print('No.'), nl,
	increment(),
	guess_game();
	
	print('Invalid option'),nl,
	guess_game().
	
/* A query that checks if the player makes a correct guess
Loads selected sport
Compare user's guess and selected sport*/
is(Guess) :-
	gameselection(A),
	A==Guess,
	print('Yes it was '),
	print(Guess), nl, nl,
	game_over();
	
	print('No, it is not '),
	print(Guess), nl,
	increment(),
	guess_game().



/*---------------------------- Game Facts -----------------------------------------*/


sports([football, badminton, tennis, volleyball, karate, swimming, diving, golf]).

/* Sports available: football, badminton, tennis, volleyball, karate, swimming,diving, golf*/
football([ball, penalty, captain, referee, score, grass, pitch, teamsize=11, teams_per_game=2]).
badminton([racket, shuttlecock, referee, court, doubles, singles, teams_per_game=2]).
tennis([court, ball, racket, net, serve, doubles, singles, baseline, teams_per_game=2]).
volleyball([ball, sand, net, poles, empire, score, teamsize=6]).
karate([belts, uniform, judges, headgear, mouthguard, dojo, score]).
swimming([pool, referee, googles, water, lane, swimsuit, teamsize=1, teams_per_game=many]).
diving([water, pool, judges, swimsuit, googles, teamsize=1, teams_per_game= many]).
golf([ball, caddy, holes, clubs, score, course, grass, teamsize=1, teams_per_game=many]).

/* Make everything available to dynamic, so dont have to activate manually */
gameselection(empty).  /*Keep track of current sport guessing for*/
already_played().   /*Keep track of whic sports have already been played*/
counter(0).   /*Counter for no. of questions the player has asked for the current game*/

:- dynamic gameselection/1.	:- dynamic gameselection/0.
:- dynamic counter/1.	:- dynamic counter/0.
:- dynamic already_played/1.	:- dynamic already_played/0.
