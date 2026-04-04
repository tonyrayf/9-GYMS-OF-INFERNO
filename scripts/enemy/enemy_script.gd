extends CharacterBody2D


@export_group("Movement")
@export var patrol_speed: float = 150.0
@export var attack_speed: float = 300.0
@export var waiting_speed: float = 300.0

var current_speed

@export_group("Stats")
@export var health: float = 100.0
@export var damage: float = 1.0
@export var attack_cooldown: float = 1.0
@export var attack_range: float = 200.0

var look_vector
var move_direction
var personal_space

func deal_damage(damage: float) -> void:
	health -= damage


func _process(delta: float,personal_space: float=100) -> void:
	look_vector = velocity.normalized()
	z_index = global_position.y


var target_pos
var moving

func move_to(target: Vector2,space: float = 100) -> void:
	target_pos = target
	personal_space = space
	
	if global_position.distance_to(target_pos) < personal_space:
			moving = false
			velocity = Vector2.ZERO
			return
	
	moving = true
	
func _physics_process(_delta: float) -> void:
	if moving:
		if global_position.distance_to(target_pos) < personal_space:
			moving = false
			velocity = Vector2.ZERO
			return
		move_direction = (target_pos - global_position).normalized()
		velocity = move_direction * current_speed
		move_and_slide()
