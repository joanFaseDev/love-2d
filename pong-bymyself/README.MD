# Pong by myself

I did this project to review what was done during the free CS50's course 'Introduction to Game development'. The goal was to test what i learned, what i could reproduce from memory and what i need to review. As i feared, my biggest problem is related to velocity. Calculating movement is something i always had trouble with but i feel it's slowly starting to make sense. The AABB algorithm is really useful and quite worth learning, i almost reproduce it from memory. Not quite yet though. Overall i think i did ok, i'm feeling confident enough to continue the CS50's course.

## To do

## Done
- Add some text in the middle of the screen saying 'Welcome to Pong!' then 'Press ENTER to serve!'
- Add font assets and load them into love2d
- Add a library to create a non resizable play screen ('push' depo)
- Load 'classic' lib to generate Class
- Create a Paddle class for players with fields (x, y, width, height, mode, speed)
- Create a Ball class with fields (x, y, with, height, mode, speed)
- Load two instances of Paddle and one of Ball
- Render the three instances into the game (Player1 to the left, Player 2 to the right and Ball to the center)
- Set the background color to a shade of gray and clear the screen every frame
- Add input for player's movements
- Add velocity to player class and use it to calculate new position every frame
- Add move method to player class
- Add gamestate variable
- Add gamestate 'start', 'serve' and 'play'
- Change the game's center text according to the state the game is actually in
- Press Enter in 'serve' state send the ball to the right side (player 1 always serve first) and change the state for 'play'
- Players can only move in 'play' state
- Set Players score to zero by default 
- Handle collisions between players and ball
- Handle collisions between ball and top/down side
- Increment the score each time a player send the ball past its opponent
- Create functions to reset players and ball position
- Change game state each time a player score
- Give the serv to the opponent of the last player who have scored
- Add a victory state
- Add a victory message 
- Switch to victory once one of the players reach 10 points
- Reinitialize points once a new set begins
- Add audio and juice!
