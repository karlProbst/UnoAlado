extends CharacterBody3D

# Speed parameters
var forward_speed = 20
var rotation_speed = 1
var pitch_speed = 50
var acceleration = 3
var max_speed = 30
var speed = 0
# Variables to store pitch and roll angles
var pitch_angle = 0.0
var roll_angle = 0.0
var grounded = false
func _process(delta):
	# Handle airplane controls using left thumbstick
	if is_on_floor():
		if not grounded:
			rotation.x = 0
		velocity.y -= 1
		grounded = true
	else:
		grounded = false
	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_up", "ui_down")
	var throttle_input = Input.get_action_strength("throttle_up")
	
	# Apply rotation based on thumbstick input
	rotate_y(input_dir.x * rotation_speed * delta)
	
	# Calculate acceleration based on throttle input


	# Set the velocity before calling move_and_slide
  
  
	
	# Calculate rolling based on thumbstick input
	roll_angle = lerpf(roll_angle, -input_dir.x * 50, delta * 5)
	
	# Apply pitch based on thumbstick input
	pitch_angle -= input_dir.y * pitch_speed * delta
	

	
	# Apply pitch and roll rotations
	rotation_degrees.x = pitch_angle
	rotation_degrees.z = roll_angle
	var movement = -transform.basis.z.normalized()
	
	speed += (throttle_input*acceleration)
	speed+=pitch_angle/35
	speed*=0.9999
	if(speed<0):
		speed=0
	print(pitch_angle)
	velocity = movement * - speed*delta
	
	move_and_slide()
