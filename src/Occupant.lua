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
	self.yOffset = 40
end

function Occupant:update(dt)

end

function Occupant:render()
	if self.highlighted and not self.occupied then
		--Highlight Grid Outline
		love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
		--TopLine
		love.graphics.rectangle('fill', self.x, self.y + self.yOffset, self.width, self.outlineThickness)
		--BottomLine
		love.graphics.rectangle('fill', self.x, self.y + self.height - self.outlineThickness + self.yOffset, self.width, self.outlineThickness)
		--LeftLine
		love.graphics.rectangle('fill', self.x, self.y + self.yOffset, self.outlineThickness, self.height)
		--RightLine
		love.graphics.rectangle('fill', self.x + self.width - self.outlineThickness, self.y + self.yOffset, self.outlineThickness, self.height)
	end

	if self.occupiedWhite then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.rectangle('fill', self.x + 22, self.y + 62, 100, 100)
	end

	if self.occupiedBlack then
		love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
		love.graphics.rectangle('fill', self.x + 22, self.y + 62, 100, 100)
	end
end