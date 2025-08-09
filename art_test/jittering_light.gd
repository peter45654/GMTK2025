extends PointLight2D

@export var textures: Array[Texture2D]

var _tex_index: int = 0

func _on_timer_timeout() -> void:
	_tex_index = (_tex_index + 1) % textures.size()
	texture = textures[_tex_index]
