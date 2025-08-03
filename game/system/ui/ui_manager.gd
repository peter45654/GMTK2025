extends Node

@export var item_btn: PackedScene

var system_name: String = "[UIManager]"

@onready var user_interface: Control = $CanvasLayer/UserInterface
@onready var inventory_ui: Control = $CanvasLayer/InventoryPanel
@onready var item_container: Control = $CanvasLayer/InventoryPanel/ScrollContainer/GridContainer
@onready var item_attribute_container: Control = $CanvasLayer/ItemAttributePanel
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var item_name: Label = $CanvasLayer/ItemAttributePanel/VBoxContainer/item_name
@onready var item_description: Label = $CanvasLayer/ItemAttributePanel/VBoxContainer/item_description


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

	user_interface.visible = true
	inventory_ui.visible = false
	item_attribute_container.visible = false
	print(system_name, " UI Manager is ready.")


func toggle_inventory_ui() -> void:
	var items: Array = Inventory.get_items()
	# clear existing item buttons
	var children: Array = item_container.get_children()
	for child in children:
		if child is Label:
			child.queue_free()

	for item in items:
		print(system_name, "Item in inventory:", item.name, "Description:", item.description)
		var item_btn_instance = item_btn.instantiate() as Label
		item_container.add_child(item_btn_instance)
		item_btn_instance.name = item.name + "_label"
		item_btn_instance.text = item.name
		item_btn_instance.connect(
			"gui_input", _on_item_button_mouse_entered.bind(item_btn_instance, item)
		)
		item_btn_instance.connect("mouse_exited", _on_item_button_mouse_exited)


	if inventory_ui.visible:
		inventory_ui.visible = false
		print(system_name, " Inventory UI is now hidden.")
	else:
		inventory_ui.visible = true
		print(system_name, " Inventory UI is now visible.")


func _on_func_toggle_inventory_ui_btn_pressed() -> void:
	toggle_inventory_ui()


func _on_item_button_mouse_entered(_event: InputEvent, button: Label, base_item: BaseItem) -> void:
	item_attribute_container.visible = true
	item_attribute_container.position = button.get_global_mouse_position()
	item_name.text = base_item.name
	item_description.text = base_item.description

func _on_item_button_mouse_exited() -> void:
	item_attribute_container.visible = false
