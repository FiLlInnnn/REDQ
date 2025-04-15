extends Node3D

var toggle = false

func _input(event: InputEvent):
	if Input.is_action_just_pressed("flashlight"):
		toggle = !toggle


func _process(delta):
	if toggle == true:
		$SpotLight3D.light_energy = 10
	else:
		$SpotLight3D.light_energy = 0
