extends Node

var GRAVITY := 70
var up := "up" setget private
var left := "left" setget private
var right := "right" setget private
var down := "down" setget private
var shoot := "shoot" setget private
var transition := "cycle_state" setget private
var toggle_music := "toggle_music" setget private

var grav_mod := 0
var damp_mod := 0

var upVec := Vector2( 0, -1 )

func private( _val = null ):
	print( "Attempted to overwrite global" )
	assert( 1 == 0 )
	pass

