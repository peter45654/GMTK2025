extends Node

@export var main_scene_path: String = "res://game/scenes/game.tscn"
@export var cursor_sound: AudioStreamPlayer
@export var select_sound: AudioStreamPlayer


func _on_button_pressed() -> void:
	select_sound.play()
	get_tree().change_scene_to_file(main_scene_path)
	UiManager.on_press_start_btn()


func _on_button_hover() -> void:
	cursor_sound.play()


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		var language := TranslationServer.get_locale()
		print("-------")
		print("language:",language)
		if not is_node_ready():
			await ready
		var label = $CanvasLayer/Control/panel/label/Label as Label
		var text_title = TranslationServer.translate(&"The Echoing Workshop")#tr(&"The Echoing Workshop")
		 
		label.text = text_title
		print("label.text:",label.text)
		var button = $CanvasLayer/Control/panel/Control/Button as Button
		var text_button = tr(&"Start")
		button.text = text_button
