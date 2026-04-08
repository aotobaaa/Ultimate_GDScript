extends AnimatedSprite2D

var x = randf_range(150, -150)
var y = randf_range(-600, -850)

func _process(delta):
	position += Vector2(x, y) * delta
	y += 44
	modulate.a -= 0.025
	rotation += x / 200 * delta
	if modulate.a >= 1:
		queue_free()
