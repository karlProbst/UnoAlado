# This script is just an example of one way to implement a control module
# the way input is handled here is by no means a requirement whatsoever
# You can (and are actually expected to) modify this or write your own module

extends AircraftModule
class_name AircraftModule_ControlEngine



# Restricting engines to a tag can be used to control a group of engines only
# e.g. you can use RestrictEngineToTag=true and SearchTag="left" in the 
# inspector to control only the engines with the "left" tag (and a separate
# duplicate control for "right")
@export var RestrictEngineToTag: bool = false
@export var SearchTag: String = ""
@export var ControlActive: bool = true

@export var KeyStart: KeyScancodes = KeyScancodes.KEY_P
@export var KeyStop: KeyScancodes = KeyScancodes.KEY_O
@export var KeyUp: KeyScancodes = KeyScancodes.KEY_F
@export var KeyDown: KeyScancodes = KeyScancodes.KEY_V
@export var KeyMax: KeyScancodes = KeyScancodes.KEY_3
@export var KeyMid: KeyScancodes = KeyScancodes.KEY_2
@export var KeyMin: KeyScancodes = KeyScancodes.KEY_1
var engine=0
var engine_modules = []
@onready var engineParticles = get_node("EngineParticles")

func _ready():
	ReceiveInput = true
	
func setup(aircraft_node):
	aircraft = aircraft_node
	if RestrictEngineToTag:
		engine_modules = aircraft.find_modules_by_type_and_tag("engine", SearchTag)
	else:
		engine_modules = aircraft.find_modules_by_type("engine")
	print("engines found: %s" % str(engine_modules))
func _process(delta):
	
	var throttle_input = Input.get_action_strength("throttle_up")
	
	send_to_engines("engine_set_power", [throttle_input])
	
func receive_input(event):
	if event.is_action_pressed("ui_accept"):
		if(engine==0):
			send_to_engines("engine_start")
			engineParticles.emitting=true
			engine=1
		else:
			send_to_engines("engine_stop")
			engineParticles.emitting=false
			engine=0
	if not ControlActive:
		return
	
	if (event is InputEventKey) and (not event.echo):
		if event.pressed:
			match event.keycode:
				
				KeyStart:
					send_to_engines("engine_start")
				KeyStop:
					send_to_engines("engine_stop")
			

func send_to_engines(method_name: String, arguments: Array = []):
	for engine in engine_modules:
		engine.callv(method_name, arguments)