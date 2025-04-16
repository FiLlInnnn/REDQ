extends Node3D

var triggered := false
@export var target := "door2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mesh_instance = $entity_4_mesh_instance
	if not mesh_instance or not mesh_instance.mesh:
		push_error("Chybí mesh nebo MeshInstance3D!")
		return
	
	mesh_instance.visible = false
	
	var shape = mesh_instance.mesh.create_trimesh_shape()
	var area = Area3D.new()
	var collision = CollisionShape3D.new()
	collision.shape = shape
	
	area.add_child(collision)
	add_child(area)
	
	
	
	area.body_entered.connect(_on_body_entered)
	

func _on_body_entered(body):
	if triggered:
		return 
	if body.name == "player":
		triggered = true
		print("TRIGGERED!")
		for mover in get_tree().get_nodes_in_group("movers"):
			if mover.targetname == target:
				mover.open()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
