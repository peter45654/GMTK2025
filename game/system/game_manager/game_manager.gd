extends Node

var system_name: String = "[GameManager]"

# TODO const Vector2 play_initial_position = Vector2(0, 0)

func soft_reset_game() -> void:
	# find all in Interactable in group
	var interactables = get_tree().get_nodes_in_group("Interactable")
	for interactable in interactables:
		if interactable.has_method("reset"):
			interactable.reset()
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
	print(system_name, "Progress reset.")
