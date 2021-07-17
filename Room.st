RectangleMorph subclass: #Room
	instanceVariableNames: 'stick'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Billiard'

initialize
	super initialize.
	self position:0@0.
	self extent: Display extent.
	self color:Color white.

stick:aStick
	stick:=aStick.

handlesMouseMove: anEvent
	^true

mouseMove: anEvent
	stick wasGrabbed
		ifTrue:[stick position:(stick position x-(stick lastPosition x -anEvent position x))@(stick position y -(stick lastPosition y-anEvent position y)).
			stick changed.
			stick lastPosition:anEvent position.
				].
