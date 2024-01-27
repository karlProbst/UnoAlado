extends Control

var money = 0
var distance = 0.0
var initialPos
@onready var uiMoney = get_node("Money")
@onready var uiDistance = get_node("Distance")
@onready var aircraft = get_parent().get_node("Aircraft")
# Called when the node enters the scene tree for the first time.
func _ready():
	initialPos=aircraft.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	uiMoney.text=str(money)+",00"
	uiDistance.text=str(distance)+" m"
	# Assuming you have two Spatial nodes named node1 and node2
	distance = int(aircraft.position.distance_to(initialPos))
	

func _on_button_shop_pressed():
	get_node("Shop").visible=!get_node("Shop").visible
	
func _on_button_upgrade_fuel_pressed():
	pass # Replace with function body.

func _on_button_upgrade_engine_pressed():
	pass # Replace with function body.

func _on_button_upgrade_aero_pressed():
	pass # Replace with function body.
