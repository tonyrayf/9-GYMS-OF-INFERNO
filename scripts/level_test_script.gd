extends Node2D

func _ready() -> void:
	test_push_loop()

func test_push_loop() -> void:
	while true:
		await get_tree().create_timer(3.0).timeout
		var enemy_inst = get_node_or_null("Enemy")
		enemy_inst.push_to(enemy_inst.global_position-Global.player.global_position,1000)
