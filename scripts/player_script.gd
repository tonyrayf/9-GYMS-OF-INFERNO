extends CharacterBody2D


# Разделение переменных по массиву идет вот так - Stronger/Harder/Faster/Better
@export_group("Movement")
@export var speed : float = 480
@export var speed_shfb : Array = [470, 420, 780, 520]
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
@export var style_label : Node
@export var color_rect_faster : Node
@export var sprite : Node

@export_group("Visual params")
@export var stronger_punch_shake_amplitude : float = 40
@export var stronger_punch_shake_duration : float = 0.1
@export var stronger_punch_shake_magnitude : float = 1.4


@onready var damage_hitbox_scene := preload("res://scenes/damage_hitbox.tscn")
@onready var sprite_scale_x : float = sprite.scale.x


func change_mode(mode: int) -> void:
	current_mode = mode
	
	speed = speed_shfb[mode]
	punch_damage = punch_damage_shfb[mode]
	punch_collision_radius = punch_collision_radius_shfb[mode]
	take_damage_multi = take_damage_multi_shfb[mode]
	punch_time = punch_time_shfb[mode]
	kick_time = kick_time_shfb[mode]
	
	Engine.time_scale = 1.0
	
	match mode:
		Mode.STRONGER:
			style_label.text = "STRONGER"
			toggle_faster_shader(false)
		
		Mode.HARDER:
			style_label.text = "HARDER"
			toggle_faster_shader(false)
		
		Mode.FASTER:
			style_label.text = "FASTER"
			toggle_faster_shader(true)
			Engine.time_scale = 0.7

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


func toggle_faster_shader(active: bool):
	var t = create_tween()
	var property_tweener
	if color_rect_faster.material:
		property_tweener = t.tween_property(color_rect_faster.material, "shader_parameter/strength", 1.0 if active else 0.0, 0.2)
	if property_tweener:
		property_tweener.set_trans(Tween.TRANS_SINE)
	
	if active:
		color_rect_faster.visible = active
	else:
		t.tween_callback(func(): color_rect_faster.visible = false)


func _ready() -> void:
	# init stronger mode
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
	
	# Mode switch
	if Input.is_action_just_pressed("mode_switch"):
		current_mode += 1
		if current_mode > 2:
			current_mode = 0
		change_mode(current_mode)
	
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
	
	sprite.scale.x = lerp(sprite.scale.x, sprite_scale_x * last_direction.x, 0.2)


func _physics_process(delta: float) -> void:
	# == Movement ==
	if direction.x != 0:
		last_direction.x = direction.x
	if direction.y != 0:
		last_direction.y = direction.y
	
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	velocity.x = speed * direction.x
	velocity.y = speed * direction.y
	
	if velocity.length() > speed:
		velocity = velocity.limit_length(speed)
	
	move_and_slide()
