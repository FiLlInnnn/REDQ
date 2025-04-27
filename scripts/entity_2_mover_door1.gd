extends Node3D

@export var move_distance := 3.0
@export var move_time := 1.0
@export var targetname := "door1"

var is_open := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mesh_instance = $entity_2_mesh_instance
	if not mesh_instance or not mesh_instance.mesh:
		push_error("Chybí mesh nebo MeshInstance3D!")
		return
	
	var shape = mesh_instance.mesh.create_trimesh_shape()
	var body = StaticBody3D.new()
	var collision = CollisionShape3D.new()
	collision.shape = shape

	body.name = "DoorBody"
	body.add_child(collision)
	add_child(body)
	
	body.collision_layer = (1 << 0) | (1 << 1)
	body.collision_mask = (1 << 0) | (1 << 1)
	
	add_to_group("movers")
	
func _process(delta: float) -> void:
	pass


func open():
	if is_open:
		return
	is_open = true
	
	$door_sfx.play()
	var door_body = get_node_or_null("DoorBody")
	if door_body:
		door_body.collision_layer = 1 << 1 
		door_body.collision_mask = 0   
	
	var tween = create_tween()
	var target_pos = global_position + Vector3.UP * move_distance
	tween.tween_property(self, "global_position", target_pos, move_time)
