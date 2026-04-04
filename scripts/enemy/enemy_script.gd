extends CharacterBody2D


@export_group("Movement")
@export var speed : float = 180.0

@export_group("Stats")
@export var health: float = 100.0
@export var damage: float = 10.0
@export var attack_cooldown: float = 1.0
@export var attack_range: float = 100.0

var look_vector
var move_direction


func deal_damage(damage: float) -> void:
	health -= damage


func _process(delta: float) -> void:
	look_vector = velocity.normalized()
	z_index = global_position.y


var target_pos
var moving

func move_to(target: Vector2) -> void:
	if moving and target_pos.is_equal_approx(target):
		return
	
	target_pos = target
	moving = true
	
func _physics_process(_delta: float) -> void:
	if moving:
		move_direction = (target_pos - global_position).normalized()
		velocity = move_direction * speed
		move_and_slide()
		if global_position.distance_to(target_pos) < 5.0:
			moving = false
			velocity = Vector2.ZERO
