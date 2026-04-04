extends Area2D

var velocity = Vector2.ZERO

func _ready():
	rotation = randf_range(0, 360)
	velocity = Vector2(0, randf_range(350, 400)).rotated(rotation)

func _process(delta):
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
