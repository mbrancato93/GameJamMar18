extends Node

var GRAVITY := 100 setget private
var up := "up" setget private
var left := "left" setget private
var right := "right" setget private
var down := "down" setget private
var shoot := "shoot" setget private

func private( _val = null ):
	print( "Attempted to overwrite global" )
	assert( 1 == 0 )
	pass

