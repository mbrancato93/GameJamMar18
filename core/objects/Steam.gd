extends KinematicBody2D
class_name Steam

var g = load( "res://objects/GLOBALS.gd" ).new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func calc_motion( mass: float, damping: float, velocity: Vector2, forces: Vector2, on_floor: bool, facing: float ):
	var anim_name = "none"
	
	if( !on_floor ):
		forces[1] = max( 0, forces[1] )
	else:
		forces[1] = min( 0, 30*forces[1] )
	
	var acceleration := forces / mass
#	if( is_on_floor() ):
	acceleration[0] -= damping * velocity[0]
	acceleration[1] += ( 0.5 * g.GRAVITY / mass - sign( velocity[1] ) * damping )
	
	if( forces[1] < 0 || velocity[1] < 0  ):
#		anim_name = "steam_jump"
		anim_name = "steam_idle"
	elif( forces[0] != 0 ):
#		anim_name = "steam_move"
		anim_name = "steam_idle"
	else:
		anim_name = "steam_idle"
		
	if( forces[0] > 0 ):
		facing = 1
	elif( forces[0] < 0 ):
		facing = -1
		
	return { "accel": acceleration, "anim": anim_name, "facing": facing }
