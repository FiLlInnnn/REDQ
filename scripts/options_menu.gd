extends Control

@onready var master_slider = $MarginContainer/VBoxContainer/masterV
@onready var music_slider = $MarginContainer/VBoxContainer/musicV
@onready var sfx_slider = $MarginContainer/VBoxContainer/SFX

var previous_menus = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Options Menu je připravené, ale skryté.")
	master_slider.value = GlobalOptions.get_master_volume() * 100
	music_slider.value = GlobalOptions.get_music_volume() * 100
	sfx_slider.value = GlobalOptions.get_sfx_volume() * 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open(menus: Array):
	print("Opening Options Menu from:", menus)
	for menu in menus:
		if menu:
			print("Hiding previous menu:", menu)
			menu.hide()
			previous_menus.append(menu) 
	
	visible = true
	z_index = 10
	print("✅ Options Menu je nyní viditelné:", visible)
	
	if get_parent() == null:
		print("❌ ERROR: OptionsMenu nemá parent! Nemůže se zobrazit!")



func _on_master_v_value_changed(value: float) -> void:
	GlobalOptions.set_master_volume(value / 100.0)


func _on_music_v_value_changed(value: float) -> void:
	GlobalOptions.set_music_volume(value / 100.0)


func _on_sfx_value_changed(value: float) -> void:
	GlobalOptions.set_sfx_volume(value / 100.0)




func _on_back_pressed() -> void:
	print("Zavírám Options Menu, vracím se na předchozí menu:", previous_menus)
	hide()
	for menu in previous_menus:
		if menu:
			menu.show()
			print("Předchozí menu je teď viditelné:", menu)
	
	previous_menus.clear()
