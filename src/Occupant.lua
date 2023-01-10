Occupant = Class{}

function Occupant:init()
	self.x = x
	self.y = y
	self.width = 144
	self.height = 144
	self.highlighted = false
	self.occupied = false
	self.occupiedWhite = false
	self.occupiedBlack = false
	self.outlineThickness = 12
end

function Occupant:update(dt)

end

function Occupant:render()
	if self.highlighted and not self.occupied then
		--Highlight Grid Outline
		love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
		--TopLine
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, self.outlineThickness)
		--BottomLine
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - self.outlineThickness + Y_OFFSET, self.width, self.outlineThickness)
		--LeftLine
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.outlineThickness, self.height)
		--RightLine
		love.graphics.rectangle('fill', self.x + self.width - self.outlineThickness + X_OFFSET, self.y + Y_OFFSET, self.outlineThickness, self.height)
	end

	if self.occupiedWhite then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET + self.outlineThickness, self.y + Y_OFFSET + self.outlineThickness, 120, 120)
	end

	if self.occupiedBlack then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET + self.outlineThickness, self.y + Y_OFFSET + self.outlineThickness, 120, 120)
	end
end