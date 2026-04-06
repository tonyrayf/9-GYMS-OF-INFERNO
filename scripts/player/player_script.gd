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
@export var aura : float = 0.0
@export var ultimate_charge : float = 0.0

@export_group("Stats")
var punch_damage : float
@export var punch_damage_shfb : Array = [50, 34, 25, 60]

var punch_radius : float = 60 # грубо говоря длина ручки
@export var punch_radius_shfb : Array = [80, 70, 60, 75]

var punch_collision_radius : float
@export var punch_collision_radius_shfb : Array = [70, 60, 50, 70]

var take_damage_multi : float
@export var take_damage_multi_shfb : Array = [0.75, 0.26, 1.5, 0.3]

var punch_time : float; var punch_timer : float = 0 # время между ударами кулаками
@export var punch_time_shfb : Array = [1, 2, 0.1, 1]

@export var stronger_charge_time : float = 2.2;
var stronger_charge_timer : float = 0

var kick_time : float; var kick_timer : float = 0 # время между пинком
@export var kick_time_shfb : Array = [2.2, 3.5, 1, 2]

var skill_e_time : float; var skill_e_timer : float = 0
@export var skill_e_time_shfb : Array = [4.5, 4.5, 2, 4.5]

@export var faster_dash_distance : float = 300

enum Mode { STRONGER, HARDER, FASTER, BETTER }
@export_enum("STRONGER", "HARDER", "FASTER", "BETTER") var current_mode : int = Mode.STRONGER

@export var mode_switch_time : float = 0.5
var mode_switch_timer : float = 0

@export_group("References")
@export var health_bar : Node
@export var color_rect_faster : Node
@export var sprite : Node
@export var aura_bar : Node
@export var style_sprites : Array[Node]
@export var vignette_rect : Node

@export_group("Visual params")
@export var stronger_punch_shake_amplitude : float = 40
@export var stronger_punch_shake_duration : float = 0.1
@export var stronger_punch_shake_magnitude : float = 1.4


@onready var damage_hitbox_scene := preload("res://scenes/damage_hitbox.tscn")
@onready var sprite_scale_x : float = sprite.scale.x
@onready var vignette_color : Vector3 = vignette_rect.material.get_shader_parameter("color")


func change_mode(mode: int) -> void:
	$CPUParticles2D.burst_multiple_times(1,velocity)
	current_mode = mode
	
	speed = speed_shfb[mode]
	punch_damage = punch_damage_shfb[mode]
	punch_collision_radius = punch_collision_radius_shfb[mode]
	take_damage_multi = take_damage_multi_shfb[mode]
	punch_time = punch_time_shfb[mode]
	kick_time = kick_time_shfb[mode]
	skill_e_time = skill_e_time_shfb[mode]
	
	Engine.time_scale = 1.0
	
	for spr in style_sprites:
		spr.visible = false
	
	style_sprites[mode].visible = true
	
	match mode:
		Mode.STRONGER:
			toggle_faster_shader(false)
			vignette_color = Vector3(0.939, 0.226, 0.246)
		
		Mode.HARDER:
			toggle_faster_shader(false)
			vignette_color = Vector3(0.8, 0.598, 0.013)
		
		Mode.FASTER:
			toggle_faster_shader(true)
			Engine.time_scale = 0.7

func mode_stronger_logic(delta: float) -> void:
	if stronger_charge_timer > 0:
		stronger_charge_timer = max(stronger_charge_timer - delta, 0)
	
	# Начало заряда кулака
	if Input.is_action_just_pressed("attack_punch") and punch_timer <= 0:
		stronger_charge_timer = stronger_charge_time
	
	# Удар непосредственно с учетом сколько игрок удерживал удар
	var punched : bool = false
	if Input.is_action_just_released("attack_punch") and punch_timer <= 0:
		punch_timer = punch_time
		
		var mouse_pos := get_global_mouse_position()
		
		var direction = (mouse_pos - global_position).normalized()
		var spawn_pos = global_position + direction * punch_radius
		var charged_damage = punch_damage
		
		# Смотрим прошли ли 1/3, 2/3 времени с заряда чтоб рассчитать урон
		if abs(stronger_charge_time - stronger_charge_timer) > stronger_charge_time / 3:
			charged_damage = punch_damage * 1.5
		if abs(stronger_charge_time - stronger_charge_timer) > stronger_charge_time * 2 / 3:
			charged_damage = punch_damage * 2
		
		print("Урон он заряда/Таймер: ", charged_damage, "/", stronger_charge_timer)
		
		Global.main_camera.shake(40,stronger_charge_time*0.1,3)
		do_punch()
		
		punched = Global.spawn_damage_hitbox(
				charged_damage,
				spawn_pos,
				Global.Attacker.PLAYER,
				punch_collision_radius
			)
			
	if Input.is_action_just_pressed("skill_e") and skill_e_timer <= 0:
		skill_e_timer = skill_e_time
		
		var mouse_pos := get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		
		global_position += direction * faster_dash_distance
	
	if punched and Global.main_camera:
		Global.main_camera.shake(
			stronger_punch_shake_amplitude,
			stronger_punch_shake_duration,
			stronger_punch_shake_magnitude
		)
	
	# Добивание
	if Input.is_action_just_pressed("skill_e") and skill_e_timer <= 0:
		skill_e_timer = skill_e_time
		
		var mouse_pos := get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		var spawn_pos = global_position + direction * punch_radius
		
		Global.spawn_damage_hitbox(
			punch_damage,
			spawn_pos,
			Global.Attacker.PLAYER,
			punch_collision_radius
		)

func mode_harder_logic(delta: float) -> void:
	if Input.is_action_just_pressed("attack_punch") and punch_timer <= 0:
		punch_timer = punch_time
		
		var mouse_pos := get_global_mouse_position()
		
		var direction = (mouse_pos - global_position).normalized()
		var spawn_pos = global_position + direction * punch_radius
		
		
		Global.spawn_damage_hitbox(
			punch_damage,
			spawn_pos,
			Global.Attacker.PLAYER,
			punch_collision_radius
		)
		
	if Input.is_action_just_pressed("skill_e") and skill_e_timer <= 0:
		skill_e_timer = skill_e_time
		
		var mouse_pos := get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		
		global_position += direction * faster_dash_distance

func mode_faster_logic(delta: float) -> void:
	if Input.is_action_pressed("attack_punch") and punch_timer <= 0:
		punch_timer = punch_time
		
		var mouse_pos := get_global_mouse_position()
		
		var direction = (mouse_pos - global_position).normalized()
		var spawn_pos = global_position + direction * punch_radius
		
		Global.spawn_damage_hitbox(
			punch_damage,
			spawn_pos,
			Global.Attacker.PLAYER,
			punch_collision_radius
		)
	
	# Dash
	if Input.is_action_just_pressed("skill_e") and skill_e_timer <= 0:
		skill_e_timer = skill_e_time
		
		var mouse_pos := get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		
		global_position += direction * faster_dash_distance

func mode_better_logic(delta: float) -> void:
	if stronger_charge_timer > 0:
		stronger_charge_timer = max(stronger_charge_timer - delta, 0)
	
	if Input.is_action_just_pressed("attack_punch") and punch_timer <= 0:
		stronger_charge_timer = stronger_charge_time
	
	var punched : bool = false
	if Input.is_action_just_released("attack_punch") and punch_timer <= 0:
		punch_timer = punch_time
		
		var mouse_pos := get_global_mouse_position()
		
		var direction = (mouse_pos - global_position).normalized()
		var spawn_pos = global_position + direction * punch_radius
		var charged_damage = punch_damage
		
		# Смотрим прошли ли 1/3, 2/3 времени с заряда чтоб рассчитать урон
		if abs(stronger_charge_time - stronger_charge_timer) > stronger_charge_time / 3:
			charged_damage = punch_damage * 1.5
		if abs(stronger_charge_time - stronger_charge_timer) > stronger_charge_time * 2 / 3:
			charged_damage = punch_damage * 2
		
		print("Урон он заряда/Таймер: ", charged_damage, "/", stronger_charge_timer)
			
		punched = Global.spawn_damage_hitbox(
				charged_damage,
				spawn_pos,
				Global.Attacker.PLAYER,
				punch_collision_radius
			)
	
	if punched and Global.main_camera:
		Global.main_camera.shake(
			stronger_punch_shake_amplitude,
			stronger_punch_shake_duration,
			stronger_punch_shake_magnitude
		)


func deal_damage(damage: float) -> void:
	health -= damage * take_damage_multi


func do_punch() -> void:
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	var angle = global_position.angle_to_point(mouse_pos)
	


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
	
	# Mode switch timer
	if mode_switch_timer > 0:
		mode_switch_timer = max(mode_switch_timer - delta, 0)
	
	# Mode switch
	if Input.is_action_just_pressed("mode_switch") and mode_switch_timer <= 0:
		mode_switch_timer = mode_switch_time
		
		current_mode += 1
		if current_mode > 2:
			current_mode = 0
		change_mode(current_mode)
	
	# Punch
	if punch_timer > 0:
		punch_timer = max(punch_timer - delta, 0)

	# Skill E timer
	if skill_e_timer > 0:
		skill_e_timer = max(skill_e_timer - delta, 0)
		
	# Выполняем логику SHFB
	match current_mode:
		Mode.STRONGER: mode_stronger_logic(delta)
		Mode.HARDER: mode_harder_logic(delta)
		Mode.FASTER: mode_faster_logic(delta)
		Mode.BETTER: mode_better_logic(delta)
	
	sprite.scale.x = lerp(sprite.scale.x, sprite_scale_x * sign(get_global_mouse_position().x - global_position.x), 0.2)
	
	# Lerp до колора виньетки
	vignette_rect.material.set_shader_parameter(
		"color",
		vignette_rect.material.get_shader_parameter("color").lerp(vignette_color, 0.07)
	)



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
