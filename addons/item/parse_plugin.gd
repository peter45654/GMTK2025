@tool
extends EditorTranslationParserPlugin

# 可以根據你的需求修改
const RESOURCE_CLASSES_AND_PROPERTIES = {
	"MyDialogueData": ["dialogue_text", "npc_name"],
	"QuestData": ["quest_title", "quest_description"]
}


func _parse_file(path: String) -> Array[PackedStringArray]:
	var ret: Array[PackedStringArray] = []
	var res = ResourceLoader.load(path, "BaseItem")
	if res is not BaseItem:
		print("跳過處裡非 BaseItem 物品 path:",path)	
		return []
	
	print("處裡 path:",path)
	#var text = res.source_code
	var baseItem=res as BaseItem
	ret.append(PackedStringArray([baseItem.name,""]))
	ret.append(PackedStringArray([baseItem.description,""]))

	return ret
		
func _get_recognized_extensions() -> PackedStringArray:
	return ["tres"]
