extends Node3D

const SPEED = 200.0

var velocity = Vector3.ZERO

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ray.enabled = true
	await get_tree().physics_frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta
	if ray.is_colliding():
		mesh.visible = false
		particles.emitting = true
		ray.enabled = false
		if ray.get_collider().is_in_group("enemy"):
			ray.get_collider().hit()
		await get_tree().create_timer(1.0).timeout
		queue_free()
		
	print("Ray enabled:", ray.enabled)
	print("Ray cast_to:", ray.cast_to)
	print("Ray colliding:", ray.is_colliding())

func set_velocity(target):
	look_at(target)
	velocity = position.direction_to(target) * SPEED


func _on_timer_timeout():
	queue_free()
