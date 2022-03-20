extends Node2D

onready var starting_player_pos = get_node( "Player" ).global_position
const PLAYER = preload( "res://objects/Player.tscn" )
var controls = load( "res://objects/controls.gd" ).new()

#onready var passers = get_node("/root/Passers")

# Called when the node enters the scene tree for the first time.
func _ready():
#	yield($AudioStreamPlayer, "ready")
	$AudioStreamPlayer.playing = Passers.music_playing
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if( controls.toggle_music_request() ):
#		$AudioStreamPlayer.playing = !$AudioStreamPlayer.playing
	pass
	
func _input( event ):
	if( event.is_action_pressed( "toggle_music" ) ):
		$AudioStreamPlayer.playing = !$AudioStreamPlayer.playing 
		Passers.music_playing = $AudioStreamPlayer.playing


func reset():

	pass
