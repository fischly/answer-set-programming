
#const ceil=200.

fib(1, 1). % first fibonacci number is 1
fib(2, 1). % second fibonacci number is 1

% Tth fibonacci number is the sum of the two previous fibonacci numbers
fib(T, X) :- fib(T - 1, X1), fib(T - 2, X2), X = X1 + X2, X < ceil.

% output formatting
fib(X) :- fib(_, X).
#show fib/1.
