extends KinematicBody2D
class_name BasicBody

var debug = load( "res://objects/debug.gd" ).new()
var g = load( "res://objects/GLOBALS.gd" ).new()
var controls = load( "res://objects/controls.gd" ).new()

var mass := 1 setget setMass
var curr_forces := Vector2( 0, 0 ) setget setVec
var velocity := Vector2( 0, 0 ) setget setVel
var damping := 0 setget setDamping

var UP := Vector2( 0, -1 )

func setMass( _val = null ):
	debug.DEBUG( "Setting mass: %f" % _val )
	mass = _val
	pass

func setVec( _val = null ):
	debug.DEBUG( "Setting force: %f" % _val )
	curr_forces = _val
	pass

func setVel( _val = null ):
	debug.DEBUG( "Seting vel: %f" % _val )
	velocity = _val
	pass

func setDamping( _val = null ):
	debug.DEBUG( "Setting damping: %f" % _val )
	damping = _val
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	curr_forces = Vector2( 0, 0 )
	pass

func _physics_process(delta):
	assert( is_instance_valid( debug ) )
