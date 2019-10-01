-- 20029947 scyzz2 Zewei Zhou
module Schelling
  ( Coord
  , AgentType (..)
  , Cell

  , step
  ) where

import System.Random

-- type-definition of a coordinate in our world
type Coord = (Int, Int)

-- data definition for the agent types
data AgentType 
  = Red       -- ^ Red agent
  | Green     -- ^ Green agent
  | Blue      -- ^ Blue agent
  deriving (Eq, Show) -- Needed to compare for equality, otherwise would need to implement by ourself

-- Type-definition of a Cell: it is just a coordinate and an optional AgentType.
-- Note: the agent type is optional and is Nothing in case the cell is empty.
type Cell = (Coord, Maybe AgentType)

-- Computes one step of the Schelling Segregation model. The algorithm works as:
step :: [Cell]           -- ^ All cells of the world
     -> StdGen           -- ^ The random-number generator
     -> Double           -- ^ The ratio of equal neighbours an agent requires to be happy
     -> ([Cell], StdGen) -- ^ Result is the new list of cells and the updated random-number generator
step cs g _ratio = (cs', g') 
  where
    emptyList = filter isEmpty cs -- find all empty cells in the cs(world)
    agents = filter (not . isEmpty) cs -- find all agents(not empty) in the cs (world)
    happyList = filter (isHappy _ratio cs) agents  -- find all happy agents in 'agents'
    unhappyList = filter (not . isHappy _ratio cs) agents -- find all unhappy agents in 'agents'
    (unhappyList', emptyList', g') = foldr moveCell ([], emptyList, g) unhappyList -- move all unhappy agents to a random empty cell and updates empty list
    cs' = happyList ++ unhappyList'++ emptyList'  -- create a new list of cells for the result

    -- move an unhappy agent to an empty cell and return the new unhappy list, new empty list and random generator as well
    moveCell :: Cell -> ([Cell], [Cell], StdGen) -> ([Cell], [Cell], StdGen)
    moveCell anUnhappyCell (acc, emptyCells, _g) = ((newUnhappyCell:acc), anewEmptyCells, _g')
      where
        (r, _g') = randomR (0, (length emptyList) - 1) _g -- to generate a random number between 0 and n-1
        anEmptyCell = emptyCells !! r -- to randomly choose an empty cell
        newUnhappyCell = (fst(anEmptyCell), snd(anUnhappyCell)) -- swap the content of two cells
        anewEmptyCells = updateList anUnhappyCell anEmptyCell emptyCells -- update the empty list
      
        -- update the list of empty cells
        updateList :: Cell -> Cell -> [Cell] -> [Cell]
        updateList _ _ [] = [] -- base case
        updateList x c (y:ys)
          | fst(c) == fst(y) = (fst(x), Nothing):ys -- if c and y have the same coordinate then add the x with Nothing into ys
          | otherwise = y:(updateList x c ys)

-- get a cell surrounding cells' coordinates
surndCellCoor :: Cell -> [Coord]
surndCellCoor ((x, y), _) = [(x+1, y), (x+1, y+1), (x+1, y-1), (x, y+1), (x, y-1), (x-1, y), (x-1, y+1), (x-1, y-1)]

-- receive a list of coordinates and get the surrounding cells in cs(world)
getCell :: [Coord] -> [Cell] -> [Cell]
getCell [] _cs = [] -- base case
getCell (x:xs) _cs -- use pattern mathcing to check what agent type the cell is
  | (x, Just Red) `elem` _cs = (x, Just Red):(getCell xs _cs)
  | (x, Just Blue) `elem` _cs = (x, Just Blue):(getCell xs _cs)
  | (x, Just Green) `elem` _cs = (x, Just Green):(getCell xs _cs)
  | (x, Nothing) `elem` _cs = (x, Nothing):(getCell xs _cs)
  | otherwise = getCell xs _cs

-- count how many agents are in the same color
sameType :: Cell -> [Cell] -> Int 
sameType _x [] = 0 -- base case
sameType (_x, t) ((_y, t'):ys)
  | t == t' = 1 + sameType (_x, t) ys -- increase the number of agents with the same color(type)
  | otherwise = sameType(_x, t) ys

-- check if a cell is happy
isHappy :: Double -> [Cell] -> Cell -> Bool
isHappy ratio cs aCell 
  | (realToFrac(sameType aCell surndCells) / realToFrac(length surndCells)) >= ratio = True -- get the actual ratio and compare it with expected ratio
  | otherwise = False
    where
      xs = surndCellCoor aCell
      surndCells = getCell xs cs

-- check if a cell is an empty(Nothing) cell
isEmpty :: Cell -> Bool
isEmpty aCell
  | snd(aCell) == Nothing = True
  | otherwise = False


