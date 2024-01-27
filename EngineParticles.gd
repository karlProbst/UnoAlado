extends Node3D



# Any node can receive the "update_interface" signals from the Airplane modules
# This can be used to show realtime representations using the same data
# as the UI controls



func _on_Engine_update_interface(values):
	var power = values["engine_power"]
	scale.z = 0.05+power
	mat.albedo_color = lerp(Color.BLACK, Color.WHITE, power)
