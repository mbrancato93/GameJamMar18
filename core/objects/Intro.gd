extends Node2D

var button_presses := -1
var letter_ind := 0
var text_list := [ "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ac urna euismod turpis convallis placerat. Integer non sapien eget lacus tempor accumsan quis sit amet velit. Etiam quis maximus enim. Cras posuere consectetur ipsum, id auctor ante egestas eu. Sed sit amet fringilla massa. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque ornare elit libero. Phasellus sed pulvinar dui. Proin ullamcorper aliquet auctor. Phasellus eu dui eu metus semper congue. Quisque mollis quis neque sit amet porta. Praesent libero nisi, pretium porttitor sem in, pretium efficitur sem.", 
					"Praesent a quam risus. Aliquam erat volutpat. Phasellus sagittis magna nec molestie ullamcorper. Suspendisse varius erat non mauris pellentesque, sit amet mattis sapien volutpat. Ut tincidunt sit amet urna sit amet tempus. Curabitur arcu ex, tempus vitae lectus at, hendrerit suscipit nisi. Quisque nisl lacus, venenatis eu odio in, sagittis porta nulla. Duis ut lectus eros. Suspendisse aliquam sed mauris dictum bibendum. Suspendisse feugiat iaculis lacus, vel fringilla nulla cursus vitae. Fusce fermentum varius turpis, eget laoreet orci aliquam id. Fusce non dolor ac mi convallis pulvinar. ",
					"Curabitur sit amet arcu vel ligula efficitur tempus interdum sed sem. Donec quis consectetur magna. In mollis velit augue, vitae placerat urna facilisis sit amet. Curabitur sit amet nulla efficitur, sollicitudin nisl vel, tincidunt ligula. Proin mi sem, cursus vitae maximus ac, vehicula in leo. Duis porta molestie leo ut elementum. Nulla facilisi. In pellentesque magna vel lectus faucibus, vitae iaculis nulla ullamcorper. Aenean a tellus faucibus, semper dolor id, laoreet ex. Fusce consectetur non lectus id laoreet. Maecenas pellentesque turpis luctus dui consectetur sodales semper non mauris. Nunc sollicitudin neque justo, maximus ullamcorper mauris tempor at. " ]

var word_delay := 50
onready var last_display = OS.get_ticks_msec()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( (OS.get_ticks_msec() - last_display ) > word_delay && button_presses >= 0 ):
#		var hld = text_list[button_presses].split(" ")
		var substr = text_list[button_presses]
		if( letter_ind < substr.length() ):
			$RichTextLabel.text += substr[letter_ind]
#			$RichTextLabel.text += " "
			letter_ind += 1
			last_display = OS.get_ticks_msec()
	pass


func _on_TextureButton_button_up():
	
	pass # Replace with function body.


func _on_TextureButton_pressed():
	print( "Button pressed" )
	
	# check if button press should just finish text
#	var hld = text_list[button_presses].split( " " )
	var substr = text_list[button_presses]
	if( letter_ind < substr.length() && button_presses >= 0 ):
		$RichTextLabel.text = substr
		letter_ind = substr.length()
		return
		
	button_presses += 1
	letter_ind = 0
	$RichTextLabel.text = ""
	
	if( button_presses >= text_list.size() ):
		get_tree().change_scene("res://scenes/World.tscn")
	pass # Replace with function body.