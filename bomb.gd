extends Sprite2D

func _ready():
	$bomb.play()
	$AudioStreamPlayer.play()

func _on_audio_stream_player_finished():
	queue_free()

func _on_bomb_animation_finished():
	$bomb.hide()
