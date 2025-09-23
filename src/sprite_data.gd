class_name SpriteData
extends AssetData

enum SpriteType {
	CREATURE,
	ITEM,
	ROOM_TILE
}

var _asset_type: AssetData.AssetType = AssetData.AssetType.SPRITE : get = get_asset_type
func get_asset_type() -> AssetData.AssetType:
	return _asset_type

var sprite_type: SpriteType = SpriteType.CREATURE : get = get_sprite_type, set = set_sprite_type
func set_sprite_type(type: SpriteType) -> void:
	sprite_type = type
func get_sprite_type() -> SpriteType:
	return sprite_type

var tex_data_array: Array[bool] = [] : set = set_tex_data_array, get = get_tex_data_array
func set_tex_data_array(tex_data: Array[bool]) -> void:
	tex_data_array = tex_data
func get_tex_data_array() -> Array[bool]:
	return tex_data_array

var fg_colour: Color = Color.WHITE : set = set_fg_colour, get = get_fg_colour
func set_fg_colour(colour: Color) -> void:
	fg_colour = colour
func get_fg_colour() -> Color:
	return fg_colour

var image: Image : set = set_image, get = get_image
func set_image(img: Image) -> void:
	image = img
func get_image() -> Image:
	return image
