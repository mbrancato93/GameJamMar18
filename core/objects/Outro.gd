extends Node2D

var font_path := "res://fonts/BERNHC.TTF"
onready var dynamic_font = DynamicFont.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	dynamic_font.font_data = load( font_path )
	dynamic_font.size = 20
	$RichTextLabel.set( "custom_fonts/font", dynamic_font )
	$RichTextLabel.text = "Made by Michael Brancato and Kurtis Rose\n with Godot 3.4.3"
	$RichTextLabel.align = HALIGN_CENTER
	$RichTextLabel.valign = VALIGN_CENTER
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	get_tree().change_scene("res://scenes/World.tscn")
	pass # Replace with function body.
