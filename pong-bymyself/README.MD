# Pong by myself

## To do
- Add gamestate 'start', 'serve' and 'play'
- Change the game's center text according to the state the game is actually in
- Press Enter in 'serve' state send the ball to the right side (player 1 always serve first) and change the state for 'play'
- Players can only move in 'play' state
- Set Players score to zero by default 

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
