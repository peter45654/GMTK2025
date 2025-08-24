extends Node

@export var main_scene_path: String = "res://game/scenes/game.tscn"
@export var cursor_sound:AudioStreamPlayer
@export var select_sound:AudioStreamPlayer

#func _ready() -> void:
	#TranslationServer.set_locale("zh_TW")
	#print("zn tw!")

func _on_button_pressed() -> void:
	select_sound.play()
	get_tree().change_scene_to_file(main_scene_path)
	UiManager.on_press_start_btn()

func _on_button_hover() -> void:
	cursor_sound.play()
