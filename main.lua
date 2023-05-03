require 'dependencies'

function love.load()
	math.randomseed(os.time())

	love.mouse.setVisible(false)

	randomSongIndex = math.random(6)

	love.graphics.setDefaultFilter('nearest', 'nearest')

	love.window.setTitle('Tak: A Beautiful Game')

	titleFont = love.graphics.newFont('fonts/spqr.ttf', 140)
	smallFont = love.graphics.newFont('fonts/DejaVuSansMono.ttf', 30)
	smallerFont = love.graphics.newFont('fonts/DejaVuSansMono.ttf', 20)

    cursor = love.graphics.newImage('/src/pics/cursor.png')
    boardOption1 = love.graphics.newImage('/src/pics/board.png')

	love.graphics.setFont(titleFont)

	sounds = {
		['beep'] = love.audio.newSource('music/beep.wav', 'static'),
		['select'] = love.audio.newSource('music/select.wav', 'static'),
		['stone'] = love.audio.newSource('music/stone.mp3', 'static'),
		['crush'] = love.audio.newSource('music/crush.mp3', 'static'),
        ['chatter'] = love.audio.newSource('music/623565__iainmccurdy__kitchen-bar.mp3', 'static'),
		--['1'] = love.audio.newSource('music/1.mp3', 'static'),
		--['2'] = love.audio.newSource('music/2.mp3', 'static'),
		--['3'] = love.audio.newSource('music/3.mp3', 'static'),
		--['4'] = love.audio.newSource('music/4.mp3', 'static'),
		--['5'] = love.audio.newSource('music/5.mp3', 'static'),
		--['6'] = love.audio.newSource('music/6.mp3', 'static'),
		--['7'] = love.audio.newSource('music/7.mp3', 'static'),
		['8'] = love.audio.newSource('music/8.mp3', 'static'),
		--['9'] = love.audio.newSource('music/9.mp3', 'static'),
		--['10'] = love.audio.newSource('music/10.mp3', 'static'),
		--['11'] = love.audio.newSource('music/11.mp3', 'static')
	}
--]]
--
--
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		fullscreen = false,
		resizable = false
	})

    --love.window.setFullscreen(true, "desktop")

	gStateMachine = StateMachine {
		['titleState'] = function() return TitleScreenState() end,
		['playState'] = function() return PlayState() end,
	}

	gStateMachine:change('playState')

	love.keyboard.keysPressed = {}

	yTextOffset = 750
	lineOffset = 100
	musicPlayed = false
    chatterPlayed = false
end

function love.resize(w, h)
	push:resize(w,h)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end

	if key == 'h' then
		helpState = helpState == 1 and 2 or 1
	end

	if key == 'tab' then
		local mouseState = not love.mouse.isVisible()
		love.mouse.setVisible(mouseState)
	end
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

function displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 6)
end


function love.update(dt)
	gStateMachine:update(dt)

	love.keyboard.keysPressed = {} 

	-- sounds[tostring(randomSongIndex)]:setLooping(true)
    if not chatterPlayed then
        sounds['8']:setLooping(true)
        sounds['chatter']:setVolume(.5)
        sounds['chatter']:play()
        chatterPlayed = true
    end

	if not musicPlayed then
        sounds['8']:setLooping(true)
		sounds['8']:setVolume(.4)
		sounds['8']:play()
		musicPlayed = true
	end
end

function love.draw()
	push:start()

	gStateMachine:render()

	displayFPS()

	if helpState == 1 then
		love.graphics.setFont(smallFont)
		love.graphics.setColor(50/255, 0/255, 200/255, 180/255)
		love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.printf('Select to place a stone, or move a stack in your control', 0, VIRTUAL_HEIGHT - yTextOffset, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Laystones count as road and stack control', 0, VIRTUAL_HEIGHT - yTextOffset + lineOffset, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Standing stones don\'t count as road, but count as control', 0, VIRTUAL_HEIGHT - yTextOffset + lineOffset * 2, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Capstone can crush standing stone if by itself', 0, VIRTUAL_HEIGHT - yTextOffset + lineOffset * 3, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Up to 5 pieces can be picked up to move in one direction', 0, VIRTUAL_HEIGHT - yTextOffset + lineOffset * 4, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('At least one stone needs to be dropped in each space while moving in a single direction', 0, VIRTUAL_HEIGHT - yTextOffset + lineOffset * 5, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('First to have a road across the board wins', 0, VIRTUAL_HEIGHT - yTextOffset + lineOffset * 6 + 50, VIRTUAL_WIDTH, 'center')
	end

	push:finish()
end
