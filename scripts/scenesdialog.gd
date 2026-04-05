extends CanvasLayer


@export var full_text : Array = []
@export var typing_speed : float = 0.4
@export var dialog_active : bool = true
@export var kill_dialog : bool = false
@export var idle_blend : float = 0.6 # когда персонаж не говорит затемняем его

# референсы
@export var label : Node
@export var main_char_spr : Node
@export var opp_char_spr : Node
@export var anim_player : Node

var start : bool = true

var current_page : int = 0
var current_text : String = ""
var current_char : float = 0 # какой щас по счету буква
var character_talking : int = 1 # 0 - говорит глав гер, 1 - говорит оппонент

@onready var main_char_spr_scale : Vector2 = main_char_spr.scale
@onready var opp_char_spr_scale : Vector2 = main_char_spr.scale
@onready var text_arr = full_text[current_page]
@onready var page_number = len(full_text)
@onready var text_len = len(text_arr[1])


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	if start:
		start = false
		
		anim_player.play("start", -1, -1, true)
		visible = true
	
	if kill_dialog:
		Global.player.set_process(true)
		Global.player.set_physics_process(true)
		
		queue_free()
	
	if dialog_active:
		# Акцентируем говорящего персонажа
		if text_arr[0] == 0:
			main_char_spr.scale = main_char_spr.scale.lerp(main_char_spr_scale * 1.2, 0.2)
			main_char_spr.modulate = Color(1, 1, 1, 1)
			opp_char_spr.scale = opp_char_spr.scale.lerp(opp_char_spr_scale * 0.9, 0.2)
			opp_char_spr.modulate = Color(idle_blend, idle_blend, idle_blend, 1) 
		else:
			main_char_spr.scale = main_char_spr.scale.lerp(main_char_spr_scale * 0.9, 0.2)
			main_char_spr.modulate = Color(idle_blend, idle_blend, idle_blend, 1) 
			opp_char_spr.scale = opp_char_spr.scale.lerp(opp_char_spr_scale * 1.2, 0.2)
			opp_char_spr.modulate = Color(1, 1, 1, 1) 
		
		# Эффект печатания
		if current_char < text_len:
			current_char += typing_speed
		
		label.text = text_arr[1].substr(0, int(current_char + 0.99))
		label.text = text_arr[1].replace("\\n", "\n")
		
		if Input.is_action_just_pressed("attack_punch") or Input.is_action_just_pressed("attack_kick"):
			if current_page < page_number - 1:
				if current_char >= text_len:
					current_page += 1
					text_arr = full_text[current_page]
					text_len = len(text_arr[1])
					current_char = 0
				else:
					current_char = text_len + 1
			else:
				label.text = ""
				anim_player.play("end")
