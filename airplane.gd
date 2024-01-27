extends CharacterBody3D

# Speed parameters
var forward_speed = 20
var rotation_speed = 1
var pitch_speed = 150
var acceleration = 2
var max_speed = 1500
var speed = 0
@onready var camera = $Camera3D
var camera_x=0
# Variables to store pitch and roll angles
var pitch_angle = 0.0
var roll_angle = 0.0

# Gravity parameters
var gravity = -9.8
var current_gravity = 0
func _ready():
	camera_x = camera.rotation_degrees
func _process(delta):
	# Apply gravity that decreases as speed goes up
	camera.rotation_degrees = Vector3(camera_x.x + (pitch_angle*2),camera_x.y-(roll_angle/4),camera_x.z)
	
	# Handle airplane controls using left thumbstick
	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_up", "ui_down")
	var throttle_input = Input.get_action_strength("throttle_up")

	# Apply rotation based on thumbstick input
	rotate_y(input_dir.x * rotation_speed * delta)

	# Calculate rolling based on thumbstick input
	roll_angle = lerpf(roll_angle, -input_dir.x * 50, delta * 5)


	# Apply pitch and roll rotations
	if(!is_on_floor()):	
		var gravity_smoothness = 0.1
		var target_gravity = gravity - clamp(speed / (max_speed/4), 0.0, 10.0)
		current_gravity = lerpf(current_gravity, target_gravity, min(1.0, gravity_smoothness * delta))	
		pitch_angle = -(input_dir.y * pitch_speed * delta)
	
		speed *= 0.9995
	else:
		pitch_angle = -(input_dir.y * pitch_speed * (speed/max_speed) * delta)/8
		speed *= 0.999
		current_gravity=0
		roll_angle=0
	
	
	# Calculate movement
	rotation_degrees.x += pitch_angle
	rotation_degrees.z = roll_angle
	# Calculate movement
	var movement = -transform.basis.z.normalized()

	# Calculate speed
	speed += throttle_input * acceleration
	rotation_degrees.x = clamp(rotation_degrees.x,-55,55)
	
	if(pitch_angle>0) and !is_on_floor():
		speed += pitch_angle/2
	else:
		speed += pitch_angle / 15 
	speed -= abs(roll_angle/10)
	
	# Limit speed
	speed = clamp(speed, 0, max_speed)

	# Set velocity
	velocity = movement * -speed * delta
	velocity.y += current_gravity

	# Move and slide
	move_and_slide()
