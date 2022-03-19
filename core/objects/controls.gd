extends Node2D

var g  = load( "res://objects/GLOBALS.gd" ).new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input( force: float ) -> Array:
	var arr := []
	arr.append( Input.get_action_strength( g.left ) * force )
	arr.append( Input.get_action_strength( g.up ) * force )
	arr.append( Input.get_action_strength( g.right ) * force )
	arr.append( Input.get_action_strength( g.down ) * force )
	return arr
