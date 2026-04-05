extends Node

var enemy
var attack_sprites_list
var attack_end_flag: bool

func _ready() -> void:
	enemy = get_parent().get_parent()
	attack_sprites_list = get_parent().attack_sprites_list
	set_physics_process(false) 

	
func enter() -> void:
	attack_end_flag = false
	await test_mass_attack(300,1)
	await test_mass_attack(400,2)
	attack_end_flag = true
	
	
func exit() -> void:
	pass

func test_mass_attack(a,time) -> void:
	var pos = enemy.global_position
	enemy.spawn_ranged_attack(attack_sprites_list[0],enemy.damage,pos+Vector2(a,a),time,spawn_damage.bind(pos+Vector2(a,a)))
	enemy.spawn_ranged_attack(attack_sprites_list[1],enemy.damage,pos+Vector2(a,-a),time,spawn_damage.bind(pos+Vector2(a,-a)))
	enemy.spawn_ranged_attack(attack_sprites_list[2],enemy.damage,pos+Vector2(-a,a),time,spawn_damage.bind(pos+Vector2(-a,a)))
	await enemy.spawn_ranged_attack(attack_sprites_list[3],enemy.damage,pos+Vector2(-a,-a),time,spawn_damage.bind(pos+Vector2(-a,-a)))

func spawn_damage(whereTo) -> void:
	Global.spawn_damage_hitbox(enemy.damage,whereTo,Global.Attacker.ENEMY,25)
