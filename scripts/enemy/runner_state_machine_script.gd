extends "res://scripts/enemy/state_machine_script.gd"

#states
#patrol runner_attack death
#can't lose target

var constant_target
var stunned_duration = 3

func _ready() -> void:
	vision_zone = get_node("../Vision")
	
	for child in get_children():
		if "enemy" in child:
			child.enemy = enemy
	await get_tree().process_frame
	change_state("patrol",false)

func _physics_process(delta: float) -> void:
	if (enemy.health<=0):
		change_state("death")
		return
		
	if (current_state=="patrol"):
		if (vision_zone.current_body_name=="Player"):
			constant_target = vision_zone.current_body
			change_state("runner_attack")
	elif (current_state=="runner_attack"):
		if(enemy.get_slide_collision_count()>0):
			Global.spawn_damage_hitbox(enemy.damage,enemy.global_position,Global.Attacker.ENEMY,150)
			Global.main_camera.shake(40,0.35,3)
			get_tree().create_timer(stunned_duration).timeout.connect(_on_stun_end)
			change_state("stunned")
			constant_target = null
	elif (current_state=="stunned"):
		pass
	
func _on_stun_end() -> void:
	change_state("patrol")
