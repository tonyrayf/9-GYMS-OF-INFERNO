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
@export var punch_damage_shfb : Array = [50, 25, 10, 50]

var take_damage_multi : float
@export var take_damage_multi_shfb : Array = [1, 0.3, 2, 0.3]

var punch_time : float; var punch_timer : float = 0 # in seconds
@export var punch_time_shfb : Array = [1, 2, 0.2, 1]

var kick_time : float; var kick_timer : float = 0  # in seconds
@export var kick_time_shfb : Array = [2.2, 3.5, 1, 2]

enum Mode { STRONGER, HARDER, FASTER, BETTER }
@export var current_mode : int = Mode.STRONGER

@export_group("References")
@export var health_bar : Node


func change_mode(mode: int) -> void:
	current_mode = mode
	
	speed = speed_shfb[mode]
	punch_damage = punch_damage_shfb[mode]
	take_damage_multi = take_damage_multi_shfb[mode]
	punch_time = punch_damage_shfb[mode]
	kick_time = kick_time_shfb[mode]

func mode_stronger_logic(delta: float) -> void:
	pass

func mode_harder_logic(delta: float) -> void:
	pass

func mode_faster_logic(delta: float) -> void:
	pass


func deal_damage(damage: float) -> void:
	health -= damage * take_damage_multi


func _ready() -> void:
	change_mode(Mode.FASTER)


func _process(delta: float) -> void:
	z_index = global_position.y
	
	# Health bar
	if health_bar:
		health_bar.value = lerp(health_bar.value, health / max_health, 0.2)
	
	# Death
	if health <= 0:
		queue_free()


func _physics_process(delta: float) -> void:
	# == Movement ==
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	velocity.x = speed * direction.x
	velocity.y = speed * direction.y
	
	if velocity.length() > speed:
		velocity = velocity.limit_length(speed)
	
	move_and_slide()
