extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 7.0
const JUMP_VELOCITY = 5.0
const SENSITIVITY = 0.002
const HIT_STAGGER = 8.0

#bob
const BOB_FREQ = 2.0 
const BOB_AMP = 0.08
var t_bob = 0.0

#FOV variables
const BASE_FOV = 100.0
const FOV_CHANGE = 1.5

#signal
signal player_hit

var gravity = 9.8

#bullets
var bullet = load("res://entities/bullet/bullet.tscn")
var instance

var hp = 100

#walk sfx
var walk_timer := 0.0
const STEP_INTERVAL_WALK = 0.4

var is_dying = false

@onready var head = $Head
@onready var camera = $Head/Camera3D

@onready var gun_anim = $Head/Camera3D/gun2/AnimationPlayer
@onready var gun_barrel = $Head/Camera3D/gun2/RayCast3D
@onready var ami_ray = $Head/Camera3D/Aimray
@onready var aim_ray_end = $Head/Camera3D/AimRayEnd

@onready var pause_menu = $pause_menu_ui/pause_menu
@onready var dead_menu = $dead_menu_ui/dead_menu
@onready var hp_label = $player_ui/HP_label

@onready var crosshair_hit = $player_ui/TextureRect2




func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hp_label.text = str(hp) + " HP"


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	#Handle sprint
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "fwd", "bwd")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
		
		
	
	#head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	
	#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 4)
	var target_fov = BASE_FOV + FOV_CHANGE + velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	#shoot
	if Input.is_action_just_pressed("shoot"):
		_shoot_pistol()
	
	if is_dying:
		return
	
	move_and_slide()
	_handle_footsteps(delta)





func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	


func hit(dir, damage):
	
	if is_dying:
		return
	
	$sfx_hit.play()
	emit_signal("player_hit")
	hp -= damage
	hp = max(hp, 0)
	hp_label.text = str(hp) + " HP"
	
	if hp <= 0:
		die()
		is_dying = true
	else:
		velocity += dir * HIT_STAGGER

func die():
	get_tree().paused = true
	dead_menu.visible = true
	hp_label.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event.is_action_pressed("exit"):
		toggle_pause()


func toggle_pause():
	var is_paused = not get_tree().paused
	get_tree().paused = is_paused
	pause_menu.visible = is_paused  
	
	
	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  


func _shoot_pistol():
	if !gun_anim.is_playing():
		gun_anim.play("shoot")
		$Head/Camera3D/gun2/sfx_shoot.play()
		instance = bullet.instantiate()
		instance.position = gun_barrel.global_position
		get_parent().add_child(instance)
		
		instance.connect("zombie_hit", Callable(self, "_on_zombie_hit"))
		
		if ami_ray.is_colliding():
			instance.set_velocity(ami_ray.get_collision_point())
		else:
			instance.set_velocity(aim_ray_end.global_position)

func _on_zombie_hit():
	crosshair_hit.visible = true
	await get_tree().create_timer(0.05).timeout
	crosshair_hit.visible = false


func _handle_footsteps(delta):
	if is_on_floor() and velocity.length() > 0.1:
		walk_timer += delta
		
		var interval = STEP_INTERVAL_WALK
		if speed == SPRINT_SPEED:
			interval = STEP_INTERVAL_WALK * 0.5 
		
		if walk_timer >= interval:
			walk_timer = 0.0
			$sfx_walk.play()  
		
	else:
		walk_timer = 0.0
