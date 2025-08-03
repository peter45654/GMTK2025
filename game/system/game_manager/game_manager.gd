extends Node

const INITIAL_POSITION: Vector2 = Vector2(46,36)
const TRANSITION_DURATION_MS: float = 2000
const Balloon = preload("res://game/dialogue/balloon.tscn")
const DialogueSource:DialogueResource = preload("res://game/dialogue/loop.dialogue")

var system_name: String = "[GameManager]"
var is_need_wait_for_talking: bool = false
var start_show_black_block_time: float = 0.0
var tomas_progress: int = 0
var tomas_is_talking_during_reset: bool = false

func _process(_delta: float) -> void:
	if !is_need_wait_for_talking:
		return

	var current_time: float = Time.get_ticks_msec()
	if current_time - start_show_black_block_time < TRANSITION_DURATION_MS:
		print(system_name, "Transition in progress, showing black block.")
		return

	create_dialogue("tomas_progress_1_talking")
	is_need_wait_for_talking = false

	print(system_name, "Game transition completed.")
	return

func soft_reset_game() -> void:
	# find all in Interactable in group
	var interactables = get_tree().get_nodes_in_group("Interactable")
	for interactable in interactables:
		if interactable.has_method("reset"):
			interactable.reset()

	var player = get_tree().get_nodes_in_group("Player")[0]
	if player:
		if player.has_method("reset"):
			player.reset()
	print(system_name, "Soft reset game completed.")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode  == KEY_R:
			print(system_name, "R key pressed. Resetting game.")
			soft_reset_game()
		if event.keycode == KEY_F5:
			print(system_name, "P key pressed. Resetting and clearing game progress.")
			soft_reset_game()
			reset_progress()

func reset_progress() -> void:
	Inventory.clear_inventory()
	tomas_progress = 0
	print(system_name, "Progress reset.")

func show_black_block() -> void:
	var black_block = get_tree().get_nodes_in_group("BlackBlock")[0]
	if black_block:
		black_block.show()
	start_show_black_block_time = Time.get_ticks_msec()
	is_need_wait_for_talking = true
	print(system_name, "Black block visibility shown.")

func hide_black_block() -> void:
	var black_block = get_tree().get_nodes_in_group("BlackBlock")[0]
	if black_block:
		black_block.hide()
	print(system_name, "Black block visibility hidden.")

func tomas_recieve_item(item_name: String) -> void:
	if item_name == "TestItem":
		tomas_progress += 1
		print(system_name, "Tomas received item:", item_name, "Progress:", tomas_progress)
		create_dialogue("tomas_progress_1_talking_begin")

	else:
		print(system_name, "Tomas does not recognize item:", item_name)
		create_dialogue("tomas_receive_none")


func create_dialogue(title: String) -> void:
	var balloon: Node = Balloon.instantiate()
	if DialogueSource == null:
		print(system_name, "Dialogue resource is null, cannot start dialogue.")
		return
	var dialogue_source: DialogueResource = DialogueSource
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_source, title)

func tomas_done_talking() -> void:
	is_need_wait_for_talking = false
	hide_black_block()

func tomas_done_begin_talking() -> void:
	show_black_block()
	soft_reset_game()
