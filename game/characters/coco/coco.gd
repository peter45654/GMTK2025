extends CharacterBody2D


const SPEED = 50

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var actionable_finder: Area2D = $Direction/ActionableFinder



var input_vector: Vector2 = Vector2.ZERO


func _ready() -> void:
	animation_tree.active = true


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			if actionables[0].action_type == Actionable.ActionType.DOOR:
				if actionables[0].is_locked:
					var unlock_item_name= actionables[0].unlocked_item_name
					if !Inventory.is_have_item(unlock_item_name):
						actionables[0].door_locked()
						return
				var transition_area = actionables[0].transition_area
				if transition_area:
					transition_area.transition_to_origin_room(self)
					return
			else:
				actionables[0].action()
				input_vector = Vector2.ZERO
				return

	var x_axis: float = Input.get_axis("ui_left", "ui_right")
	var y_axis: float = Input.get_axis("ui_up", "ui_down")
	if x_axis:
		input_vector = x_axis * Vector2.RIGHT
	elif y_axis:
		input_vector = y_axis * Vector2.DOWN
	else:
		input_vector = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if input_vector.length() > 0:
		velocity = input_vector * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	move_and_slide()

	if velocity.length() > 0:
		animation_tree.set("parameters/idle/blend_position", velocity)
		animation_tree.set("parameters/walk/blend_position", velocity)
		animation_tree.get("parameters/playback").travel("walk")
	else:
		animation_tree.get("parameters/playback").travel("idle")

func reset():
	# Reset the character to the initial position and state
	position = GameManager.INITIAL_POSITION
	velocity = Vector2.ZERO
	animation_tree.get("parameters/playback").travel("idle")
	print("[Coco] Character reset done.")
