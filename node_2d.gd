extends Node2D

@export var enemy_scene: PackedScene
var random = 0
var score = float(0)
var score_bord = float(0)
var yure = float(0)
@export var meteooo: PackedScene
@export var tama_scene: PackedScene

var coin = 0
var hp_up_c = 5
signal hp_limit_up
signal enemy

func _ready():
	$attackUP.hide()
	$Area2D.hide()
	$start.show()
	$start.text = "START"
	$Label.hide()
	$home.hide()
	$messe.hide()
	$bosshptext.hide()
	var timer = get_node("Boss/BossEnemy")
	timer.timeout.connect(enemy_hello) 

func _process(_delta):
	random = randi_range(1, 2)
	score_bord += ceil((score - score_bord) / 10.0)
	$Label.text = str("Score:", int(score_bord))
	$attackUP.text = str("Max HP UP : ", hp_up_c, " COINS")
	$cointext.text = str(": ", coin)
	$Camera2D.position.y = 324 + yure
	yure *= -0.85
	if random == 1:
		$EnemyMarker.position.x = 0
	else:
		$EnemyMarker.position.x = 1152
	$bosshptext.hide()
	$BossHPbar.clear_points()
	$BossHPbar2.clear_points()

func _on_timer_timeout():
	enemy.emit()

func enemy_hello():
	var mob = enemy_scene.instantiate()
	var velocity = Vector2(randf_range(200.0, 240.0), 0.0)
	if random == 2:
		velocity *= -1
	mob.position = $EnemyMarker.position
	mob.velocity = velocity
	mob.parent_node = self
	add_child(mob)

func _on_start_pressed():
	$startsound.play()
	score = 0
	score_bord = 0
	$Label.position = Vector2(100, 10)
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	get_tree().call_group("iroiro", "queue_free")
	$Area2D.position = $Marker2D.position
	$Timer.start()
	$Timer2.start()
	$Area2D.show()
	$start.hide()
	$Label.show()
	$power_up.hide()
	$home.hide()
	$bosshptext.hide()
	$messe.hide()
	$bgm.play()

func game_over():
	$death.play()
	$Timer.stop()
	$Timer2.stop()
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Area2D.hide()
	$start.show()
	$home.show()
	$messe.show()
	$bgm.stop()
	$bgm2.stop()
	$start.text = "RETRY"
	$messe.text = str("GAME OVER")
	$Label.position = Vector2(435, 200)

func player_damege():
	yure += 35

func boss():
	$Timer.stop()
	await get_tree().create_timer(6.1).timeout
	$bgm2.play()

func hp_update(hp: Variant, max_hp: Variant):
	$HPbar.clear_points()
	$HPbar2.clear_points()
	$hptext.hide()
	if $Label.position == Vector2(100, 10):
		$hptext.show()
		$HPbar.add_point(Vector2(300, 130))
		$HPbar.add_point(Vector2(300 + (hp / max_hp * 250), 130))
		$HPbar2.add_point(Vector2(295, 130))
		$HPbar2.add_point(Vector2(555, 130))
		$hptext.text = str("HP   ", int(hp), " / ", int(max_hp))
		$hptext.position = Vector2(100, 108)

func home():
	$Area2D.hide()
	$start.show()
	$start.text = "START"
	$Label.hide()
	$home.hide()
	$power_up.show()
	$messe.hide()

func power_up():
	if $attackUP.visible:
		$attackUP.hide()
		$start.show()
	else:
		$attackUP.show()
		$start.hide()

func hp_up():
	if coin >= hp_up_c:
		$hp_up.play()
		coin -= hp_up_c
		hp_up_c *= 1.28
		hp_up_c = int(hp_up_c)
		hp_limit_up.emit()

func _on_boss_meteoh():
	var meteo = meteooo.instantiate()
	meteo.position = Vector2(randf_range(450.0, 1800.0), -40)
	meteo.parent_node = self
	add_child(meteo)

func _on_boss_tama():
	var tama = tama_scene.instantiate()
	tama.position = $Boss.position
	add_child(tama)

func _on_boss_boss_hp_signal(boss_hp: float, boss_hp_limit: float):
	$bosshptext.show()
	$BossHPbar.add_point(Vector2(200, 180))
	$BossHPbar.add_point(Vector2(200 + (boss_hp / boss_hp_limit * 852), 180))
	$BossHPbar2.add_point(Vector2(195, 180))
	$BossHPbar2.add_point(Vector2(1057, 180))
	$bosshptext.text = str("BOSS")
	$bosshptext.position = Vector2(80, 155)

func _on_boss_clear():
	get_tree().call_group("iroiro", "queue_free")
	score += 3000
	coin += 30
	$bgm2.stop()
	await get_tree().create_timer(7).timeout
	$jingle.play()
	$start.show()
	$home.show()
	$messe.show()
	$start.text = "RETRY"
	$messe.text = str("CLEAR!!")
	$Label.position = Vector2(435, 200)

func _on_boss_boss_dame(yuree: Variant):
	yure += yuree
	if yuree == 8:
		score += 20
