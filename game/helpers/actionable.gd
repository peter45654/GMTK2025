class_name Actionable
extends Area2D

enum ActionType { DIALOGUE, CLEANABLE, CLAIMABLE, MIXED, DOOR, CHECKITEM }

const Balloon = preload("res://game/dialogue/balloon.tscn")

@export var action_type: ActionType = ActionType.DIALOGUE
@export var item_to_claim: BaseItem = null
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var dialogue_option: String = "start"
@export var active: bool = true
@export var is_always_active: bool = false
@export var transition_area: TransitionArea = null
@export var boss_progress_to_active: int = 0
@export var clean_body: StaticBody2D
@export var clean_show: Node2D
@export var hide_object: Node2D
@export var is_locked: bool = false
@export var unlocked_item_name: String = ""
@export var items_to_check: Array[BaseItem] = []
@export var hight_light_node:Node2D
@export var hight_light_color:Color=Color(1,1,0,1)

var system_name: String = "[Actionable]"

@onready var root = $".."


func _ready() -> void:
	assert(root != null, system_name + "Root node is not set.")
	reset()
	print(system_name, "Actionable ready with action type:", action_type, " root name:", root.name)


func action() -> void:
	if !active:
		print(system_name, "Actionable is not active, skipping action.")
		return
	if action_type == ActionType.DIALOGUE:
		var balloon: Node = Balloon.instantiate()
		get_tree().current_scene.add_child(balloon)
		if dialogue_resource == null:
			print(system_name, "Dialogue resource is null, cannot start dialogue.")
			return
		balloon.start(dialogue_resource, dialogue_start)
	elif action_type == ActionType.CLAIMABLE:
		if item_to_claim == null:
			print(system_name, "Item to claim is null, cannot claim item.")
			return
		if Inventory.is_have_item(item_to_claim.name):
			print(system_name, "Item already claimed:", item_to_claim.name)
			return
		Inventory.add_item(item_to_claim)
		hide_root()
	elif action_type == ActionType.CLEANABLE:
		hide_root()
		print(system_name, "Actionable cleaned.")
	elif action_type == ActionType.MIXED:
		if item_to_claim != null:
			if !Inventory.is_have_item(item_to_claim.name):
				Inventory.add_item(item_to_claim)
		if clean_body != null:
			clean_body.get_child(0).disabled = true
		if clean_show != null:
			clean_show.show()
			print(system_name, "Clean show node hidden.")
		if dialogue_resource != null:
			create_dialogue()
		hide_root()
	elif action_type == ActionType.CHECKITEM:
		if items_to_check.size() <= 0:
			create_dialogue()
			return
		var is_failed = false
		for item in items_to_check:
			if !Inventory.is_have_item(item.name):
				print(system_name, "Required item not found:", item.name)
				is_failed = true
				break
		if is_failed:
			create_dialogue()
		else:
			create_option_dialogue()
			active=false
			if hide_object != null:
				hide_object.hide()
		return

	else:
		print(system_name, "Unknown action type:", action_type)
		if clean_body != null:
			clean_body.get_child(0).disabled = true
		if clean_show != null:
			clean_show.show()
			print(system_name, "Clean show node hidden.")
		return

	if !is_always_active:
		active = false


func create_dialogue() -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	if dialogue_resource == null:
		print(system_name, "Dialogue resource is null, cannot start dialogue.")
		return
	balloon.start(dialogue_resource, dialogue_start)


func create_option_dialogue() -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	if dialogue_resource == null:
		print(system_name, "Dialogue resource is null, cannot start dialogue.")
		return
	balloon.start(dialogue_resource, dialogue_option)


func reset() -> void:
	if root.name == "Game":
		print(system_name, "Root node is Game, skip it.")
		return
	show_root()
	var boss_progress := GameManager.tomas_progress
	if boss_progress < boss_progress_to_active and !is_always_active:
		active = false
		print(
			system_name,
			" ",
			root.name,
			" is not active due to boss progress:",
			boss_progress,
			"required:",
			boss_progress_to_active,
			" current:",
			boss_progress
		)
	else:
		active = true
	if clean_body != null:
		clean_body.get_child(0).disabled = false
		print(system_name, "Clean body reset done.")
	if clean_show != null:
		clean_show.hide()
		print(system_name, "Clean show node reset done.")
	if active:
		if hide_object != null:
			hide_object.show()
			print(system_name, "Hide object node reset done.")

	print(system_name, "Actionable reset done.")


func hide_root() -> void:
	if root == null:
		print(system_name, "Root node is null, cannot hide.")
		return
	root.hide()
	turn_off_collision()

	print(system_name, "Root node hidden(cleaned).")


func show_root() -> void:
	if root == null:
		print(system_name, "Root node is null, cannot show.")
		return
	root.show()
	turn_on_collision()
	print(system_name, "Root node shown.")


func turn_off_collision() -> void:
	var collision_shape := get_node("CollisionShape2D") as CollisionShape2D
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
		print(system_name, "Collision shape turned off.")


func turn_on_collision() -> void:
	var collision_shape := get_node("CollisionShape2D") as CollisionShape2D
	if collision_shape:
		collision_shape.set_deferred("disabled", false)
		print(system_name, "Collision shape turned on.")


func door_locked() -> void:
	if !is_locked:
		print(system_name, "Door is not locked.")
		return
	create_dialogue()

func get_root_name() -> String:
	if root == null:
		print(system_name, "Root node is null, cannot get name.")
		return ""
	return root.name

func highlight() -> void:
	if root == null:
		print(system_name, "Root node is null, cannot highlight.")
		return
	if hight_light_node!=null:
		hight_light_node.modulate = hight_light_color
	print(system_name, "Root node highlighted.")

func unhighlight() -> void:
	if root == null:
		print(system_name, "Root node is null, cannot unhighlight.")
		return
	if hight_light_node!=null:
		hight_light_node.modulate = Color(1, 1, 1, 1)  # Reset to white color
	print(system_name, "Root node unhighlighted.")
