push = require '/dependencies/push'

Class = require 'dependencies/class'

require '/dependencies/StateMachine'
require '/dependencies/BaseState'

require '/states/TitleScreenState'
require '/states/PlayState'
require '/states/HelpState'

require '/src/Board'
require '/src/Occupant'

--1280 800
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 800


VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 800

function love.load()

	math.randomseed(os.time())
	randomSongIndex = math.random(6)

	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Tak: A Beautiful Game')

	pixelFont = love.graphics.newFont('fonts/Pixel.ttf', 160)
	smallPixelFont = love.graphics.newFont('fonts/Pixel.ttf', 40)
	love.graphics.setFont(pixelFont)

	sounds = {
		['beep'] = love.audio.newSource('music/beep.wav', 'static'),
		['select'] = love.audio.newSource('music/select.wav', 'static'),
		['stone'] = love.audio.newSource('music/stone.mp3', 'static'),
		['1'] = love.audio.newSource('music/1.mp3', 'static'),
		['2'] = love.audio.newSource('music/2.mp3', 'static'),
		['3'] = love.audio.newSource('music/3.mp3', 'static'),
		['4'] = love.audio.newSource('music/4.mp3', 'static'),
		['5'] = love.audio.newSource('music/5.mp3', 'static'),
		['6'] = love.audio.newSource('music/6.mp3', 'static'),
		--['7'] = love.audio.newSource('music/7.mp3', 'static'),
		--['8'] = love.audio.newSource('music/8.mp3', 'static'),
		--['9'] = love.audio.newSource('music/9.mp3', 'static'),
		--['10'] = love.audio.newSource('music/10.mp3', 'static'),
		--['11'] = love.audio.newSource('music/11.mp3', 'static')
	}
--]]
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = true,
		resizable = false
	})

	gStateMachine = StateMachine {
		['titleState'] = function() return TitleScreenState() end,
		['playState'] = function() return PlayState() end,
		['helpState'] = function() return HelpState() end
	}

	gStateMachine:change('playState')

	love.keyboard.keysPressed = {}

end

function love.resize(w, h)
	push:resize(w,h)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end





function love.update(dt)

	gStateMachine:update(dt)

	love.keyboard.keysPressed = {} 

	sounds[tostring(randomSongIndex)]:setLooping(true)
	sounds[tostring(randomSongIndex)]:play()
end



function love.draw()
	push:start()

	gStateMachine:render()

	displayFPS()

	push:finish()
end

function displayFPS()
	love.graphics.setFont(smallPixelFont)
	love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
	--love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 6)
end