Object subclass: #BilliardGame
	instanceVariableNames: 'balls movingBallsSemaphore pockets room table text cue stick numberOfBallsInHoles quitButton'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Billiard'

updateText
	text contents: ('Number of balls in pockets: ', numberOfBallsInHoles asString,' out of 15') asText.
	text fontName: 'BitstreamVeraSans' size: 40.

initialize
	super initialize.

initializeAll
	self initializeTable.
	self initializeText.
	self initializeWalls.
	self initializePockets.
	self initializeBalls.
	self initializeStick.
	self initializeRoom.
	self initializeButton.
	self initializeSemaphore.

initializeBalls
	|tableX tableY tableH tableW currBall ballSize ballsStartX ballsStartY index|
	tableX:=table position x.
	tableY:=table position y.
	tableH:=table height.
	tableW:= table width.
	balls:=OrderedCollection new:16.
	cue:=CueBall new.
	cue default:(tableX+(tableW/4)) y:(tableY+(tableH/2)).
	cue setCenterToDefault.
	cue game:self.
	balls add:cue.
	table addMorph:cue.
	ballSize:=cue extent x.
	ballsStartX:=tableX+((tableW*3)/4).
	ballsStartY:=tableY+(tableH/2).
	index:=68.
	(1 to:5)
		do:[:row|
			(1 to:row)
				do:[:column|
					currBall:=Ball new.
					currBall color:(Color perform:( Color colorNames at:(index:=index+1))).
					currBall center:(ballsStartX+(ballSize*(row-1)))@(ballsStartY-((ballSize/2)*(row-1))+(ballSize*(column-1))).
					currBall game:self.
					balls add:currBall.
					table addMorph:currBall.
					].
			].

initializeButton
	quitButton:=SimpleButtonMorph new.
	quitButton label: 'Quit'.
	quitButton target:self.
	quitButton color:Color gray.
	quitButton extent:100@100.
	quitButton position: Display width-100@100.
	quitButton actionSelector: #quit.

initializePockets
	|tableX tableY tableH tableW currPocket|
	tableX:=table position x.
	tableY:=table position y.
	tableH:=table height.
	tableW:= table width.
	pockets:=OrderedCollection new:6.
	(0 to: 2) do:
		[:i| currPocket:=Pocket new.
			currPocket center:(tableX+((tableW/2)*i))@tableY.
			pockets add:currPocket.
			table addMorph:currPocket.
			currPocket:=Pocket new.
			currPocket center:(tableX+((tableW/2)*i))@(tableY+tableH).
			pockets add:currPocket.
			table addMorph:currPocket.
		].

initializeRoom
	room:=Room new.
	room stick:stick.

initializeSemaphore
	movingBallsSemaphore:=Semaphore new.

initializeStick
	stick:=Stick new.
	stick game:self.
	stick setPositionAndSize.

initializeTable
	table:=RectangleMorph new.
	table position:600@300; extent:700@300; color:Color green.

initializeText
	text := TextMorph new.
	text center: (table position x)@((table position y)-200). 
	self updateText.

initializeWalls
	|tableX tableY tableH tableW wallWidth horizontal1 horizontal2 vertical1 vertical2|
	tableX:=table position x.
	tableY:=table position y.
	tableH:=table height.
	tableW:= table width.
	wallWidth:=20.
	horizontal1:=RectangleMorph new.
	horizontal1 position:(tableX)@(tableY-wallWidth); extent:tableW@wallWidth; color:Color brown.
	table addMorph:horizontal1.
	horizontal2:=RectangleMorph new.
	horizontal2 position:(tableX)@(tableY+tableH); extent:tableW@wallWidth; color:Color brown.
	table addMorph:horizontal2.
	vertical1:=RectangleMorph new.
	vertical1 position:(tableX-wallWidth)@(tableY-wallWidth); extent:wallWidth@(tableH+(2*wallWidth)); color:Color brown.
	table addMorph:vertical1.
	vertical2:=RectangleMorph new.
	vertical2 position:(tableX+tableW)@(tableY-wallWidth); extent:wallWidth@(tableH+(2*wallWidth)); color:Color brown.
	table addMorph:vertical2.

play
	numberOfBallsInHoles:=0.
	self initializeAll.
	{room. table. stick. text. quitButton.}
		do:[:each| each openInWorld].	

quit
	table submorphs
		do:[:each| each delete].
	{room. table. stick. text. quitButton.}
		do:[:each|each delete. each:=nil.].

balls
	^balls

cue
	^cue

movingBallsSemaphore
	^movingBallsSemaphore

pockets
	^pockets

checkIfThereAreMovingBalls
	balls do:
		[:aBall| (aBall isMoving)
			ifTrue:[^self]].
	movingBallsSemaphore signal.

removeBall:aBall
	balls remove:aBall ifAbsent: [].
	aBall delete.
	numberOfBallsInHoles:=numberOfBallsInHoles+1.
	self updateText.
