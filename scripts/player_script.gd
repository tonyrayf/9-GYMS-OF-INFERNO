extends CharacterBody2D


# Разделение переменных по массиву идет вот так - Stronger/Harder/Faster/Better
@export_group("Movement")
@export var speed : float = 480
@export var speed_shfb : Array = [470, 420, 520, 520]
@export var S : float = 520
@export var last_direction : Vector2 = Vector2(1, 1)
@export var direction := last_direction

@export_group("Vitals")
@export var max_health : float = 100.0
@export var health : float = max_health
@export var stamina : float = 50.0
@export var ultimate_charge : float = 0.0

@export_group("Stats")
var punch_damage : float
@export var punch_damage_shfb : Array = [80, 50, 25, 60]

var punch_radius : float = 60 # грубо говоря длина ручки
@export var punch_radius_shfb : Array = [80, 70, 60, 75]

var punch_collision_radius : float
@export var punch_collision_radius_shfb : Array = [70, 60, 50, 70]

var take_damage_multi : float
@export var take_damage_multi_shfb : Array = [1, 0.3, 2, 0.3]

var punch_time : float; var punch_timer : float = 0 # время между ударами кулаками
@export var punch_time_shfb : Array = [1, 2, 0.2, 1]

var kick_time : float; var kick_timer : float = 0 # время между пинком
@export var kick_time_shfb : Array = [2.2, 3.5, 1, 2]

enum Mode { STRONGER, HARDER, FASTER, BETTER }
@export var current_mode : int = Mode.STRONGER

@export_group("References")
@export var health_bar : Node

@export_group("Visual params")
@export var stronger_punch_shake_amplitude : float = 40
@export var stronger_punch_shake_duration : float = 0.1
@export var stronger_punch_shake_magnitude : float = 1.4


@onready var damage_hitbox_scene := preload("res://scenes/damage_hitbox.tscn")


func change_mode(mode: int) -> void:
	current_mode = mode
	
	speed = speed_shfb[mode]
	punch_damage = punch_damage_shfb[mode]
	punch_collision_radius = punch_collision_radius_shfb[mode]
	take_damage_multi = take_damage_multi_shfb[mode]
	punch_time = punch_time_shfb[mode]
	kick_time = kick_time_shfb[mode]

func mode_stronger_logic(delta: float, punched: bool) -> void:
	if punched and Global.main_camera:
		Global.main_camera.shake(
			stronger_punch_shake_amplitude,
			stronger_punch_shake_duration,
			stronger_punch_shake_magnitude
		)

func mode_harder_logic(delta: float) -> void:
	pass

func mode_faster_logic(delta: float) -> void:
	pass
	
func mode_better_logic(delta: float, punched: bool) -> void:
	if punched and Global.main_camera:
		Global.main_camera.shake(
			stronger_punch_shake_amplitude,
			stronger_punch_shake_duration,
			stronger_punch_shake_magnitude
		)


func deal_damage(damage: float) -> void:
	health -= damage * take_damage_multi


func _ready() -> void:
	change_mode(Mode.STRONGER)
	Global.player = self


func _process(delta: float) -> void:
	z_index = global_position.y
	
	# Health bar
	if health_bar:
		health_bar.value = lerp(health_bar.value, health / max_health, 0.2)
	
	# Death
	if health <= 0:
		queue_free()
	
	# == Attacks ==
	
	# Punch
	if punch_timer > 0:
		punch_timer = max(punch_timer - delta, 0)
	
	var punched : bool = false
	if Input.is_action_just_pressed("attack_punch") and punch_timer <= 0:
		punch_timer = punch_time
		
		var mouse_pos := get_global_mouse_position()
		
		var direction = (mouse_pos - global_position).normalized()
		var spawn_pos = global_position + direction * punch_radius
		
		punched = Global.spawn_damage_hitbox(
			punch_damage,
			spawn_pos,
			Global.Attacker.PLAYER,
			punch_collision_radius
		)
	
	# Выполняем логику SHFB
	match current_mode:
		Mode.STRONGER: mode_stronger_logic(delta, punched)
		Mode.HARDER: mode_harder_logic(delta)
		Mode.FASTER: mode_faster_logic(delta)
		Mode.BETTER: mode_better_logic(delta, punched)


func _physics_process(delta: float) -> void:
	# == Movement ==
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	velocity.x = speed * direction.x
	velocity.y = speed * direction.y
	
	if velocity.length() > speed:
		velocity = velocity.limit_length(speed)
	
	move_and_slide()
