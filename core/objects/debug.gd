extends Node2D
class_name debug

var verbosity := 2 setget setVerb
var period := -1 setget setPeriod
var last_call := 0 setget ,forbidden

func forbidden( _val = null ):
	print_debug( "Attempting to set last_call" )
	pass

func setVerb( param: int ):
	assert( param >= 0 && param <= 3) 
	verbosity = param
	
func setPeriod( param ):
	period = param

func DEBUG( str_in: String ):
	# get curr call time
	var curr_call = OS.get_ticks_msec()
	
	if( last_call != -1 && ( curr_call - last_call ) > period ):
		if( verbosity > 0 ):
			var tm := OS.get_ticks_msec()
			print_debug( "[%f]%s" % [ tm, str_in ] )
			
		if( verbosity > 1 ):
			print_stack()
		last_call = curr_call
