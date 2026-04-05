extends CharacterBody2D

@export_group("Movement")
@export var patrol_speed: float = 150.0
@export var attack_speed: float = 300.0
@export var waiting_speed: float = 300.0
@export var max_speed:float = 600.0
@export var acceleration:float = 5.0

var current_speed
var initial_position

@export_group("Stats")
@export var health: float = 100.0
@export var damage: float = 1.0
@export var attack_cooldown: float = 1.0
@export var attack_range: float = 200.0

var max_health
var look_vector
var move_direction
var personal_space

func _ready() -> void:
	initial_position = global_position
	max_health = health

func deal_damage(damage: float) -> void:
	print(health," NOW")
	health -= damage


func _process(delta: float) -> void:
	look_vector = velocity.normalized()
	z_index = global_position.y


var target_pos
var moving
var inertia

func move_to(target: Vector2,space: float = 100,inert: bool = false) -> void:
	target_pos = target
	personal_space = space
	inertia = inert
	
	if global_position.distance_to(target_pos) < personal_space:
			moving = false
			velocity = Vector2.ZERO
			return
	
	moving = true
	
func _physics_process(_delta: float) -> void:
	if not inertia:
		if moving:
			if global_position.distance_to(target_pos) < personal_space:
				moving = false
				velocity = Vector2.ZERO
				return
			move_direction = (target_pos - global_position).normalized()
			velocity = move_direction * current_speed
			move_and_slide()
	else:
		var target_velocity = Vector2.ZERO
		
		if moving:
			if global_position.distance_to(target_pos) < personal_space:
				moving = false
			else:
				move_direction = (target_pos - global_position).normalized()
				target_velocity = move_direction * current_speed
		velocity = velocity.move_toward(target_velocity, 500 * _delta)
		if velocity.length() > 0.1:
			move_and_slide()
			
func spawn_ranged_attack(attack_sprite: Sprite2D,damage: float,position: Vector2,attack_fly_duration: float,on_done: Callable=Callable()) -> void:
	attack_sprite.global_position = self.global_position 
	var tween = create_tween().bind_node(attack_sprite)
			
	tween.tween_callback(attack_sprite.show)
	tween.tween_property(attack_sprite, "global_position", position,attack_fly_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(attack_sprite, "rotation_degrees", 360.0, attack_fly_duration).as_relative()
	tween.parallel().tween_property(attack_sprite, "scale", Vector2(2.0, 2.0), attack_fly_duration/2).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(attack_sprite, "scale", Vector2(1.0, 1.0), attack_fly_duration/2).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(attack_sprite.hide)
	tween.tween_property(attack_sprite, "position", Vector2.ZERO, 0.0)
	
	if not on_done.is_null():
		tween.finished.connect(on_done)
		
	await tween.finished
