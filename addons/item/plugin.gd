@tool
extends EditorPlugin


var resource_translation_plugin


func _enter_tree() -> void:
	resource_translation_plugin = preload('res://addons/item/parse_plugin.gd').new()
	add_translation_parser_plugin(resource_translation_plugin)


func _exit_tree() -> void:
	if is_instance_valid(resource_translation_plugin):
		remove_translation_parser_plugin(resource_translation_plugin)
		resource_translation_plugin = null
