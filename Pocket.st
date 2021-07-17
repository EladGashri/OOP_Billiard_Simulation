CircleMorph subclass: #Pocket
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Billiard'

hasIntersected:aBall
	aBall pointsToCheckFotHit do:
		[:aPoint|(self containsPoint:aPoint)
			ifTrue:[^true]].
	^false

hitBy:aBall
	aBall inPocket.

initialize
	super initialize.
	self extent:25@25; color:Color black.
