extends Control

@export var transition_duration: float = 1.0

signal fade_in_completed
signal fade_out_completed

@onready var color_rect: ColorRect = $ColorRect

func _ready():
	# Set initial state - transparent
	color_rect.color.a = 0.0
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		# Hide the black screen when the cancel action is pressed
		show_blackscreen()
	if event.is_action_pressed("ui_cancel"):
		# Hide the black screen when the cancel action is pressed
		hide_blackscreen()

func show_blackscreen():
	"""淡入到黑色畫面"""
	show()
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 1.0, transition_duration)
	tween.tween_callback(_on_fade_in_complete)

func hide_blackscreen():
	"""淡出黑色畫面"""
	var tween = create_tween()
	tween.tween_property(color_rect, "color:a", 0.0, transition_duration)
	tween.tween_callback(_on_fade_out_complete)

func _on_fade_in_complete():
	fade_in_completed.emit()

func _on_fade_out_complete():
	hide()
	fade_out_completed.emit()
