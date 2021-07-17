Ball subclass: #CueBall
	instanceVariableNames: 'xDefault yDefault pauseNextAct'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Billiard'

initialize
	super initialize.
	self color:Color white.
	pauseNextAct:=false.

inPocket
	energy:=0.
	direction:=0.
	pauseNextAct:=true.
	game movingBallsSemaphore wait.
	pauseNextAct:=false.
	self setCenterToDefault.

pauseNextAct
	^pauseNextAct

default:xValue y:yValue
	xDefault:=xValue.
	yDefault:=yValue.

setCenterToDefault
	self center:xDefault@yDefault.
	self changed.
