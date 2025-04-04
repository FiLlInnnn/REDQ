extends CharacterBody3D

var player = null
var state_machine
var player_detected = false
var health = 10
var damage = 15

const SPEED = 3.0
const ATTACK_RANGE = 2
const DETECTION_RADIUS = 10.0

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
@onready var detection_area = $Area3D



func _ready():
	player = get_node(player_path)
	print("Player path:", player_path)
	print("Player found:", player)
	state_machine = anim_tree.get("parameters/playback")
	 
	detection_area.body_entered.connect(_on_player_entered)
	
	detection_area.body_exited.connect(_on_player_exited)
	 

func _process(delta):
	
	if not player_detected:
		velocity =Vector3.ZERO
		return
	
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"Attack":
			velocity = Vector3.ZERO
	
	#Navigation
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z ), Vector3.UP)
	
	
	#Conditions
	anim_tree.set("parameters/conditions/attack",  _target_in_range())
	anim_tree.set("parameters/conditions/run", !_target_in_range())
	anim_tree.set("parameters/Attack/scale", -1)
	
	
	move_and_slide()


func _target_in_range():
	if anim_tree.get("parameters/conditions/attack"):
		return global_position.distance_to(player.global_position) < 0.3 * ATTACK_RANGE
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _on_player_entered(body):
	if body.name == "player":
		player_detected = true
		print("Player entered detection area")

func _on_player_exited(body):
	if body.name == "player":
		player_detected = false

func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir, damage)


func _on_area_3d_body_part_hit(dam):
	health -= dam
	if  health <= 0:
		velocity = Vector3.ZERO
		nav_agent.set_target_position(global_transform.origin)
		set_process(false)
		anim_tree.set("parameters/conditions/dead", true)
		await get_tree().create_timer(4.0).timeout
		queue_free()
	
