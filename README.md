# Schelling-Segregation
Haskell Coursework

Task

The task you have to do in the coursework is to implement the core algorithm of the Schelling Segregation as described above. To successfully ﬁnish this task you need to combine all the things you learned in lectures 1-8 and do a little research on your own (see below). The amount of code you have to write should be average - my working solution has about 80 lines of code including a lot of break-lines. There is already code provided for you, which performs the rendering and creating of the initial world, which is all implemented in ’src/Main.hs’. You need to implement the missing functions in ’src/Schelling.hs’ for a working solution - this is also the only ﬁle you will submit.

Core Algorithm

Open ’src/Schelling.hs’ and search for the ’step’ function (line 30). This function will be called for you from the Main module to compute the next step with all arguments provided for you. Read the comments, which describe the function and its arguments, and implement it. Follow these steps as a guide:

1. Filter all agents which are unhappy. Write a function, which decides if an agent is happy. For this you need to deﬁne the neighbourhood and ﬁlter out the neighbouring cells.

2. Move each unhappy agent to a new empty cell. Be careful: only one agent can occupy a cell. Therefore when you move an agent to an empt cell, no other agent can be placed on this cell because it is occupied now. Think carefully about which higher-order function from the Standard Prelude you want to use for this. Also you might need the following functions:

(a) Write a function which ﬁnds a random empty cell.

(b) Write a function which swaps the contents of two cells.

This should give you enough guidance to solve the task.

The Main module has error-checking implemented, which checks whether the number of cells and agents stays constant or not. If your program exists with an error, read the message carefully and ﬁgure out what the problem is - you might add / remove cells or agents during this step which is not allowed.

If you want to see how a diﬀerent happiness factor inﬂuences the dynamics, feel free to change it: open ’src/Main.hs’ and look for the declaration of satisfactionRatio :: Double (line 29-30) and change it to another value between 0.0 and 1.0. Also you can vary the number of agents by changing agentCount :: Int (line 38-39).
