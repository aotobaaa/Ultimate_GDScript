extends Area2D

var max_hp = float(5)
var hp = float(5)
var attack = 0
var muteki = 0
var kaihi = 0
var screen_size = Vector2.ZERO

signal game_over
signal damege
signal hp_update(hp, max_hp)

func _on_start_pressed():
	attack = 0
	muteki = 0
	kaihi = 0
	hp = max_hp
	$walk.animation = "default"
	$walk.show()
	$attack.hide()
	$attack.stop()
	screen_size = get_viewport_rect().size
	$attackarea/attackC.set_deferred("disabled", true)

func _process(delta):
	var velocity = Vector2.ZERO
	if kaihi != 1:
		if Input.is_action_pressed("右"):
			velocity.x += 350
			$walk.flip_h = false
			$attack.flip_h = false
		if Input.is_action_pressed("左"):
			velocity.x -= 350
			$walk.flip_h = true
			$attack.flip_h = true
	if Input.is_action_just_pressed("攻撃"):
		if attack == 0 and kaihi != 1 and visible:
			$attack.animation = "attack"
			$walk.hide()
			$attack.show()
			$attack.play()
			$Timer.start()
			$Timer2.start()
			$a2.play()
			attack = 1
	if Input.is_action_just_pressed("回避"):
		if attack == 0 and kaihi == 0 and visible:
			$CollisionShape2D.set_deferred("disabled", true)
			kaihi = 1
			$kaihi.start()
			$kaihi2.start()
			$a3.play()
	if kaihi == 1:
		if $walk.flip_h == false:
			velocity.x += 1600
		else:
			velocity.x -= 1600
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0:
		$walk.animation = "walk"
	else:
		$walk.animation = "default"
	$walk.play()
	hp_update.emit(hp, max_hp)

func attack_timer():
	$walk.show()
	$attack.hide()
	$attack.stop()
	attack = 0
	$attackarea/attackC.set_deferred("disabled", true)

func muteki_end():
	muteki = 0

func _on_area_entered(_area):
	if muteki == 0:
		damege.emit()
		muteki = 1
		hp -= 1
		$Muteki.start()
		if hp < 1:
			game_over.emit()
		else:
			$a.play()

func attack_collision():
	$attackarea/attackC.set_deferred("disabled", false)

func kaihi_end():
	kaihi = 2
	$CollisionShape2D.set_deferred("disabled", false)

func kaihi_cooltime_end():
	kaihi = 0

func hp_limit_up():
	max_hp = ceil(max_hp * 1.14)
