extends Node

@export var item_btn: PackedScene
@export var cursor_sound: AudioStreamPlayer
@export var select_sound: AudioStreamPlayer

var system_name: String = "[UIManager]"
var is_boss_open_inventory: bool = false

@onready var user_interface: Control = $CanvasLayer/UserInterface
@onready var inventory_ui: Control = $CanvasLayer/InventoryPanel
@onready var item_container: Control = $CanvasLayer/InventoryPanel/ScrollContainer/GridContainer
@onready var item_attribute_container: Control = $CanvasLayer/ItemAttributePanel
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready
var item_name: Label = $CanvasLayer/ItemAttributePanel/MarginContainer/VBoxContainer/item_name
@onready
var item_description: Label = $CanvasLayer/ItemAttributePanel/MarginContainer/VBoxContainer/item_description


func _ready():
	assert(user_interface != null, system_name + " User interface is not set.")
	assert(user_interface is Control, system_name + " User interface must be a Control node.")
	assert(inventory_ui != null, system_name + " Inventory UI is not set.")
	assert(inventory_ui is Control, system_name + " Inventory UI must be a Control node.")
	assert(item_attribute_container != null, system_name + " Item attribute container is not set.")
	assert(
		item_attribute_container is Control,
		system_name + " Item attribute container must be a Control node."
	)
	assert(item_container != null, system_name + " Item container is not set.")
	assert(item_container is Control, system_name + " Item container must be a Control node.")
	var current_scene_name = get_tree().get_current_scene().get_name()
	print("目前場景的名稱是：", current_scene_name)
	if current_scene_name == "Game":
		user_interface.visible = true
	else:
		user_interface.visible = false
	inventory_ui.visible = false
	item_attribute_container.visible = false
	print(system_name, " UI Manager is ready.")


func on_press_start_btn() -> void:
	user_interface.visible = true
	inventory_ui.visible = false
	item_attribute_container.visible = false
	print(system_name, " on_press_start_btn.")


func on_goto_title_scene() -> void:
	user_interface.visible = false
	inventory_ui.visible = false
	item_attribute_container.visible = false
	print(system_name, " on_goto_title_scene.")


func on_goto_thank_you_scene() -> void:
	user_interface.visible = false
	inventory_ui.visible = false
	item_attribute_container.visible = false
	print(system_name, " on_goto_thank_you_scene.")


func open_inventory_ui(is_open_by_boss: bool) -> void:
	is_boss_open_inventory = is_open_by_boss
	_generate_item_buttons()
	inventory_ui.visible = true
	print(system_name, " Inventory UI is now open. is_boss_open_inventory:", is_boss_open_inventory)


func close_inventory_ui() -> void:
	inventory_ui.visible = false
	print(system_name, " Inventory UI is now closed.")


func toggle_inventory_ui() -> void:
	_generate_item_buttons()

	if inventory_ui.visible:
		inventory_ui.visible = false
		is_boss_open_inventory = false
		print(system_name, " Inventory UI is now hidden.")
	else:
		inventory_ui.visible = true
		print(system_name, " Inventory UI is now visible.")


func _generate_item_buttons() -> void:
	var items: Array = Inventory.get_items()
	# clear existing item buttons
	var children: Array = item_container.get_children()
	for child in children:
		child.queue_free()

	for item in items:
		print(system_name, "Item in inventory:", item.name, "Description:", item.description)
		var item_btn_instance_root = item_btn.instantiate() as Control
		item_container.add_child(item_btn_instance_root)
		var item_btn_instance = item_btn_instance_root.get_child(1) as Button
		item_btn_instance.name = item.name + "_button"
		item_btn_instance.text = item.name
		item_btn_instance.connect(
			"gui_input", _on_item_button_mouse_entered.bind(item_btn_instance, item)
		)
		item_btn_instance.connect("mouse_entered", _on_func_toggle_inventory_ui_btn_mouse_entered)
		item_btn_instance.connect("mouse_exited", _on_item_button_mouse_exited)
		item_btn_instance.connect(
			"pressed", _on_item_button_pressed.bind(item_btn_instance, item.name)
		)

	if is_boss_open_inventory:
		var item_btn_instance_root = item_btn.instantiate() as Control
		item_container.add_child(item_btn_instance_root)
		var item_btn_instance = item_btn_instance_root.get_child(1) as Button
		item_btn_instance.name = "Give_Nothing__button"
		item_btn_instance.text = "Nothing"
		item_btn_instance.connect(
			"pressed", _on_item_button_pressed.bind(item_btn_instance, "Give Nothing")
		)


# region signal handlers


func _on_func_toggle_inventory_ui_btn_pressed() -> void:
	toggle_inventory_ui()
	select_sound.play()


func _on_item_button_mouse_entered(_event: InputEvent, button: Button, base_item: BaseItem) -> void:
	item_attribute_container.visible = true
	item_attribute_container.position = button.get_global_mouse_position()
	item_name.text = base_item.name
	item_description.text = base_item.description


func _on_item_button_mouse_exited() -> void:
	item_attribute_container.visible = false


func _on_item_button_pressed(_button: Button, selected_item_name: String) -> void:
	select_sound.play()
	if !is_boss_open_inventory:
		print(system_name, "Item button pressed without boss context, ignoring.")
		return
	GameManager.tomas_recieve_item(selected_item_name)
	print(system_name, "Item button pressed:", selected_item_name)
	close_inventory_ui()
	is_boss_open_inventory = false


# endregion signal handlers


func _on_func_toggle_inventory_ui_btn_mouse_entered() -> void:
	cursor_sound.play()
