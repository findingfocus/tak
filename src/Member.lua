Member = Class{}

--LS == LAYSTONE
--SS == STANDINGSTONE
--CS == CAPSTONE

function Member:init(stoneColor, stoneType, x, y)
	self.stoneColor = stoneColor
	self.stoneType = stoneType
	self.x = x
	self.y = y
	self.stackOrder = nil
end

function Member:update(dt)
	
end

function Member:render()
	if self.stoneColor == 'WHITE' then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	elseif self.stoneColor == 'BLACK' then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
	end

	if self.stoneType == 'LS' then
		love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2), self.y + Y_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2), STONE_WIDTH - ((self.stackOrder - 1) * SHRINK), STONE_WIDTH - ((self.stackOrder - 1) * SHRINK))
	elseif self.stoneType == 'SS' then
		love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2), self.y + Y_OFFSET + OUTLINE + 60 - (SS_HEIGHT - ((self.stackOrder - 1) * SHRINK) / 2.5) / 2, STONE_WIDTH - ((self.stackOrder - 1) * SHRINK), SS_HEIGHT - ((self.stackOrder - 1) * SHRINK) / 2.5)
	elseif self.stoneType == 'CS' then
		love.graphics.circle('fill', self.x + X_OFFSET + 72, self.y + Y_OFFSET + 72, CS_HEIGHT - ((self.stackOrder - 1) * SHRINK) / 3)
	end

	if self.stoneColor == 'WHITE' and self.stackOrder ~= nil then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		--love.graphics.print(tostring(self.stackOrder), self.x + X_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2), self.y + Y_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2))
	elseif self.stoneColor == 'BLACK' and self.stackOrder ~= nil then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		--love.graphics.print(tostring(self.stackOrder), self.x + X_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2), self.y + Y_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2))
	end
end
