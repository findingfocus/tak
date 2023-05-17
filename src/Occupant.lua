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
    self.leftMatchWhite = false
    self.rightMatchWhite = false
    self.topMatchWhite = false
    self.bottomMatchWhite = false
    self.leftMatchBlack = false
    self.rightMatchBlack = false
    self.topMatchBlack = false
    self.bottomMatchBlack = false
    self.potentialRoadWhiteH = false
    self.potentialRoadBlackH = false
    self.potentialRoadWhiteV = false
    self.potentialRoadBlackV = false
    self.roadWhiteHToggle = false
    self.roadWhiteVToggle = false
    self.roadBlackHToggle = false
    self.roadBlackVToggle = false
end

function Occupant:update(dt)

end

function Occupant:render()
	if self.selectionHighlight and not mouseOffGrid then -- HIGHLIGHTS GRID SPACE OUTLINE
		love.graphics.setColor(255/255, 0/255, 0/255, 255/255)
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, OUTLINE) --TOP
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - OUTLINE + Y_OFFSET, self.width, OUTLINE) --BOTTOM
		love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --LEFT
		love.graphics.rectangle('fill', self.x + self.width - OUTLINE + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --RIGHT
	end
	if self.legalMoveHighlight and not mouseOffGrid then
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
    if self.potentialRoadWhiteH then
        if self.roadWhiteHToggle then
            love.graphics.setColor(0/255, 0/255, 255/255, 255/255)
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, OUTLINE) --TOP
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - OUTLINE + Y_OFFSET, self.width, OUTLINE) --BOTTOM
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --LEFT
            love.graphics.rectangle('fill', self.x + self.width - OUTLINE + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --RIGHT
        end
    end
    if self.potentialRoadBlackH then
        if self.roadBlackHToggle then
            love.graphics.setColor(0/255, 200/255, 255/255, 255/255)
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, OUTLINE) --TOP
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - OUTLINE + Y_OFFSET, self.width, OUTLINE) --BOTTOM
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --LEFT
            love.graphics.rectangle('fill', self.x + self.width - OUTLINE + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --RIGHT
        end
    end
    if self.potentialRoadWhiteV then
        if self.roadWhiteVToggle then
            love.graphics.setColor(255/255, 150/255, 200/255, 255/255)
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, OUTLINE) --TOP
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - OUTLINE + Y_OFFSET, self.width, OUTLINE) --BOTTOM
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --LEFT
            love.graphics.rectangle('fill', self.x + self.width - OUTLINE + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --RIGHT
        end
    end
    if self.potentialRoadBlackV then
        if self.roadBlackVToggle then
            love.graphics.setColor(255/255, 200/255, 40/255, 255/255)
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, self.width, OUTLINE) --TOP
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + self.height - OUTLINE + Y_OFFSET, self.width, OUTLINE) --BOTTOM
            love.graphics.rectangle('fill', self.x + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --LEFT
            love.graphics.rectangle('fill', self.x + self.width - OUTLINE + X_OFFSET, self.y + Y_OFFSET, OUTLINE, self.height) --RIGHT
        end
    end
end
