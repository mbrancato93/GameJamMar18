extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play( "action" )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Condenser_body_entered(body):
	if( body.name == "Player" && body.state == 1 ):
		body.setState( 0 );
#		$AnimationPlayer.play( "action" )
		pass
	pass # Replace with function body.
