Member = Class{}

--WHITE == 1
--BLACK == 2

--LS == 1
--SS == 2
--CP == 3

function Member:init(stoneColor, stoneType, x, y)
	self.stoneColor = stoneColor
	self.stoneType = stoneType
	self.x = x
	self.y = y
end

function Member:update(dt)
	
end

function Member:render()
	--love.graphics.print('MEMBER RENDER', 5, 5)
	if self.stoneColor == 1 then
		--love.graphics.print('MEMBER RENDER', 5, 5)
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		--love.graphics.rectangle('fill', 0, 0, 120, 120)
		love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE, self.y + Y_OFFSET + OUTLINE, 120, 120)
	elseif self.stoneColor == 2 then
		--love.graphics.print('MEMBER RENDER', 5, 5)
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		--love.graphics.rectangle('fill', 0, 0, 120, 120)
		love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE, self.y + Y_OFFSET + OUTLINE, 120, 120)
	end
end
