extends Camera2D

var debug = load( "res://objects/debug.gd" ).new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	debug.verbosity = 0
	debug.period = 1000
	self.zoom.x = 0.5
	self.zoom.y = 0.5
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	var player_pos := Vector2( 0, 0 )
	var mp = get_parent().get_node( "Player" )
	if( is_instance_valid( mp ) ):
		player_pos = get_parent().get_node( "Player" ).global_position
#	debug.DEBUG( "Player pos: %f %f" % [ player_pos[0], player_pos[1] ] )
#	debug.DEBUG( "Camera Pos: %f %f" % [ self.global_position[0], self.global_position[1] ] )
	
	var vps = get_viewport().size
	debug.DEBUG( "Viewport Size: %f %f" % [ vps[0], vps[1] ] )
	
	# handle smoothing action of camera,
	self.position[0] = player_pos[0]
	pass
	
