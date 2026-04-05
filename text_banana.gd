extends Control

signal textter(chara, text, frip_h)
signal next_textter
var click
var text1 = ""
var text2 = 0
var pyonpyon = -2.8
var skip = true
var voice_play = 0

@export var option = false   #ここで「アンテみたいに」喋らるか「MOTHER2」みたいに喋らせるか変更できるZOY

signal banana_show
signal banana_hide

func _ready():
	banana_show.emit()
	textter.emit("aotobaaa", "[color=red]uwaaaaaaaaaaaaaaaaaaaaa!!!!!!!![/color]", false)
	await next_textter
	textter.emit("aotobaaa", "[color=yellow]i'm bananaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
uwaaaaaaaaaaaaaaaaaaaaaa!!!!!?!?!?!!!?!??[/color]", false)
	await next_textter
	textter.emit("aotobaaa?", "i likeeeeeeeeeeeeeeeeeeeee
bananaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", true)
	await next_textter
	textter.emit("aotobaaa", "How are you?", false)
	await next_textter
	textter.emit("aotobaaa?", "i'm s*it.", true)
	await next_textter
	textter.emit("aotobaaa", "Oh!", false)
	await next_textter
	banana_hide.emit()

func _process(_delta):
	$next.position.y += pyonpyon
	pyonpyon -= 0.2
	if pyonpyon <= -3:
		pyonpyon += 6
		$next.position.y = 580

func _on_textter(chara, text, frip_h,):
	var node_name = str("v_", chara)
	var Bananacode = true
	skip = true
	voice_play = 3
	$Name.text = chara
	$Chara.animation = chara
	$Chara.flip_h = frip_h
	$Chara.position.y = 315
	if frip_h == false:
		$Chara.position.x = 250
	else:
		$Chara.position.x = 902
	text1 = ""
	text2 = 0
	for i in range(text.length()):
		text1 = str(text1, text[text2])
		if text[text2] == "[":
			Bananacode = false
		if text[text2] == "]":
			Bananacode = true
		$Text.text = text1
		text2 += 1
		if Bananacode:
			if skip and option:
				get_node(node_name).play()
				for i2 in range(2):
					await get_tree().process_frame
			if not option and skip:
				await get_tree().process_frame
				voice_play += 1
				if voice_play == 4:
					get_node(node_name).play()
					voice_play = 0
	click = true
	$next.show()
	while click:
		await get_tree().process_frame
	$click.play()
	$next.hide()
	next_textter.emit()

func _input(event):
	if event.is_action_pressed("mouse_migi"):
		click = false
		skip = false

func _on_banana_show():
	modulate.a = 0
	position.y = 48
	for i2 in range(4):
		position.y -= 12
		modulate.a += 0.25
		await get_tree().process_frame

func _on_banana_hide():
	modulate.a = 1
	position.y = 0
	for i2 in range(4):
		position.y += 12
		modulate.a -= 0.25
		await get_tree().process_frame
