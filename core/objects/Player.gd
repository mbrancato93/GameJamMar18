extends BasicBody

var force := 200

# Called when the node enters the scene tree for the first time.
func _ready():
	debug.verbosity = 2
	debug.period = 1000
	damping = 2
	pass # Replace with function body.

func _physics_process(delta):
	$AnimationPlayer.play( "Idle" ) 
	var arr = controls.get_input( force )
	curr_forces = Vector2( 
		( arr[2] - arr[0] ) / mass,
		( arr[3] - arr[1] ) / mass
	)
	
	if( curr_forces[0] > 0 ):
		$Sprite.scale.x = 1
	elif( curr_forces[0] < 0 ):
		$Sprite.scale.x = -1
	
	if( !is_on_floor() ):
		curr_forces[1] = max( 0, curr_forces[1] )
	else:
		curr_forces[1] = min( 0, 30*curr_forces[1] )
	
	var acceleration := curr_forces / mass
#	if( is_on_floor() ):
	acceleration[0] -= damping * velocity[0]
	acceleration[1] += ( g.GRAVITY / mass - sign( velocity[1] ) * damping )
	
	velocity += acceleration * delta
	debug.DEBUG( "%f %f" % [ velocity[0], velocity[1] ] )

	velocity = move_and_slide( velocity, UP )
