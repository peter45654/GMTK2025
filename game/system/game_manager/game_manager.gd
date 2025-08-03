extends Node

const INITIAL_POSITION: Vector2 = Vector2(46,36)
const TRANSITION_DURATION_MS: float = 1000
var system_name: String = "[GameManager]"
var is_resetting: bool = false
var reset_time: float = 0.0
var tomas_progress: int = 0

func _process(_delta: float) -> void:
	if !is_resetting:
		return

	if Time.get_ticks_msec() - reset_time > TRANSITION_DURATION_MS:
		is_resetting = false
		hide_black_block()
		print(system_name, "Game reset completed.")
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
	show_black_block()
	reset_time = Time.get_ticks_msec()
	is_resetting = true
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
	else:
		print(system_name, "Tomas does not recognize item:", item_name)
