extends Node3D

var toggle = false

func _input(event: InputEvent):
	if Input.is_action_just_pressed("flashlight"):
		$sfx_battery_switch.play()
		toggle = !toggle


func _process(delta):
	if toggle == true and $CanvasLayer/ProgressBar.value > 0 :
		$SpotLight3D.light_energy = 10
	else:
		$SpotLight3D.light_energy = 0
	
	if $SpotLight3D.light_energy == 10:
		$CanvasLayer/ProgressBar.value -= 1
	#else:
		#await get_tree().create_timer(5.0)
		#$CanvasLayer/ProgressBar.value += 1
