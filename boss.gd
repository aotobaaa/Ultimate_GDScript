extends Area2D

var aaa = 0
var y = float(-1000)
var x = float(1000)
var random = 0
var boss_hp = 0
var boss_hp_limit = 0
var boss = 0
var attack = 0
var rota = float(0)
var tukare = 0
var muteki = 0
var died_yure = 0
@export var bomb: PackedScene

signal boss_hp_signal(boss_hp, boss_hp_limit)
signal boss_attack
signal meteooo_attack
signal meteoh
signal tama
signal attack3(r, x_pos)
signal clear
signal boss_dame(yuree)

func _process(_delta):
	if 1 == boss:
		boss_hp_signal.emit(boss_hp, boss_hp_limit)
		aaa += 0.063
		if attack == 3 or tukare >= 4:
			y += (535 - y) / 14
		else:
			y += ((250 - y) / 42) + sin(aaa) * 2.6
		if attack == 2:
			tama.emit()
	position.x += (x - position.x) / 7
	position = Vector2(position.x + randf_range(died_yure, -1 * died_yure), y + randf_range(died_yure, -1 * died_yure))
	rotation += (rota - rotation) / 3

func _on_timer_2_timeout():
	await get_tree().create_timer(6).timeout
	boss = 1
	await get_tree().create_timer(1.7).timeout
	boss_attack.emit()
	$CollisionShape2D.set_deferred("disabled", false)

func _on_start_pressed():
	$BossEnemy.stop()
	boss_hp_limit = 25
	boss_hp = boss_hp_limit
	boss = 0
	y = -900
	tukare = 0
	muteki = 0
	rota = 0
	attack = 0
	died_yure = 0
	position.y = -900
	show()
	$AnimatedSprite2D.animation = "defo"
	$CollisionShape2D.set_deferred("disabled", true)

func _on_boss_attack():
	tukare += 1
	if tukare >= 4:
		for i in range(255):
			await get_tree().process_frame
			rota = randf_range(0.4, 1.6) * 1.5701
		rota = 0
		await get_tree().create_timer(0.3).timeout
		tukare = 0
	await get_tree().create_timer(1.25).timeout
	attack = randi_range(1, 3)
	if attack != 3 and boss_hp <= 15 and boss_hp > 0:
		$BossEnemy.start()
	else:
		$BossEnemy.stop()
	if attack == 1:
		meteooo_attack.emit()
		$mete.start()
		$mete2.start()
		await get_tree().create_timer(3.8).timeout
	if attack == 2:
		await get_tree().create_timer(2.1).timeout
		attack = 0
		await get_tree().create_timer(0.6).timeout
	if attack  == 3:
		for i in range(2):
			while 525 >= position.y:
				await get_tree().process_frame
			if boss == 1:
				attack3.emit(-1, 100)
				await get_tree().create_timer(1.5).timeout
			if boss == 1:
				attack3.emit(1, 1000)
				await get_tree().create_timer(1.5).timeout
		rota = 0
		attack = 0
	if boss == 1:
		boss_attack.emit()

func meteooo():
	if boss == 1:
		meteoh.emit()

func meteooo_stop():
	$mete2.stop()

func _on_area_entered(_area):
	if muteki == 0:
		boss_dame.emit(8)
		boss_hp -= 1
		muteki = 1
		if boss_hp >= 1:
			$hit.play()
			for i in range(2):
				$AnimatedSprite2D.animation = "dame"
				await get_tree().create_timer(0.05).timeout
				$AnimatedSprite2D.animation = "defo"
				await get_tree().create_timer(0.05).timeout
			muteki = 0
		else:
			$BossEnemy.stop()
			$CollisionShape2D.set_deferred("disabled", true)
			boss = 0
			clear.emit()
			for i in range(55):
				boss_dame.emit(13)
				died_yure += 0.6
				$AnimatedSprite2D.animation = "defo"
				await get_tree().process_frame
				died_yure += 0.6
				await get_tree().process_frame
				died_yure += 0.6
				$AnimatedSprite2D.animation = "dame"
				await get_tree().process_frame
				died_yure += 0.6
				var b = bomb.instantiate()
				get_tree().current_scene.add_child(b)
				b.position = position
				await get_tree().process_frame
			boss_dame.emit(32)
			hide()

func _on_attack_3(r, x_pos):
	rota = r * 1.5701
	$attack3_2.play()
	await get_tree().create_timer(0.55).timeout
	$attack3.play()
	x = x_pos
	set_collision_layer_value(2, true)
	await get_tree().create_timer(0.36).timeout
	set_collision_layer_value(2, false)
