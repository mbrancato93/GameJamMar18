extends Area2D
class_name Projectile

var g = load( "res://objects/GLOBALS.gd" )

var speed = 100
var start_x = 0

func _ready():
	$AnimationPlayer.play( "shot" )
	pass

func _physics_process(delta):
	position += transform.x * speed * delta
	if( abs( position[0] - start_x[0] ) >= 100 ):
		queue_free()

func _on_Projectile_body_entered(body):
	if body.is_in_group("Enemies"):
#		body.queue_free()
		body.hit( "Projectile" )
	queue_free()
