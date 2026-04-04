extends Area2D

var velocity = Vector2.ZERO
var random = 0
var parent_node: Node2D
@export var bomb: PackedScene

func _ready():
	random = randf_range(250.0, 300.0)
	velocity = Vector2(random * -1, random)
	scale = Vector2(random / 320, random / 320)

func _process(delta):
	position += velocity * delta
	if position.y > 550:
		parent_node.yure += 14
		var b = bomb.instantiate()
		get_tree().current_scene.add_child(b)
		b.position = position
		queue_free()
