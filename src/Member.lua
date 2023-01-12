Member = Class{}

--LS == LAYSTONE
--SS == STANDINGSTONE
--CS == CAPSTONE

function Member:init(stoneColor, stoneType, x, y)
	self.stoneColor = stoneColor
	self.stoneType = stoneType
	self.x = x
	self.y = y
end

function Member:update(dt)
	
end

function Member:render()
	if self.stoneColor == 'WHITE' then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		if self.stoneType == 'LS' then
			love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE, self.y + Y_OFFSET + OUTLINE, 120, 120)
		elseif self.stoneType == 'SS' then
			love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE, self.y + Y_OFFSET + 50, 120, 44)
		elseif self.stoneType == 'CS' then
			love.graphics.circle('fill', self.x + X_OFFSET + 72, self.y + Y_OFFSET + 72, 50)
		end
	elseif self.stoneColor == 'BLACK' then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		if self.stoneType == 'LS' then
			love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE, self.y + Y_OFFSET + OUTLINE, 120, 120)
		elseif self.stoneType == 'SS' then
			love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE, self.y + Y_OFFSET + 50, 120, 44)
		elseif self.stoneType == 'CS' then
			love.graphics.circle('fill', self.x + X_OFFSET + 72, self.y + Y_OFFSET + 72, 50)
		end
	end
end
