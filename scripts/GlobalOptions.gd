extends Node
 
var master_volume = 1.0
var music_volume = 1.0
var sfx_volume = 1.0
 
var config = ConfigFile.new()
 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_settings()
 
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
 
 
func set_master_volume(value):
	master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	save_settings()
 
func get_master_volume():
	return master_volume
 
func set_music_volume(value):
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	save_settings()

func get_music_volume():
	return music_volume
 
func set_sfx_volume(value):
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), linear_to_db(value))
	save_settings()
 
func get_sfx_volume():
	return sfx_volume
 
func save_settings():
	print_debug("💾 Ukládám nastavení...")
	
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save("user://settings.cfg") 
	
	var err = config.save("user://settings.cfg")  
	
	if err != OK:
		print_debug("❌ Chyba při ukládání configu!")


func load_settings():
	var err = config.load("user://settings.cfg")  
	
	if err != OK:
		print_debug("⚠️ Config nenalezen, nastavují se výchozí hodnoty na 100%.")
		master_volume = 1.0
		music_volume = 1.0
		sfx_volume = 1.0
		
		save_settings()
	else :
		master_volume = config.get_value("audio", "master_volume", 1.0)
		music_volume = config.get_value("audio", "music_volume", 1.0)
		sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))
	
	print_debug("✅ Nastavení načteno:", master_volume, music_volume, sfx_volume)
