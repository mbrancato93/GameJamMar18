extends Node2D

onready var starting_player_pos = get_node( "Player" ).global_position
const PLAYER = preload( "res://objects/Player.tscn" )

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func reset():
#	var p = get_node( "Player" )
#	self.remove_child( p )
#	p.queue_free()
#
#	var np = load( "res://objects/Player.gd" ).new()
#	np.name = "Player"
#	self.add_child( np )
#	p.position = starting_player_pos
	get_tree().reload_current_scene()
