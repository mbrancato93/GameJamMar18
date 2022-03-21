extends Area2D

var repeats := 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect( "animation_finished", self, "portal_done" )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func portal_done( _val = null ):
	if( repeats == 2 ):
		$AudioStreamPlayer.play()
	if( repeats ):
		$AnimationPlayer.play( "trigger" )
		repeats -= 1
		return
	$AnimationPlayer.disconnect( "animation_finished", self, "transition_end" )
#	get_parent().reset()
	get_tree().change_scene("res://scenes/Outro.tscn")
	pass


func _on_Portal_body_entered(body):
	if( body.name == "Player" && body.state != 1 ):
		body.freeze = true
		$AnimationPlayer.play( "trigger" )
	pass # Replace with function body.
