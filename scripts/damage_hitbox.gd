extends Area2D

@export var damage : float
@export var collision_radius : float
@export var sphere_collision : CircleShape2D
@export var time_to_live : float = 0.08

@export_enum("PLAYER", "ENEMY", "ENV") var attacker : int


func _on_body_entered(body: Node2D) -> void:
	# Урон игроку
	if body.is_in_group("player") and attacker != Global.Attacker.PLAYER:
		body.deal_damage(damage)
	# Урон врагам
	elif body.is_in_group("enemy") and attacker != Global.Attacker.ENEMY:
		body.deal_damage(damage)


func _process(delta: float) -> void:
	time_to_live -= delta
	
	if time_to_live <= 0:
		queue_free()
