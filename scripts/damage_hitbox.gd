extends Area2D


var damage : float

enum Attacker { PLAYER, ENEMY, ENV }
var attacker : int


func _on_body_entered(body: Node2D) -> void:
	# Урон игроку
	if body.is_in_group("player") and attacker != Attacker.PLAYER:
		body.deal_damage(damage)
	# Урон врагам
	elif body.is_in_group("enemy") and attacker != Attacker.ENEMY:
		body.deal_damage(damage)
