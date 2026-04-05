extends Node2D
var kiraaaaaa = 0.2
signal start

func _ready():
	$aotobaaa.self_modulate = Color(1, 1, 1, 0)
	$a.animation = "1"
	$a.play()
	$a.position = Vector2(576, 324)
	$aotobaaa.position = Vector2(576, 345)
	$heaa.position = Vector2(590, 276)
	$mouse_sprite.position = Vector2(1200, 700)
	await get_tree().create_timer(1.26).timeout
	for i in range(60):
		$mouse_sprite.position += Vector2(-9.2, -6.6)
		await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	$click.play()
	await get_tree().create_timer(0.45).timeout
	for i in range(70):
		$mouse_sprite.position += Vector2(14, 14)
		$heaa.position += Vector2(14, 14)
		await get_tree().process_frame
	$a.animation = "2"
	$kira.play()
	$kiraaa.show()
	$kiraaa.position = Vector2(614, 255)
	for i in range(90):
		$kiraaa.rotation += kiraaaaaa
		var kirara = (0.2 - kiraaaaaa) / 11
		$kiraaa.scale -= Vector2(kirara, kirara)
		kiraaaaaa *= 0.97
		await get_tree().process_frame
		$kiraaa.self_modulate -= Color(0, 0, 0, 0.012)
	for i in range(8):
		await get_tree().process_frame
		$aotobaaa.self_modulate += Color(0, 0, 0, 0.125)
		$aotobaaa.position.y += 4.15
	await get_tree().create_timer(1.4).timeout
	for i in range(20):
		await get_tree().process_frame
		modulate.r -= 0.05
		modulate.g -= 0.05
		modulate.b -= 0.05
	start.emit()
