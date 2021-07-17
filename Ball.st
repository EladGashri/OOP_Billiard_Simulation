CircleMorph subclass: #Ball
	instanceVariableNames: 'direction energy game'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Billiard'

direction
	^direction

energy
	^energy

leftEdge
	^((self center x)-((self extent x)/2))@(self center y)

lowerEdge
	^(self center x)@((self center y)+((self extent y)/2))

pointsToCheckFotHit
	^{self center. self rightEdge. self leftEdge. self upperEdge. self lowerEdge.}

rightEdge
	^((self center x)+((self extent x)/2))@(self center y)

upperEdge
	^(self center x)@((self center y)-((self extent y)/2))

angle:dyValue dx:dxValue
	|dxNotZero smallestPositiveValue angle|
	((dyValue abs) < 10)
		ifTrue:[angle:=(Float pi)/2.0]
		ifFalse:[smallestPositiveValue:=2 raisedTo:(-30).
			((dxValue abs)<smallestPositiveValue)
				ifTrue:[(dxValue positive)
					ifTrue:[dxNotZero:=dxValue+smallestPositiveValue]
					ifFalse:[dxNotZero:=dxValue-smallestPositiveValue].]
				ifFalse:[dxNotZero:=dyValue].
			angle:=((dyValue/dxNotZero) abs) arcTan.].
	(dyValue negative)
		ifTrue:[angle:=(Float pi)-angle].
	(dxValue negative)
		ifTrue:[angle:=angle-(2*angle)].
	^angle

hasIntersected:aBall
	aBall pointsToCheckFotHit do:
		[:aPoint|(self containsPoint:aPoint)
			ifTrue:[^true]].
	^false

hitBy:aBall
	direction:=(self angle:((self center y)-(aBall center y)) dx:((self center x)-(aBall center x))).
	aBall direction:((aBall direction)-((aBall direction)-direction)).
	aBall energy:((aBall energy)/2.0).
	self energy:(energy+(aBall energy)).

inPocket
	energy:=0.
	direction:=0.
	game removeBall:self.

isMoving
	^energy>0

move
	|distance newX newY|
	energy:=(0 max:(energy-10)).
	(energy>0)
		ifFalse:[self stopStepping.
		game checkIfThereAreMovingBalls.
		^self.].
	distance:=10.
	newX := (self center x + (distance * direction sin)) rounded.
	newY := (self center y + (distance * direction cos)) rounded.
	((newX < owner left) or: (newX + self width > self owner bounds right)) ifTrue: [
		direction:= (2*(Float pi)) - direction.
		newX := (self center x + (distance * direction sin)) rounded.
		newY := (self center y + (distance * direction cos)) rounded.
		].
	((newY < self owner top) or: (newY + self height > self owner bounds bottom)) ifTrue: [
		direction:=(Float pi) - direction.
		newX := (self center x + (distance * direction sin)) rounded.
		newY := (self center y + (distance * direction cos)) rounded.
		].
	self center: newX@newY.
	self changed.
	self checkBalls.
	self checkPockets.

step
	super step.
	[self move] fork.

stepTime
	^10

balls:ballsArray
	balls:=ballsArray

direction:aDirection
	direction:=aDirection.

energy:energyValue.
	energy:=energyValue.
	self startStepping.

game:aGame
	game:=aGame.

pockets:pocketsArray
	pockets:=pocketsArray.

initialize
	super initialize.
	self extent:20@20.
	energy:=0.
	direction:=0.

checkBalls
	game balls do:
		[:aBall|(((aBall==self) not) and:[aBall hasIntersected:self])
			ifTrue:[aBall hitBy:self].]

checkPockets
	game pockets do:
		[:aPocket|(aPocket hasIntersected:self)
			ifTrue:[aPocket hitBy:self]].
