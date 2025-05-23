extends Control

@onready var options_menu = $options_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_options_pressed() -> void:
	print("Kliknuto na Options v Main Menu")
	$VBoxContainer.hide()
	$Label.hide()
	options_menu.open([$VBoxContainer, $Label])


func _on_exit_game_pressed() -> void:
	get_tree().quit()
