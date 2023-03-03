Occupant = Class{}

function Occupant:init()
	self.x = x
	self.y = y
	self.width = 144
	self.height = 144
	self.occupants = 0
	self.selectionHighlight = false
	self.legalMove = false
	self.legalMoveHighlight = false
	self.moveLockedHighlight = false
	self.occupied = false
	self.members = {}
	self.firstMoveLocked = false
	self.stackControl = nil
	self.stoneControl = nil
	self.bottomStoneIndex = 1
end

function Occupant:update(dt)
	if self.legalMove then
		self.legalMoveHighlight = true
	else
		self.legalMoveHighlight = false
	end
end

function Occupant:render()
	if self.selectionHighlight then -- HIGHLIGHTS GRID SPACE OUTLINE
		love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, OUTLINE) --TOP
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - OUTLINE + Y_OFFSET, self.width, OUTLINE) --BOTTOM
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --LEFT
		love.graphics.rectangle('fill', self.x + self.width - OUTLINE + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --RIGHT
	end

	if self.legalMoveHighlight then
		love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, OUTLINE) --TOP
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - OUTLINE + Y_OFFSET, self.width, OUTLINE) --BOTTOM
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --LEFT
		love.graphics.rectangle('fill', self.x + self.width - OUTLINE + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --RIGHT
	end

	if self.moveLockedHighlight then
		love.graphics.setColor(0/255, 150/255, 0/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, OUTLINE) --TOP
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - OUTLINE + Y_OFFSET, self.width, OUTLINE) --BOTTOM
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --LEFT
		love.graphics.rectangle('fill', self.x + self.width - OUTLINE + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --RIGHT
	end

	if self.firstMoveLocked then
		love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, OUTLINE) --TOP
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - OUTLINE + Y_OFFSET, self.width, OUTLINE) --BOTTOM
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --LEFT
		love.graphics.rectangle('fill', self.x + self.width - OUTLINE + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --RIGHT
	end
end