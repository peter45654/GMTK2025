extends Control

@export var await_timer: Timer
@export var return_timer: Timer
@export var ui_to_show: Control

var _is_can_skip = false

func _ready() -> void:
	if await_timer != null:
		print("Hide UI")
		hide_ui()
		await_timer.timeout.connect(on_timer_timerout)
		await_timer.start(3)


func _unhandled_input(event):
	if event is InputEventKey:
		if event.is_pressed():
			print("input key")
			if _is_can_skip:
				go_title_scene()


func _on_gui_input(event: InputEvent) -> void:
	if await_timer == null:
		_is_can_skip = true

	if event is InputEventMouseButton:
		if event.is_pressed():
			print("mouse btn pressed.")
		if _is_can_skip:
			go_title_scene()


func go_title_scene():
	var title_scene_path = "res://game/scenes/title.tscn"
	get_tree().change_scene_to_file(title_scene_path)


func on_timer_timerout():
	print("timer_start")
	print("show UI")
	show_ui()
	await_timer.stop()
	return_timer.start()
	_is_can_skip = true
	print("_is_can_skip await_timer.is_stopped()")


func hide_ui():
	if ui_to_show != null:
		ui_to_show.visible = false


func show_ui():
	if ui_to_show != null:
		ui_to_show.visible = true


func _on_return_label_toggle_timeout() -> void:
	if _is_can_skip:
		if ui_to_show:
			print("123")
			ui_to_show.visible = !ui_to_show.visible
	if return_timer:
		print("456")
		return_timer.start()
	# Replace with function body.
