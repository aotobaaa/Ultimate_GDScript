extends CharacterBody2D

var attack = 0
var jump = 0
var gravity = 0
var velocityyyyy = Vector2.ZERO
var time = 0
var floor_tap = 0
var kaihi = 120
var muteki = false
var down_attack = true

var hp = float(100)
var hp_max = float(100)
var attack_power = 20
var stamina = 100
@export var rubble: PackedScene
@export var death_motion: PackedScene

signal normal_attack
signal normal_attack2
signal down_attacks
signal tossin
signal death
signal damage(d, type)

func _ready():
	position = Vector2(576, 324)
	scale = Vector2(0.75, 0.75)
	$Anima.animation = "default"

func _physics_process(delta):
	if visible:
		if $Anima.animation == "walk" or $Anima.animation == "down_attack_3" or muteki:
			stamina += 0.3
		else:
			stamina += 0.4
	else:
		stamina -= 3
	if stamina >= 100:
		stamina = 100
	if down_attack and visible:
		if Input.is_action_just_pressed("x") and is_on_floor() and kaihi == 120 and stamina >= 20:
			$kaihi.play()
			kaihi = 0
			stamina -= 20
		time += delta
		kaihi += 1
		if kaihi > 120:
			kaihi = 120
		velocity = Vector2.ZERO
		velocityyyyy *= 0.73
		if Input.is_action_pressed("ui_up"):
			if jump < 12:
				if jump == 0:
					position.y -= 10
				velocity.y = -190
				gravity = -785
				attack = 0
				jump += 1
			else:
				jump = 999
		elif jump > 0 or is_on_floor():
			jump = 999
		gravity += 40
		velocity.y += gravity
		if $Anima.animation != "guard":
			if Input.is_action_pressed("ui_right"):
				velocity.x += 430
				velocityyyyy.x += 75
				$Anima.flip_h = false
			if Input.is_action_pressed("ui_left"):
				velocity.x -= 430
				velocityyyyy.x -= 75
				$Anima.flip_h = true
			if attack == 0 and Input.is_action_just_pressed("space") and is_on_floor():
				normal_attack.emit()
		if is_on_floor():
			gravity = 0
			velocity.y = 0
			if attack == 0:
				if velocity.x == 0:
					$Anima.animation = "default"
				else:
					$Anima.animation = "walk"
		if int(velocity.y) != 0:
			if velocity.y <= 0:
				$Anima.animation = "up"
			elif $Anima.animation != "down2" and not $Anima.animation.contains("down_attack"):
				$Anima.animation = "down"
		if Input.is_action_pressed("ui_down"):
			gravity = 1400
			velocity.y = 1400
			if $Anima.animation == "down":
				$Anima.animation = "down_attack"
		if Input.is_action_just_pressed("ui_down") and is_on_floor():
			$guard.play()
			if $Anima.flip_h:
				velocityyyyy.x += 550
			else:
				velocityyyyy.x -= 550
		if Input.is_action_pressed("ui_down") and is_on_floor():
			$Anima.animation = "guard"
			attack = 0
		position += velocityyyyy * delta
		if kaihi < 12:
			$Anima.animation = "kaihi"
			velocity.y = 0
			if kaihi < 10:
				if $Anima.flip_h:
					velocityyyyy.x = 1700
					velocity.x = 600
				else:
					velocityyyyy.x = -1700
					velocity.x = -600
		move_and_slide()
	if visible:
		if position.y > 1200:
			damage.emit(hp_max / 5, 0)
			stamina -= 3
		if Input.is_action_pressed("0"):
			damage.emit(INF, -1)
		if round(hp) <= 0:
			death.emit()
	if is_on_floor():
		jump = 0
		floor_tap += 1
		if floor_tap == 1:
			$floor_tap.play()
			if Input.is_action_pressed("ui_down") and stamina >= 22:
				stamina -= 22
				$Anima.animation = "down_attack_3"
				down_attack = false
				$downattack2.play()
				$downattack3.pitch_scale = randf_range(0.85, 1)
				$downattack3.play()
				down_attacks.emit()
				for i in randf_range(7, 12):
					var rubbles = rubble.instantiate()
					rubbles.position = position
					rubbles.scale = Vector2(randf_range(0.4, 1.2), randf_range(0.4, 1.2))
					rubbles.animation = str(randi_range(1, 4))
					rubbles.modulate = Color(0.752, 0.752, 0.752, 1.0)
					if $Anima.flip_h:
						rubbles.position.x -= randf_range(30, 120)
					else:
						rubbles.position.x += randf_range(30, 120)
					get_tree().current_scene.add_child(rubbles)
	else:
		floor_tap = 0
	if $Anima.animation == "default" or $Anima.animation == "guard" or $Anima.animation == "down_attack_3":
		$Anima.scale += (Vector2(1.01 + (cos(time) * 0.05), 1.01 + (cos(time * 1.3) * 0.045)) - $Anima.scale) / 5
		if is_on_floor() and floor_tap == 2:
			if Input.is_action_pressed("ui_down"):
				$Anima.scale = Vector2(1.28, 0.65)
			else:
				$Anima.scale = Vector2(1.2, 0.75)
		if Input.is_action_just_pressed("ui_down") and $Anima.animation == "guard":
			$Anima.scale = Vector2(1.25, 0.7)
	else:
		$Anima.scale += (Vector2.ONE - $Anima.scale) / 5
	if stamina <= 0:
		stamina = 0
	$Anima.play()
	if $Anima.animation == "attack" and $Anima.frame > 1:
		$AttackArea/Collision.set_deferred("disabled", false)
	else:
		$AttackArea/Collision.set_deferred("disabled", true)
	if $Anima.animation == "attack2" and $Anima.frame > 0 and $Anima.frame < 3:
		$AttackArea2/Collision.set_deferred("disabled", false)
	else:
		$AttackArea2/Collision.set_deferred("disabled", true)
	if $Anima.animation == "tossin" and $Anima.frame == 0:
		$TossinArea/Collision.set_deferred("disabled", false)
	else:
		$TossinArea/Collision.set_deferred("disabled", true)
	if $Anima.animation == "down_attack_3" and $Anima.frame < 2:
		$DownAttackArea/Collision.set_deferred("disabled", false)
	else:
		$DownAttackArea/Collision.set_deferred("disabled", true)
	if $Anima.flip_h:
		$TossinArea.position = Vector2(-105, -56.5)
	else:
		$TossinArea.position = Vector2(105, -56.5)

func _on_anima_animation_finished():
	if $Anima.animation == "attack":
		attack = 2
		$Anima.animation = "attack_stop"
		for i in range(12):
			if Input.is_action_just_pressed("space"):
				if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
					tossin.emit()
				else:
					normal_attack2.emit()
			await get_tree().process_frame
		if attack == 2:
			attack = 0
	if $Anima.animation == "down":
		$Anima.animation = "down2"
	if $Anima.animation == "down_attack":
		$Anima.animation = "down_attack_2"
		$downattack.play()
	if $Anima.animation == "down_attack_3":
		down_attack = true
	if $Anima.animation == "tossin" or ($Anima.animation == "attack2" and $Anima.frame == 6):
		attack = 0

func _on_normal_attack():
	if stamina >= 10 and not $Anima.animation == "attack":
		stamina -= 10
		$attack.play()
		velocityyyyy.x += velocity.x * 1.28
		attack = 1
		$Anima.animation = "attack"

func _on_death():
	hide()
	$death.play()
	var death_scene = death_motion.instantiate()
	death_scene.position = Vector2(position.x, position.y - 80)
	death_scene.linear_velocity = (velocity + velocityyyyy * 3)
	death_scene.name = "deathhhh"
	death_scene.angular_velocity = randf_range(110, -110)
	get_tree().current_scene.add_child(death_scene)

func _on_tossin():
	if stamina >= 15 and not $Anima.animation == "tossin":
		stamina -= 15
		$tossin.play()
		$tossin2.play()
		velocityyyyy.x += velocity.x * 10
		attack = 3
		$Anima.animation = "tossin"

func _on_normal_attack_2():
	if stamina >= 12 and not $Anima.animation == "attack2":
		stamina -= 12
		$attack2.play()
		attack = 3
		$Anima.animation = "attack2"

func _on_damage(d, type):
	if not muteki:
		muteki = true
		hp -= d
		$hit.play()
		if type == 0:
			velocity *= 0.12
			velocityyyyy *= 0.12
			gravity *= 0.12
		for i in range(5):
			$Anima.modulate = Color(1, 1, 1, 1)
			await get_tree().create_timer(0.03).timeout
			$Anima.modulate = Color(0, 0, 0, 0)
			await get_tree().create_timer(0.03).timeout
		$Anima.modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(0.08).timeout
		muteki = false
