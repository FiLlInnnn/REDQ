extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_game_pressed() -> void:
	_stop_all_sounds()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_exit_game_pressed() -> void:
	_stop_all_sounds()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _stop_all_sounds():
	for child in get_tree().get_root().get_children():
		_stop_audio_recursive(child)
		
		
func _stop_audio_recursive(node):
	if node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D:
		node.stop()
	for child in node.get_children():
		_stop_audio_recursive(child)
