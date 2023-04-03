# About this project
Source code for this project can be found here: https://github.com/games50/pong
This project is based on a lecture from CS50's introduction to Game Development (2018) animated by Colton Ogden.
Goals for this particular lecture are listed in **Lecture's scope**

## About love2d

* love2d will run main.lua, any other files within the directory can be referenced from main.lua
* **love.load** can be overrided and is called once at the beginning of the game
* **love.update** can be overrided and is called every frame. love2d passed in it a dt variable representing the elapsed time in seconds since the last frame
* **love.draw** can be overrided and is also called every frame but after **love.update**. Render things on screen once they have changed.
* **delta time (dt)** is used to scale any change in the game for even behavior across frame rates

* **love.keypressed** callback function triggered when a key is pressed
* **require** opens and executes lua modules

## Lecture's scope

* Draw shapes to the screen (paddles and ball)
* Control 2D position of paddles based on input
* Collision detection between paddles and ball to deflect ball back toward opponent
* Collision detection between ball and map boudaries to keep ball within vertical bounds and to detect score (outside horizontal bounds)
* Sound effects when ball hits paddles/walls or when a point is scored for flavor
* Scorekeeping to determine winner

## What i researched on my own

* Change the font family / font size (cf. https://love2d.org/wiki/Tutorial:Fonts_and_Text)

## Libraries

**name - author - github - description**
* push - Ulydev - https://github.com/Ulydev/push - Resolution handling library allowing developers to focus on making their game with a fixed resolution