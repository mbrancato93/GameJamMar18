extends Node2D

var button_presses := -1
var letter_ind := 0
var curr_text := ""
var font_path := "res://fonts/BERNHC.TTF"

var prefix := ""
var postfix := ""

var text_list := [ "All life is simply a cycle of matter.", 
					"For this water sprite simply seeks to complete it's cycle. ",
					"From the afterlife to reincarnation... " ]

var word_delay := 50
onready var last_display = OS.get_ticks_msec()

onready var dynamic_font = DynamicFont.new()

#onready var passers = get_node( "/root/Passers" )

# Called when the node enters the scene tree for the first time.
func _ready():
	dynamic_font.font_data = load( font_path )
	dynamic_font.size = 20
	$RichTextLabel.set( "custom_fonts/font", dynamic_font )
	Passers.music_playing = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( (OS.get_ticks_msec() - last_display ) > word_delay && button_presses >= 0 ):
#		var hld = text_list[button_presses].split(" ")
		var substr = text_list[button_presses]
		if( letter_ind < substr.length() ):
			curr_text += substr[letter_ind]
			$RichTextLabel.text = curr_text
#			$RichTextLabel.text += " "
			letter_ind += 1
			last_display = OS.get_ticks_msec()
	pass


func _on_TextureButton_button_up():
	pass # Replace with function body.
	
func _input( event ):
	if( event.is_action_pressed( "toggle_music" ) ):
		$AudioStreamPlayer.playing = !$AudioStreamPlayer.playing
		Passers.music_playing = $AudioStreamPlayer.playing
	if( event.is_action_pressed( "shoot" ) ):
		print( "Button pressed" )
	
		# check if button press should just finish text
	#	var hld = text_list[button_presses].split( " " )
		var substr = text_list[button_presses]
		if( letter_ind < substr.length() && button_presses >= 0 ):
			curr_text = substr
			$RichTextLabel.text = prefix + curr_text + postfix
			letter_ind = substr.length()
			return
			
		button_presses += 1
		letter_ind = 0
		$RichTextLabel.text = ""
		curr_text = ""
		
		if( button_presses >= text_list.size() ):
			get_tree().change_scene("res://scenes/World.tscn")
		pass # Replace with function body.


func _on_TextureButton_pressed():
	print( "Button pressed" )
	
	# check if button press should just finish text
#	var hld = text_list[button_presses].split( " " )
	var substr = text_list[button_presses]
	if( letter_ind < substr.length() && button_presses >= 0 ):
		curr_text = substr
		$RichTextLabel.text = prefix + curr_text + postfix
		letter_ind = substr.length()
		return
		
	button_presses += 1
	letter_ind = 0
	$RichTextLabel.text = ""
	curr_text = ""
	
	if( button_presses >= text_list.size() ):
		get_tree().change_scene("res://scenes/World.tscn")
	pass # Replace with function body.
