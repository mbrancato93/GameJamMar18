extends BasicBody

#export (PackedScene) var Projectile
const PROJECTILE_SCENE = preload( "res://objects/Projectile.tscn" )

var force := 200

enum {WATER,STEAM,ICE}

var state := WATER setget setState
var transitioning := false
onready var shot_debounce := OS.get_ticks_msec()
var facing := 1
var freeze := false
var prev_anim := "none"

onready var hit_debounce = OS.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready():
	debug.verbosity = 1
	debug.period = 1000
	damping = 3.2
	$AnimationPlayer.connect( "animation_finished", self, "transition_end" )
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
	b.start_x = b.position
	shot_debounce = OS.get_ticks_msec()
	if( !$Shoot.playing ):
		$Shoot.play()
	
func setState( _val ):
	if( transitioning ):
		return
	print_debug( "State change request" )
	
	transitioning = true
	var state_transition_anim := "none"
#	$AnimationPlayer.connect( "animation_finished", self, "transition_end" )
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
	elif( state == _val ):
		pass
	else:
		assert( 1 == 0 )
		
	if( state_transition_anim != "none" ):
		$AnimationPlayer.play( state_transition_anim )
	else:
		transitioning = false
#		$AnimationPlayer.disconnect( "animation_finished", self, "transition_end" )
	state = _val

func transition_end( _val = null ):
	transitioning = false
#	$AnimationPlayer.disconnect( "animation_finished", self, "transition_end" )
#
func hit( source ):
	if( ( OS.get_ticks_msec() - hit_debounce ) < 1000 ):
		return
#	debug.DEBUG( "Hit by Enemy" )
	hit_debounce = OS.get_ticks_msec()
	if( state == STEAM ):
		setState( WATER )
#		get_parent().reset()
		get_tree().reload_current_scene()
		return
	if( state != ICE ):
		setState( STEAM )

func _input( event ):
	if( event.is_action_pressed( "grav_up" ) ):
		g.GRAVITY += 10
	if( event.is_action_pressed( "grav_down" ) ):
		if( g.GRAVITY >= 20 ):
			 g.GRAVITY -= 10
	if( event.is_action_pressed( "damp_up" ) ):
		damping += 0.1
	if( event.is_action_pressed( "damp_down" ) ):
		if( damping >= 0.1 ):
			damping -= 0.1
		


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
#		pass
	 
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
	
	var acceleration := Vector2()
	var anim_name := "none"
	var sprite_scale := 1
	
	debug.DEBUG( "Gravity: %f, Damping: %f" % [ g.GRAVITY, damping ] )
#	debug.DEBUG( "Damping: %f" % damping )
	
	if( state == WATER ):
		var p = Water.new()
		var ret = p.calc_motion( mass, damping, velocity, curr_forces, is_on_floor(), facing, g.GRAVITY, prev_anim )
		acceleration = ret.accel
		anim_name = ret.anim
		sprite_scale = ret.facing
	elif( state == STEAM ):
		var p = Steam.new()
		var ret = p.calc_motion( mass, damping, velocity, curr_forces, is_on_floor(), facing, g.GRAVITY )
		acceleration = ret.accel
		anim_name = ret.anim
		sprite_scale = ret.facing
	elif( state == ICE ):
		var p = Ice.new()
		var ret = p.calc_motion( mass, 0.1*damping, velocity, curr_forces, is_on_floor(), facing, g.GRAVITY )
		acceleration = ret.accel
		anim_name = ret.anim
		sprite_scale = ret.facing
	else:
		assert( 1== 0 )
	
	velocity += acceleration * delta
	$Sprite.scale.x = sprite_scale
	facing = sprite_scale
	
	if( anim_name != "none" ):
		$AnimationPlayer.play( anim_name )
	prev_anim = anim_name
	
#	debug.DEBUG( "%f %f" % [ velocity[0], velocity[1] ] )
#	debug.DEBUG( "Anim: %s" % anim_name )
	
	if( freeze ):
		velocity = Vector2(0,0)

	velocity = move_and_slide( velocity, UP )
	
	if( self.position[1] > 1000 ):
		get_parent().reset()


func _on_AnimationPlayer_animation_started(anim_name):
	if( anim_name == "water_jump" ):
		if( !$Jump.playing ):
			$Jump.play()
	if( anim_name == "WATER2ICE" ):
		if( !$Transform2Ice.playing ):
			$Transform2Ice.play()
	if( anim_name == "STEAM2WATER" ):
		if( !$Transform2Water.playing ):
			$Transform2Water.play()
	pass # Replace with function body.
