#const moves = 11.      % number of moves allowed (works as an upper bound)
#const capacity = 2.    % raft capacity per trip

#const num_dinos = 3.
#const num_santas = 3.

% initial and goal states
on_initial(num_dinos, num_santas, 0).   % start with num_dinos and num_santas on the left river side
on_goal(0, 0).                          % the goal is to have noone at the left river side (= all tranfered to the right side)

% generate all solutions, containing all possible moves
%    - do not allow empty trips (raft needs to be navigated)
%    - do not allow trips where the rafts capacity is exceeded
1 { move(D, S, T) : D=0..capacity, S=0..capacity, D + S <= capacity, D + S > 0 } 1 :- T = 1..moves.

% predicate on/2 describes a state
%    - the 1st variable (D) represents the number of dinos on the left side of the river
%    - the 2nd variable (S) represents the number of santas on the left side of the river
%    - the 3rd variable (R) represents the side the raft is currently on (0: left, 1: right).
%    - the 4th variable (T) represents the current time step

% at time step 0, we use the given initial state
on(D, S, R, 0) :- on_initial(D, S, R).

% generate each further time step T + 1, if we do not exceed the given move bound (T < moves):
%   if the raft is on the left side (R == 0), we substract the transported dinos/santas, because they leave the left river side.
on(D - MV_D, S - MV_S, 1 - R, T + 1) :- R == 0, on(D, S, R, T), move(MV_D, MV_S, T + 1), T < moves.
%   if the raft is on the right side (R == 1), we add the transported dinos/santas, because they arrive at the left river side.
on(D + MV_D, S + MV_S, 1 - R, T + 1) :- R == 1, on(D, S, R, T), move(MV_D, MV_S, T + 1), T < moves.

% calculate how many dinosaurs and santas are on the side, where the raft currently is
current(D, S, T)         :- R == 0, on(D, S, R, T).   % R == 0 -> raft is on left side, so just take the counts from on/4.
current(3 - D, 3 - S, T) :- R == 1, on(D, S, R, T).   % R == 1 -> raft is on right side, so calculate the counts accordingly

% only allow moves, if the raft transports exactly as many or less dinos/santas as are standing on the river side the raft is on
% (otherwhise we would generate dinos/santas out of thin air)
:- current(D, _, T), move(DM, _, T + 1), DM > D.
:- current(_, S, T), move(_, SM, T + 1), SM > S.

% remove all solutions where santas would get eaten
:- on(D, S, _, T), D > S, S > 0.                            % left side
:- on(D, S, _, T), DR = 3 - D, SR = 3 - S, DR > SR, SR > 0. % right side

% goal clause: remove every answer set, where the goal is not reached at the move upper bound
:- on_goal(D, S), not on(D, S, _, moves).

#show on/4.
% #show current/3.
% #show move/3.