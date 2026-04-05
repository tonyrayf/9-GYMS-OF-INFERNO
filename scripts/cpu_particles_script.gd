extends CPUParticles2D

func burst_multiple_times(count: int,velocity) -> void:
	for i in range(count):
		self.restart() # Сбрасывает и запускает частицы заново
		await get_tree().create_timer(0.5).timeout
