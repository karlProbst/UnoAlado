# This script is just an example of one way to implement a control module
# the way input is handled here is by no means a requirement whatsoever
# You can (and are actually expected to) modify this or write your own module

extends AircraftModule
class_name AircraftModule_ControlSteering

@export var ControlActive: bool = true
@onready var Rudder = get_node("../MovingParts/Rudder")
@onready var AileronLeft  = get_node("../MovingParts/AileronLeft")
@onready var AileronRight  = get_node("../MovingParts/AileronRight")
var input_dir
# There should be only one steering and one steering control in the aircraft
var rot_y = 0.0
var steering_module = null
var axis_y = 0.0
func _ready():
	ReceiveInput = true


func setup(aircraft_node):
	aircraft = aircraft_node
	steering_module = aircraft.find_modules_by_type("steering").pop_front()
	print("steering found: %s" % str(steering_module))
func _process(delta):
	input_dir = Input.get_vector("ui_right", "ui_left", "ui_up", "ui_down")
	var look_dir = Input.get_vector("look_right", "look_left", "look_up", "look_down")
	steering_module.set_z(-(input_dir.x)/5)
		# Adjust the sensitivity factor to control the strength of the effect
	var rot_y = 0.0
	if(input_dir.y>0):
		rot_y = (input_dir.y*10)*(input_dir.y*10)*1.7
	else:
		rot_y = -(input_dir.y*10)*(input_dir.y*10)
	rot_y/=20
	
	steering_module.set_x(rot_y)
	var anal_y = 0.0
	if Input.is_action_pressed("look_left"):
		anal_y-=1
	if Input.is_action_pressed("look_right"):
		anal_y+=1
	if(anal_y>1):
		anal_y=1
	if(anal_y<-1):
		anal_y=-1
	#anal_y  = lerpf(anal_y,look_dir.x,delta*4)
	steering_module.set_y(-anal_y)
	
	#if Input.is_key_pressed(KEY_Q):
	#	rot_y = 0.5
	#elif Input.is_key_pressed(KEY_E):
	#	rot_y = -0.5
	#else:
	#	rot_y = 0.0
	Rudder.rotation.y = lerp(Rudder.rotation.y, anal_y-1.7, delta*5.0)
	AileronLeft.rotation.z = lerp(AileronLeft.rotation.z, -input_dir.x-1.65, delta*5.0)
	AileronRight.rotation.z = lerp(AileronRight.rotation.z, input_dir.x-1.65, delta*5.0)
func receive_input(event):
	if (not steering_module) or (not ControlActive):
		return
	
	if (event is InputEventKey) and (not event.echo):
		
		
		
		# Y axis positive turns plane left
		
		if Input.is_key_pressed(KEY_Q):
			axis_y = 1.0
		elif Input.is_key_pressed(KEY_E):
			axis_y = -1.0
		else:
			axis_y=0
		
