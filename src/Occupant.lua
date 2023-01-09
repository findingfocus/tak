Occupant = Class{}

function Occupant:init()
	self.x = x
	self.y = y
	self.width = 144
	self.height = 144
	self.highlighted = false
	self.outlineThickness = 12
end

function Occupant:update(dt)

end

function Occupant:render()
	if self.highlighted then
		--Highlight Grid Outline
		love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
		--TopLine
		love.graphics.rectangle('fill', self.x, self.y, self.width, self.outlineThickness)
		--BottomLine
		love.graphics.rectangle('fill', self.x, self.y + self.height - self.outlineThickness, self.width, self.outlineThickness)
		--LeftLine
		love.graphics.rectangle('fill', self.x, self.y, self.outlineThickness, self.height)
		--RightLine
		love.graphics.rectangle('fill', self.x + self.width - self.outlineThickness, self.y, self.outlineThickness, self.height)
	end
end