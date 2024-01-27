extends Sprite2D

@onready var shader_material = get_material()
var time = 1.5
var speed= 0.95
func _ready():
   
	# Now you have the ShaderMaterial and can use it as needed
	if shader_material is ShaderMaterial:
		# Perform actions with the shader material
		print("ShaderMaterial found!")

		# You can access and modify shader parameters
		shader_material.set_shader_parameter("iTime", 0.5)  # Example modification
	else:
		print("No ShaderMaterial found on this node.")
func _process(delta):
	speed+=delta/560
	time-= delta/50

	if(time<0.975):
		time=.975
		speed+=delta/100
		
	# Now you have the ShaderMaterial and can use it as needed
	if shader_material is ShaderMaterial:
		# You can access and modify shader parameters
		shader_material.set_shader_parameter("formuparam", time)  # Ex
		shader_material.set_shader_parameter("tile", speed) 
