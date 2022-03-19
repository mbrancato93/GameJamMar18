extends Node

var GRAVITY := 150 setget private
var up := "up" setget private
var left := "left" setget private
var right := "right" setget private
var down := "down" setget private
var shoot := "shoot" setget private
var transition := "cycle_state" setget private

func private( _val = null ):
	print( "Attempted to overwrite global" )
	assert( 1 == 0 )
	pass

