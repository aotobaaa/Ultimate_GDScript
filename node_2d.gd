extends Node2D

var cameraaaaa = 0
var yure = Vector2.ZERO
var yure_tick = 0

var hp = 0
var max_hp = 0
var stamina = 0

func _physics_process(_delta):
	hp = $bounin.hp
	max_hp = $bounin.hp_max
	stamina = $bounin.stamina
	yure_tick += 1
	cameraaaaa = $bounin.position - $Camera2D.position
	for child in get_children():
		if child.name.begins_with("deathhhh"):
			cameraaaaa = child.position - $Camera2D.position
	$Camera2D.position += cameraaaaa / 3.2
	if yure_tick > 1:
		$Camera2D.position += yure
		yure_tick -= 2
		yure *= -0.88
	$sky.position = $Camera2D.position - Vector2(576, 324)
	$Line.position = $Camera2D.position - Vector2(576, 324)
	get_tree().call_group("HPBar", "clear_points")
	$Line/HP.add_point(Vector2(180, 60))
	$Line/HP.add_point(Vector2(490, 60))
	$Line/HP2.add_point(Vector2(185, 60))
	$Line/HP2.add_point(Vector2(185 + (hp / max_hp) * 300, 60))
	$Line/ST.add_point(Vector2(180, 93))
	$Line/ST.add_point(Vector2(450, 93))
	$Line/ST2.add_point(Vector2(185, 93))
	$Line/ST2.add_point(Vector2(185 + (stamina / 100) * 260, 93))

func down_attacks():
	yure.y = 42
