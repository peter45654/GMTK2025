class_name Actionable
extends Area2D

enum ActionType { DIALOGUE, CLEANABLE, CLAIMABLE, MIXED, DOOR }

const Balloon = preload("res://game/dialogue/balloon.tscn")

@export var action_type: ActionType = ActionType.DIALOGUE
@export var item_to_claim: BaseItem = null
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var active: bool = true
@export var is_always_active: bool = false
@export var transition_area: TransitionArea = null
@export var boss_progress_to_active: int = 0
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

		if dialogue_resource != null:
			create_dialogue()
		hide_root()
	else:
		print(system_name, "Unknown action type:", action_type)
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
	print(system_name, "Actionable reset done.")


func hide_root() -> void:
	if root == null:
		print(system_name, "Root node is null, cannot hide.")
		return
	root.hide()
	print(system_name, "Root node hidden(cleaned).")


func show_root() -> void:
	if root == null:
		print(system_name, "Root node is null, cannot show.")
		return
	root.show()
	print(system_name, "Root node shown.")
