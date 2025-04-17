extends SpotLight3D

func _ready():
 flash()

func flash():
 light_energy = randf_range(10.0, 60.0)
 await get_tree().create_timer(randf_range(0.05, 0.1)).timeout
 flash()
