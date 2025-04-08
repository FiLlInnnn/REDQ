extends Node3D

const SPEED = 200.0
const LIFETIME = 1.0
const RAY_LENGTH = 2.0

var velocity = Vector3.ZERO
var already_hit = false

signal zombie_hit

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(LIFETIME).timeout
	queue_free()

	#ray.enabled = true
	#await get_tree().physics_frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#position += transform.basis * Vector3(0, 0, -SPEED) * delta
	#if ray.is_colliding():
		#mesh.visible = false
		#particles.emitting = true
		#ray.enabled = false
		#if ray.get_collider().is_in_group("enemy"):
			#ray.get_collider().hit()
		#await get_tree().create_timer(1.0).timeout
		#queue_free()
	
	var direction = -transform.basis.z
	var move_amount = direction * SPEED * delta
	var from = global_transform.origin
	var to = from + direction * SPEED * delta * 2.0

	var space_state = get_world_3d().direct_space_state

	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to
	query.exclude = [self]
	query.collision_mask = 2 
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)

	if result:
		_handle_hit(result)
	else:
		position += move_amount
	
	#print("Ray enabled:", ray.enabled)
	#print("Ray cast_to:", ray.cast_to)
	#print("Ray colliding:", ray.is_colliding())

func _handle_hit(result):
	print("Zásah!", result.collider)
	if already_hit: return
	already_hit = true

	mesh.visible = false
	particles.global_position = result.position
	particles.emitting = true

	if result.collider.is_in_group("enemy"):
		emit_signal("zombie_hit")
		result.collider.hit()


	await get_tree().create_timer(0.5).timeout
	queue_free()

func set_velocity(target):
	look_at(target)
	velocity = position.direction_to(target) * SPEED


func _on_timer_timeout():
	queue_free()
