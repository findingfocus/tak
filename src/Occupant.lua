Occupant = Class{}

function Occupant:init()
	self.x = x
	self.y = y
	self.width = 144
	self.height = 144
	self.occupants = 0
	self.selectionHighlight = false
	self.occupied = false
	self.members = {}
	--[[
	self.occupiedWhite = false
	self.occupiedBlack = false
	self.occupiedWhiteSS = false
	self.occupiedBlackSS = false
	self.occupiedWhiteCS = false
	self.occupiedBlackCS = false
	--]]
--[[
	for i = 1, 10 do --GIVES US MEMORY FOR 10 MEMBER OBJECTS IN EACH OCCUPANT INSTANCE
		self.members[i] = Member(nil, nil, self.x, self.y)
		--self.members.stoneColor = 1
		--self.members.stoneType = 1
	end
--]]
end

function Occupant:update(dt)

end

function Occupant:render()
	if self.selectionHighlight then -- HIGHLIGHTS GRID SPACE OUTLINE
		love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, OUTLINE) --TOP
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - OUTLINE + Y_OFFSET, self.width, OUTLINE) --BOTTOM
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --LEFT
		love.graphics.rectangle('fill', self.x + self.width - OUTLINE + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --RIGHT
	end

	--love.graphics.print(tostring(self.occupied, 0 ,0))

	--	love.graphics.rectangle('fill', self.x + X_OFFSET + self.OUTLINE, self.y + Y_OFFSET + self.OUTLINE, 120, 120)

--[[
	if self.occupiedWhite then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET + self.OUTLINE, self.y + Y_OFFSET + self.OUTLINE, 120, 120)
	end

	if self.occupiedBlack then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET + self.OUTLINE, self.y + Y_OFFSET + self.OUTLINE, 120, 120)
	end

	if self.occupiedWhiteSS then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET + self.OUTLINE, self.y + Y_OFFSET + 50, 120, 44)
	end

	if self.occupiedBlackSS then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET + self.OUTLINE, self.y + Y_OFFSET + 50, 120, 44)
	end

	if self.occupiedWhiteCS then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.circle('fill', self.x + X_OFFSET + 72, self.y + Y_OFFSET + 72, 50)
	end

	if self.occupiedBlackCS then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		love.graphics.circle('fill', self.x + X_OFFSET + 72, self.y + Y_OFFSET + 72, 50)
	end
--]]
end