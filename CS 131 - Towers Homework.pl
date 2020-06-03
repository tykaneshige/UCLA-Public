/*
 * Score: 99/100 (Lost 1% because this assignment was turned in a day late.)
 * 
 * The overall goal of this project was to create a program that can both create and solve
 * a 'tower' puzzle. The puzzle is best understood by playing it, but in short it has some
 * very similar characteristics to sodoku. The functions implemented are described below.
 * 
 * Some Terminology
 *   N: Grid size. All towers boards are square in dimension, so N specifies the length of
 *      one side. The board size then would be N x N.
 *   T: Towers Puzzle (Empty or Complete): This is the towers puzzle itself. In the link
 *      below, this would be the part of the puzzle where the user would place their towers 
 *      to complete the puzzle. This is represented by a list of lists, or a 2D array.
 *   C: Counts (Empty or Complete): This is the number of towers seen from a given side. In
 *      the link below, this would the set of numbers that are on the outside of the puzzle,
 *      indicating the number of towers seen from that particular position. This is represented
 *      by a 4 x N array, where N is the grid size. The first row corresponds to the numbers
 *      at the top of the puzzle, the second row corresponds to the bottom, the third corresponds
 *      to the right, and the fourth row corresponds to the left.
 *
 * tower(N, T, C)
 *   This function takes a grid size (N), a towers puzzle (T), a corresponding count (C). 
 *   This function then either either finds a count C for the towers puzzle T, or creates
 *   a towers puzzle T from a count C. In essence, it should be able to work forward and
 *   and backward. In addition, this function should be able to anything in-between those
 *   two cases, meaning that if given a partial tower T and a partial count C, the function
 *   should complete both T and C. This implementation uses G-Prolog's finite domain solver
 *   to find a solution. 
 *   
 *   In terms of performance, it should easily calculate the count of each row and column 
 *   for any puzzle where N < 20. If calculating a puzzle from a given count C, it should
 *   reasonably come up with a solution for any puzzle where N < 15.
 *
 * plain_tower(N, T, C)
 *   This function performs the same job as tower/3, but it does so without using G-Prolog's
 *   finite domain solver. This obivously means that there is a dip in performance for larger
 *   tower puzzles, especially when calculating a puzzle solution T from a counts C. However,
 *   this implementation should reliably solve counts C for any puzzle T where N < 15. But if
 *   creating a puzzle T from a counts C, it only performs reasonbly well when N < 6.
 *
 * Link to the puzzle:
 *  https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/towers.html
 *
 */

% --- Code provided by the CS 131 TA hint page --- %

% Verifies the length of the rows and columns of the grid are correct
len_row(L, N) :- 
    length(L, N).

len_col([], _).
len_col([HD | TL], N) :- 
    length(HD, N),
    len_col(TL, N).

% Verifies that all entrues in the list are within a given domain
within_fd_domain([], _).
within_fd_domain([HD | TL], N) :-
    fd_domain(HD, 1, N),
    within_fd_domain(TL, N).

within_domain(N, Domain) :- 
    findall(X, between(1, N, X), Domain).

% Transposes the matrix
transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).
transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
    lists_firsts_rests(Ms, Ts, Ms1),
    transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
    lists_firsts_rests(Rest, Fs, Oss).

% --- tower Implementation --- %

tower(N, T, C) :-
    len_row(T, N),
    len_col(T, N),
    within_fd_domain(T, N),
    maplist(fd_all_different, T),
    transpose(T, Tt),
    maplist(fd_all_different, Tt),
    maplist(fd_labeling, T),
    count(T, LC),
    rev_all(T, RT),
    count(RT, RC),
    count(Tt, TC),
    rev_all(Tt, BTt),
    count(BTt, BC),
    C = counts(TC, BC, LC, RC).

% Recursively reverses each row of the grid
rev_all([], R) :-
    R = [].
rev_all([HD | TL], R) :-
    reverse(HD, R1),
    rev_all(TL, R2),
    append([R1], R2, R).

% Recursively counts the number of visible towers in a given row
count([], R) :-
    R = [].
count([HD | TL], R) :-
    count_towers(HD, 0, X),
    count(TL, Y),
    append([X], Y, R).

count_towers([], _, R) :-
    R = 0.
count_towers([HD | TL], M1, R) :-
    check_height(HD, M1, M2, C1), 
    count_towers(TL, M2, C2),
    R is C1 + C2.

check_height(T, MI, MO, R) :-
    T > MI, 
    R = 1,
    MO = T.
check_height(T, MI, MO, R) :-
    T < MI,
    R = 0,
    MO = MI.

% --- plain_tower Implementation --- %

plain_tower(N, T, C) :-
    within_domain(N, D),
    len_row(T, N),
    len_col(T, N),
    C = counts(TC, BC, LC, RC),
    fill(T, LC, RC, D),
    transpose(T, Tt),
    fill(Tt, TC, BC, D).

% Creates a permutation from a range of valid values
% Verifies that the number of visble towers matches the entry in counts C1
% Recursively fills the board until a valid solution is found
fill([], [], [], _).
fill([THD| TTL], [C1HD | C1TL], [C2HD | C2TL], Domain) :-
    permutation(Domain, THD),
    count_towers(THD, 0, C1HD),
    reverse(THD, THDt),
    count_towers(THDt, 0, C2HD),
    fill(TTL, C1TL, C2TL, Domain).