:- dynamic selected/1. :- dynamic selected/0.
:- dynamic counter/1. :- dynamic counter/0.
:- dynamic already_played/1. :- dynamic already_played/0.

% -------------------------------------------------- %
%            Functions used by the user:             %
% -------------------------------------------------- %

play() :-					/* Game starts here, by typing play. in the console. */
	sports(L),				/* Loads the list containing all the possible sports */
	set_game_variables(L),	/* This function sets game variables, like what to guess for and the counter. The function can be found at line 120. */
	print('Game started!'), nl,
	guess().


guess() :-				/* guess() is the main function of the game, where the input is handled  */
	check_counter(),	/* This function checks if the counter still is < 10 */
	read(Input),		/* Read input from user, then run the command they entered */
	Input;

	game_over().		/* If check_counter() fails, the game is over */


has(Guess) :-				/* This is where we end up when the user writes has(X). */
	selected(Sport),		/* Load the current item they are asking about */
	get_list(Sport, L),	/* Gets the list of facts that the current item has */
	member(Guess, L),		/* Checks whether or not their guess is in the list of items. */
	print('Yes.'), nl,		/* If their guess was in the list, then prints Yes. */
	increment(),			/* This increments the counter by 1 */
	guess();

	concat_all_facts(FullList),	 /* Get all available options */
	member(Guess, FullList), /* See if the guess is a valid one */
	print('No.'), nl,
	increment(),			 /* This increments the counter by 1 */
	guess();

	print('Invalid option'),nl, /* If Guess was not in the FullList, print invalid option */
	guess().


is(Guess) :-				/* If the user wants to guess for the answer, they end up here. This function just checks if their Guess is equal to what we have in selected. */
	selected(X),			/* Load the current sport into X */
	X==Guess,				/* Compare X to Guess */
	print('Yes, it was '),
	print(Guess), nl,
	game_over();

	print('No, it is not '), /* If Guess was not equal to X, Guess was wrong */
	print(Guess), nl,
	increment(),
	guess().

all_options() :-
	concat_all_facts(FullList),	/* Get all options */
	list_to_set(FullList, S),		/* Remove duplicates */
	print('All possible options: '), nl,
	print(S), nl,					/* Print all options */
	guess().

% ------------------------------------------------------------ %
%                 Functions used by the program:               %
% ------------------------------------------------------------ %

game_over() :- /* The game_over function is called when, for some reason, the game ends. It just asks whether or not the user wants to play another game or not. */
	print('Play again? (y/n)'),
	read(Input),
	restart_game(Input).


restart_game(X) :- /* If their answer in game_over was y, then call play. If their answer was n, abort. If none, call game_over again for correct input */
	(X==y, play());
	(X==n, abort);
	game_over().


get_list(X, L) :- /* get_list is a function that matches the input from the user to the corresponding list of facts */
	(X==tennis, tennis(L));
	(X==diving, diving(L));
	(X==football, football(L));
	(X==swimming, swimming(L));
	(X==badminton, badminton(L));
	(X==boxing, boxing(L));
	(X==golf, golf(L));
	(X==basketball, basketball(L)).


increment() :-
	counter(X),			/* Gets the current value of counter */
	Y is (X+1),			/* Gives Y the value X+1 */
	retractall(counter(_)),	/* Remove the current value of counter */
	assertz(counter(Y)).	/* Assert the new, incremented value */


check_counter() :-						/* This function checks if the counter is less than 10 */
	counter(X),
	(X<10);

	print('You ran out of guesses'), nl, /* If the counter higher than 10, then print out the answer and call game_over() */
	print('The answer was '),
	selected(X),
	print(X), nl,
	game_over().


set_game_variables(List) :-						/* This function finds the remaining valid items in a given list. An item is Valid if it has not been chosen before */
	findnsols(100, X, already_played(X), Played),	/* Find all X's from already_played(X) and put them in the list Played */
	subtract(List, Played, Valid),					/* Subtract Played from the given List. The result is stored in Valid */
	Valid\==[],									/* If the Valid list is empty, the player has correctly guessed all the sports */
	random_member(Sport, Valid),					/* Choose a random member from the Valid list */
	assert(already_played(Sport)),					/* Add the sport to already_played */
	retractall(selected(_)),
	assertz(selected(Sport)),						/* assert the random element into selected, so we can keep track of what the user is guessing for */
	retractall(counter(_)),							/* Reset the counter to 0 */
	assertz(counter(0));

	print('You guessed all the sports, well done!'), nl,
	abort.


concat_all_facts(L) :- /* Takes a parameter list L and fills it with the facts about all sports */
	tennis(L1),	   /* Store all facts about each sport in L1..L8 */
	diving(L2),
	football(L3),
	swimming(L4),
	badminton(L5),
	boxing(L6),
	golf(L7),
	basketball(L8),
	append(L1, L2, Quart1List), /* Append these lists into even bigger lists. QuartxList now contains the elements from two sports */
	append(L3, L4, Quart2List),
	append(L5, L6, Quart3List),
	append(L7, L8, Quart4List),
	append(Quart1List, Quart2List, Half1List),	/* Do it again with the Quartxlists. HalfxList now contains the elements from four sports */
	append(Quart3List, Quart4List, Half2List),
	append(Half1List, Half2List, L).			/* Append the two halves together into the given parameter L */
% ----------------------------------------------- %
%                      Facts                      %
% ----------------------------------------------- %

sports([tennis, diving, football, swimming, badminton, boxing, golf, basketball]).

tennis([court, score, ball, racket, referee, doubles, singles, net, serve, baseline, ballgirl, ballboy, grass, clay, teams_per_game=2]).
diving([water, pool, score, judges, swimsuit, swimcap, teamsize=1, teams_per_game=many]).
football([pitch, penalty, ball, score, captain, referee, manager, grass,  teamsize=11, teams_per_game=2]).
swimming([water, pool, timed, referee, swimsuit, goggles, lane, swimcap, teamsize=1, teams_per_game=many]).
badminton([court, racket, referee, shuttlecock, doubles, singles, teams_per_game=2]).
boxing([ring, gloves, timed, referee, score, knockout, teamsize=1, teams_per_game=2]).
golf([ball, course, grass, water, sand, caddy, holes, bag, fairway, clubs, score, teamsize=1, teams_per_game=many]).
basketball([court, ball, referee, basket, scoreline, score, teamsize=5, teams_per_game=2]).

already_played().	/* Keeps track of which sports have already been guessed */
selected(empty).	/* Keeps track of current sport to guess for */
counter(0).		/* Keeps track of how many questions the player has asked */
