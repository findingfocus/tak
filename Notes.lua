
Move
	-Lock in movementOrigin
	-Drop stones
	-stonesInHandLocked = true
	-Render legal moves from movementOrigin
	-Once Grid selected, that grid is firstMovementLocked
	-Drop stones
	-Render Legalmoves from firstMovementLocked with direction locked
	-Once selected, that grid is secondMovementLocked

	--ends on fourth movement locked

	-Upon legal move check, we need to check the next legal move spaces, if there are no legal moves once placed, then we need to place them all upon a click in that space,
		Upon pressing enter, see if there are any limitations in movemnt once locked, if so, enter will only advance the player when mouseStones.occupants are empty