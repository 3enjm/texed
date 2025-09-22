@abstract
class_name AssetData
extends Resource

enum Type {
	SPRITE,
	ROOM
}

enum SubType {
	NONE,
	CREATURE,
	ITEM
}

func set_image(img: Image) -> void:
	return
func get_image() -> Image:
	return Image.new()

func set_fg_colour(colour: Color) -> void:
	return
func get_fg_colour() -> Color:
	return Color.WHITE

func set_bg_colour(colour: Color) -> void:
	return
func get_bg_colour() -> Color:
	return Color.BLACK

func set_tex_data_array(tex_data: Array[bool]) -> void:
	return
func get_tex_data_array() -> Array[bool]:
	return [false]
