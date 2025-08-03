extends Node

@export var items: Array[BaseItem] = []

var system_name: String = "[Inventory]"


func _ready() -> void:
	print(system_name, "Inventory system initialized with ", items.size(), " items.")


func is_have_item(item_name: String) -> bool:
	for item in items:
		if item.name == item_name:
			print(system_name, "Item found:", item_name)
			return true
	print(system_name, "Item not found:", item_name)
	return false


func on_boss_select(item_name: String) -> bool:
	for item in items:
		if item.name == item_name:
			# 執行 item 的 expression
			if  item.expression=="":
				print(system_name, "No expression to execute for item:", item_name)
				return true

			print(system_name, "Executing expression:", item.expression)
			var expression = Expression.new()
			var error := expression.parse(item.expression)
			if error:
				print(system_name, "Error parsing expression:", error)
				return false
			expression.execute()
			return true
	print(system_name, "Item not found, no expression to execute for item", item_name)
	return false


func test_call() -> void:
	print(system_name, "Test call executed.")
	print(system_name, "Inventory system initialized with ", items.size(), " items.")


func get_items() -> Array[BaseItem]:
	return items


func add_test_item() -> void:
	var test_item: BaseItem = BaseItem.new()
	test_item.name = "Test Item"
	test_item.description = "This is a test item."
	add_item(test_item)
	print(system_name, "Test item added:", test_item.name)


func add_item(item: BaseItem) -> void:
	if item not in items:
		items.append(item)
		print(system_name, "Added item: " + item.name)
	else:
		print(system_name, "Item already exists in inventory: " + item.name)


func remove_item(item: BaseItem) -> void:
	if item in items:
		items.erase(item)
		print(system_name, "Removed item: " + item.name)

func clear_inventory() -> void:
	items.clear()
	print(system_name, "Inventory cleared.")
