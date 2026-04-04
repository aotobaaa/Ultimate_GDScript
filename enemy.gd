extends Area2D

var velocity = Vector2.ZERO
var dead_tick = 0
var dead_ = 0
var parent_node: Node2D
@export var bomb: PackedScene

func _process(delta):
	position += velocity * delta
	if dead_ == 1:
		dead_tick += 1
	if dead_tick == 2:
		$CollisionShape2D.set_deferred("disabled", true)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(_area):
	if parent_node:
		$Timer.start()
		parent_node.score += 100
		parent_node.coin += 1
		velocity.x = 0
		dead_ = 1
		var b = bomb.instantiate()
		get_tree().current_scene.add_child(b)
		b.position = position
		b.scale = Vector2(0.7, 0.7)
		$Sprite2D.hide()

func dead():
	queue_free()
