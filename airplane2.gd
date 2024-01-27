extends CharacterBody3D

# Speed parameters
var forward_speed = 20
var rotation_speed = 1
var pitch_speed = 50
var acceleration = 2
var max_speed = 1500
var speed = 0

# Variables to store pitch and roll angles
var pitch_angle = 0.0
var roll_angle = 0.0

# Gravity parameters
var gravity = -9.8
var current_gravity = 0

func _process(delta):
	# Apply gravity that decreases as speed goes up
	
	# Handle airplane controls using left thumbstick
	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_up", "ui_down")
	var throttle_input = Input.get_action_strength("throttle_up")

	# Apply rotation based on thumbstick input
	rotate_y(input_dir.x * rotation_speed * delta)

	# Calculate rolling based on thumbstick input
	roll_angle = lerp(roll_angle, -input_dir.x * 50, delta * 5)

	if is_on_floor():
		# Raycast to detect terrain beneath the plane
		var ground_normal = $RayCast3D.get_collision_normal()
	
	else:
		# Gradually increase pitch action with speed
		pitch_angle = (input_dir.y * pitch_speed * delta)

	# Apply pitch and roll rotations
	var gravity_smoothness = 0.1
	var target_gravity = gravity - clamp(speed / (max_speed / 4), 0.0, 10.0)
	current_gravity = lerpf(current_gravity, target_gravity, min(1.0, gravity_smoothness * delta))

	rotation_degrees.x += pitch_angle
	rotation_degrees.z = roll_angle

	speed *= 0.9995

	# Calculate movement
	var movement = -transform.basis.z.normalized()

	# Calculate speed
	speed += throttle_input * acceleration
	speed += pitch_angle / 20  # You can adjust this factor for more or less sensitivity to pitch

	# Limit speed
	speed = clamp(speed, 0, max_speed)

	# Set velocity
	velocity = movement * -speed * delta
	velocity.y += current_gravity

	# Move and slide
	move_and_slide()
	
