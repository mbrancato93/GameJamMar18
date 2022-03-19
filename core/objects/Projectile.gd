extends Area2D
class_name Projectile

var g = load( "res://objects/GLOBALS.gd" )

var speed = 100

func _ready():
	$AnimationPlayer.play( "shot" )
	pass

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Projectile_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
