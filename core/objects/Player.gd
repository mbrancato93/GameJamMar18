extends BasicBody

#export (PackedScene) var Projectile
const PROJECTILE_SCENE = preload( "res://objects/Projectile.tscn" )

var force := 200

enum {WATER,STEAM,ICE}

var state := WATER setget setState
var transitioning := false
onready var shot_debounce := OS.get_ticks_msec()
var facing := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	debug.verbosity = 2
	debug.period = 1000
	damping = 5
	pass # Replace with function body.

func shoot( facing: float ):
	if( ( OS.get_ticks_msec() - shot_debounce ) < 700 ):
		return
	var b = PROJECTILE_SCENE.instance()
	b.speed *= facing
	owner.add_child(b)
	if( facing > 0 ):
		b.transform = $MuzzleRight.global_transform
	elif( facing < 0 ):
		b.transform = $MuzzleLeft.global_transform
	else:
		assert( 1==0 )
	shot_debounce = OS.get_ticks_msec()
	
func setState( _val ):
	print_debug( "State change request" )
	
	transitioning = true
	var state_transition_anim := "none"
	$AnimationPlayer.connect( "animation_finished", self, "transition_end" )
	if( state == WATER && _val == ICE ):
		state_transition_anim = "WATER2ICE"
	elif( state == WATER && _val == STEAM ):
		state_transition_anim = "WATER2STEAM"
	elif( state == ICE && _val == WATER ):
		state_transition_anim = "ICE2WATER"
	elif( state == ICE && _val == STEAM ):
		state_transition_anim = "ICE2STEAM"
	elif( state == STEAM && _val == WATER ):
		state_transition_anim = "STEAM2WATER"
	elif( state == STEAM && _val == ICE ):
		assert( 1 == 0 )
	else:
		assert( 1 == 0 )
		
	$AnimationPlayer.play( state_transition_anim )
	state = _val

func transition_end( _val = null ):
	transitioning = false
	
func _physics_process(delta):
	
	var arr = controls.get_input( force )
	curr_forces = Vector2( 
		( arr[2] - arr[0] ),
		( arr[3] - arr[1] )
	)
	
	# check if a transition was requested
	# make sure we aren't currently transitioning
	if( controls.transition_request() && !transitioning && is_on_floor() ):
		if( state == WATER ):
			setState( STEAM )
		elif( state == STEAM ):
			setState( WATER )
		else:
			assert( 1 == 0 )
		
		return
	elif( transitioning ):
#		curr_forces[1] = 0
		return
	 
	# check if shooting
	if( controls.shoot_request() && state == WATER ):
		self.shoot( facing )
	
#	debug.DEBUG( "On Floor: %d, Vert Force: %f" % [ int( is_on_floor() ), curr_forces[1] ] )
	if( is_on_floor() && curr_forces[1] > 0 && state == WATER ):
		# transition to ice if water	
		setState ( ICE )
		return
		
	if( curr_forces[1] <= 0 && state == ICE ):
		setState ( WATER )
		return
	
#	if( curr_forces[0] > 0 ):
#		facing = 1
#		$Sprite.scale.x = 1
#	elif( curr_forces[0] < 0 ):
#		facing = -1
#		$Sprite.scale.x = -1

	var acceleration := Vector2()
	var anim_name := "none"
	var sprite_scale := 1
	
	if( state == WATER ):
		var p = Water.new()
		var ret = p.calc_motion( mass, damping, velocity, curr_forces, is_on_floor(), facing )
		acceleration = ret.accel
		anim_name = ret.anim
		sprite_scale = ret.facing
	elif( state == STEAM ):
		var p = Steam.new()
		var ret = p.calc_motion( mass, damping, velocity, curr_forces, is_on_floor(), facing )
		acceleration = ret.accel
		anim_name = ret.anim
		sprite_scale = ret.facing
	elif( state == ICE ):
		var p = Ice.new()
		var ret = p.calc_motion( mass, 0.0*damping, velocity, curr_forces, is_on_floor(), facing )
		acceleration = ret.accel
		anim_name = ret.anim
		sprite_scale = ret.facing
	else:
		assert( 1== 0 )
	
	velocity += acceleration * delta
	$Sprite.scale.x = sprite_scale
	facing = sprite_scale
	$AnimationPlayer.play( anim_name )
	
#	debug.DEBUG( "%f %f" % [ velocity[0], velocity[1] ] )
#	debug.DEBUG( "Anim: %s" % anim_name )

	velocity = move_and_slide( velocity, UP )
