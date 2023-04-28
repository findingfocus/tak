Member = Class{}

--LS == LAYSTONE
--SS == STANDINGSTONE
--CS == CAPSTONE

function Member:init(stoneColor, stoneType, x, y)
	self.stoneColor = stoneColor
	self.stoneType = stoneType
	self.x = x
	self.y = y
	self.stackOrder = 0
	self.originalStackOrder = nil
end

function Member:update(dt)

end

function Member:render()
	if self.stoneColor == 'WHITE' then --SETS COLOR FOR SS AND CS
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	elseif self.stoneColor == 'BLACK' then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
	end

	if self.stoneType == 'LS' then
		if self.stoneColor == 'WHITE' then --SETS  COLOR FOR LS BORDER
			love.graphics.setColor(210/255, 210/255, 210/255, 255/255)
		elseif self.stoneColor == 'BLACK' then
			love.graphics.setColor(65/255, 65/255, 65/255, 255/255)
		end
		love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2), self.y + Y_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2), STONE_WIDTH - ((self.stackOrder - 1) * SHRINK), STONE_WIDTH - ((self.stackOrder - 1) * SHRINK)) --RENDERS BORDER

		if self.stoneColor == 'WHITE' then --RESETS ACTUAL COLOR
			love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		elseif self.stoneColor == 'BLACK' then
			love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		end

		love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2) + 1, self.y + Y_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2) + 1, STONE_WIDTH - ((self.stackOrder - 1) * SHRINK) - 2, STONE_WIDTH - ((self.stackOrder - 1) * SHRINK) - 2) --RENDERS STONE

	elseif self.stoneType == 'SS' then
		if self.stoneColor == 'WHITE' then --SETS SHADOW COLOR
			love.graphics.setColor(210/255, 210/255, 210/255, 255/255)
		elseif self.stoneColor == 'BLACK' then
			love.graphics.setColor(65/255, 65/255, 65/255, 255/255)
		end

		love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2), self.y + Y_OFFSET + OUTLINE + 58 - (SS_HEIGHT - ((self.stackOrder - 1) * SHRINK) / 2.5) / 2, STONE_WIDTH - ((self.stackOrder - 1) * SHRINK), SS_HEIGHT - ((self.stackOrder - 1) * SHRINK) / 2.5 + 4)

		if self.stoneColor == 'WHITE' then --RESETS ACTUAL COLOR
			love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		elseif self.stoneColor == 'BLACK' then
			love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		end

		love.graphics.rectangle('fill', self.x + X_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2) + 1, self.y + Y_OFFSET + OUTLINE + 58 - (SS_HEIGHT - ((self.stackOrder - 1) * SHRINK) / 2.5) / 2 + 1, STONE_WIDTH - ((self.stackOrder - 1) * SHRINK) - 2, SS_HEIGHT - ((self.stackOrder - 1) * SHRINK) / 2.5 + 4 - 2)

	elseif self.stoneType == 'CS' then
		if self.stoneColor == 'WHITE' then --SETS SHADOW COLOR
			love.graphics.setColor(210/255, 210/255, 210/255, 255/255)
		elseif self.stoneColor == 'BLACK' then
			love.graphics.setColor(65/255, 65/255, 65/255, 255/255)
		end

		love.graphics.circle('fill', self.x + X_OFFSET + 72, self.y + Y_OFFSET + 72, CS_HEIGHT - ((self.stackOrder - 1) * SHRINK) / 2.75)

		if self.stoneColor == 'WHITE' then --RESETS ACTUAL COLOR
			love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		elseif self.stoneColor == 'BLACK' then
			love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		end

		love.graphics.circle('fill', self.x + X_OFFSET + 72, self.y + Y_OFFSET + 72, (CS_HEIGHT - ((self.stackOrder - 1) * SHRINK) / 1.8) + (self.stackOrder * .1))
	end

	if self.stoneColor == 'WHITE' and self.stackOrder ~= nil then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		--love.graphics.print(tostring(self.stackOrder), self.x + X_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2), self.y + Y_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2))
	elseif self.stoneColor == 'BLACK' and self.stackOrder ~= nil then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		--love.graphics.print(tostring(self.stackOrder), self.x + X_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2), self.y + Y_OFFSET + OUTLINE + (((self.stackOrder - 1) * SHRINK) / 2))
	end
end
