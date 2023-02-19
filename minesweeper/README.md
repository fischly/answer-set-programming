# Minesweeper
ASP solver for the classical game of [minesweeper](https://en.wikipedia.org/wiki/Minesweeper_(video_game)).


## Usage

As input, the solver expects facts as follow:

- **width(W)**: the width of the playing field.
- **height(H)**: the height of the playing field.
- **numberOfBombs(NB)**: the total number of bombs.

- **number(X, Y, N)** for every number N with coordinates (X, Y) on the field.
- **bomb(X, Y)** for every bomb at position (X, Y).

Results in **open(X, Y)** atoms, which stand for cells that can safely be opened in the current answer set.

Multiple answer sets get generated for scenarios of uncertainty.
Consider the following 2x2 minesweeper field, where only the cell (1, 1) is known:
```
+---+
|1  |
|   |
+---+
```

In this case, **three answer sets** would be generated, placing the bomb at (1, 2), (2, 1) or (2, 2), respectively.

**Note**
  > For performance reasons, the solver considers only cells that are neighbouring at least one known number.
  Otherwhise, due to exponential complexity, grounding and search would quickly become infeasible for somewhat bigger fields.

**Note**
> To fully play a game of minesweeper, the solver would have to be called iteratively. After each call, the answer sets can be evaluated to find the move that is most likely to be safe. Then, one could apply this move and call the solver again with the updated facts.
