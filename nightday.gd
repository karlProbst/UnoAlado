extends Node
@onready var aircraft = get_node("Aircraft")
@onready var camera = get_node("CameraFollow")
@onready var sun = $DirectionalLight3D
var follow=true
var template_explosion = preload("res://Scenes/Explosion.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	aircraft.connect("crashed", Callable(self, "_on_Aircraft_crashed"))
	aircraft.connect("parked", Callable(self, "_on_Aircraft_parked"))
	aircraft.connect("moved", Callable(self, "_on_Aircraft_moved"))
	Engine.time_scale =1.0

# Caldddddddddddddled every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sun.rotate_x(delta/20)
	
	if(follow):
	
		camera.rotation=aircraft.rotation
		camera.global_transform.origin=aircraft.global_transform.origin
	else:
		camera.get_node("Camera3D2").set_fov(camera.get_node("Camera3D2").get_fov()-delta*20)
		if(camera.get_node("Camera3D2").get_fov()<80):
			Engine.time_scale=1.0
		elif(camera.get_node("Camera3D2").get_fov()<90):
			Engine.time_scale=0.45
		elif(camera.get_node("Camera3D2").get_fov()<105):
			Engine.time_scale=0.3
		camera.rotation.z=lerpf(camera.rotation.z,0,delta*5)
		
		camera.transform.origin -= camera.transform.basis.z * delta * 4.0
		
		camera.position.y+=delta*2
		camera.look_at(aircraft.global_transform.origin, Vector3.UP)
		

func _on_BtnBack_pressed():
	get_tree().change_scene_to_file("res://example/ExampleList.tscn")

func _on_Aircraft_crashed(_impact_velocity):
	var material = PhysicsMaterial.new()
	material.friction = 0.0  # Adjust this value based on your needs
	material.rough=0
	material.absorbent=false
	material.bounce=500
	aircraft.physics_material_override  = material
	
	camera.get_node("Camera3D2").set_fov(110)
	aircraft.get_node("explodedParticles").visible=true
	for child in aircraft.get_node("explodedParticles").get_children():
		if child is CPUParticles3D:
			child.emitting=true

	camera.get_node("Camera3D2").position=Vector3.ZERO
	camera.get_node("Camera3D2").rotation=Vector3.ZERO
	camera.position.y+=10
	aircraft.mass=700
	aircraft.gravity_scale=10

	follow = false
	var new_explosion = template_explosion.instantiate()
	add_child(new_explosion)
	new_explosion.global_transform.origin = aircraft.global_transform.origin
	new_explosion.explode()
	aircraft.visible=true
	#aircraft.global_transform.origin = new_explosion.global_transform.origin
	aircraft.set_script(null)
	Engine.time_scale = 0.15
	aircraft.apply_force(aircraft.get_linear_velocity()*(randi() % 10)*_impact_velocity, aircraft.rotation)
	
	aircraft.angular_velocity*=(randi() % 5)*_impact_velocity
	await get_tree().create_timer(6.0).timeout
	var __= get_tree().reload_current_scene()



