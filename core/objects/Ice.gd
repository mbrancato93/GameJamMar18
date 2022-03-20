extends KinematicBody2D
class_name Ice

var g = load( "res://objects/GLOBALS.gd" ).new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func calc_motion( mass: float, damping: float, velocity: Vector2, forces: Vector2, on_floor: bool, facing: float, grav: float ):
#	var facing := 1
	if( velocity[0] < 0 ):
		facing = -1
		
	return { "accel": Vector2( -facing * damping * abs( velocity[0] ), 0 ), "anim": "ice_idle", "facing": facing }
