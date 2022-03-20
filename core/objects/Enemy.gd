extends BasicBody

enum {FIRE,ASH,DEAD}
var state := FIRE setget setState
var transitioning := false
var facing := -1
const speed : int = 30

func setState( _val ):
	transitioning = true
	var state_transition_anim := "none"
	
	if( state == FIRE && _val == ASH ):
		state_transition_anim = "FIRE2ASH"
	elif( state == ASH && _val == FIRE ):
		state_transition_anim = "ASH2FIRE"
	elif( state == ASH && _val == DEAD ):
		state_transition_anim = "ASH2DEAD"
	elif( state == ASH && _val == ASH ):
		state_transition_anim = "none"
	elif( state == FIRE && _val == FIRE ):
		state_transition_anim = "none"
	else:
		assert( 1 == 0 )
		
	if( state_transition_anim != "none" ):
		$AnimationPlayer.play( state_transition_anim )
	else:
		transitioning = false
#		$AnimationPlayer.disconnect( "animation_finished", self, "transition_end" )
	state = _val
	if( state == DEAD ):
		$CollisionShape2D.disabled = true
		$Area2D.get_node("CollisionShape2D").disabled = true

func transition_end( _val = null ):
	transitioning = false
#	$AnimationPlayer.disconnect( "animation_finished", self, "transition_end" )

# Called when the node enters the scene tree for the first time.
func _ready():
	debug.period = 1000
	$AnimationPlayer.connect( "animation_finished", self, "transition_end" )
	pass # Replace with function body.

func _physics_process(delta):
	if( transitioning ):
		return
	# add gravity
	var velocity := Vector2( 0, 0 )
	velocity[1] += g.GRAVITY / mass
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
#		debug.DEBUG("Collided with: %s" % collision.collider.name)
		if( collision.collider.name == "EnemyStopTiles" ):
			debug.DEBUG( "Hit bounding wall" )
			facing *= -1
#		if( collision.collider.name == "Player" ):
#			get_parent().get_node( collision.collider.name ).hit( "Enemy" )
#			facing *= -1
			
	if( state == FIRE ):
		$AnimationPlayer.play( "enemy_idle" )
	elif( state == ASH ):
		$AnimationPlayer.play( "ash_enemy_idle" )
	$Sprite.scale.x = -1*facing

	velocity[0] += facing * speed
	
	velocity = move_and_slide( velocity, g.upVec )
	
func dead_transition( _val = null ):
	queue_free()
	
func hit( _val ):
	if( state == ASH ):
#		queue_free()
		$AnimationPlayer.disconnect( "animation_finished", self, "transition_end" )
		$AnimationPlayer.connect( "animation_finished", self, "dead_transition" )
		setState( DEAD )
		return
	setState( ASH )


func _on_Area2D_body_entered(body):
	if( body.name == "Player" && state != DEAD ):
		body.hit( "Enemy" )
		facing *= -1
		pass
	pass # Replace with function body.
