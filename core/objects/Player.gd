extends BasicBody

var force := 200

enum {WATER,STEAM,ICE}

var state := WATER
var transitioning := false

# Called when the node enters the scene tree for the first time.
func _ready():
	debug.verbosity = 2
	debug.period = 1000
	damping = 5
	pass # Replace with function body.

func transition_end( _val = null ):
	transitioning = false
	
func _physics_process(delta):
	
	# check if a transition was requested
	# make sure we aren't currently transitioning
	if( controls.transition_request() && !transitioning ):
		transitioning = true
#		var anim_player = get_node( "AnimationPlayer" )
#		anim_player.connect( "finished", self, "transition_end" )
		$AnimationPlayer.connect( "animation_finished", self, "transition_end" )
		var state_transition_anim = "none"
		if( state == WATER ):
			state_transition_anim = "WATER2STEAM"
			state = STEAM
		elif( state == STEAM ):
			state_transition_anim = "STEAM2ICE"
			state = ICE
		elif( state == ICE ):
			state_transition_anim = "ICE2WATER"
			state = WATER
		else:
			assert( 1 == 0 )
#		anim_player.play( state_transition_anim ) 
		$AnimationPlayer.play( state_transition_anim )
		return
	elif( transitioning ):
		return
	 
	var arr = controls.get_input( force )
	curr_forces = Vector2( 
		( arr[2] - arr[0] ),
		( arr[3] - arr[1] )
	)
	
	if( curr_forces[0] > 0 ):
		$Sprite.scale.x = 1
	elif( curr_forces[0] < 0 ):
		$Sprite.scale.x = -1

	var acceleration := Vector2()
	var anim_name := "none"
	
	if( state == WATER ):
		var p = Water.new()
		var ret = p.calc_motion( mass, damping, velocity, curr_forces, is_on_floor() )
		acceleration = ret.accel
		anim_name = ret.anim
	elif( state == STEAM ):
		var p = Steam.new()
		var ret = p.calc_motion( mass, damping, velocity, curr_forces, is_on_floor() )
		acceleration = ret.accel
		anim_name = ret.anim
	elif( state == ICE ):
		var p = Water.new()
		var ret = p.calc_motion( mass, damping, velocity, curr_forces, is_on_floor() )
		acceleration = ret.accel
		anim_name = ret.anim
	else:
		assert( 1== 0 )
	
	velocity += acceleration * delta
	$AnimationPlayer.play( anim_name )
#	debug.DEBUG( "%f %f" % [ velocity[0], velocity[1] ] )
	debug.DEBUG( "Anim: %s" % anim_name )

	velocity = move_and_slide( velocity, UP )
