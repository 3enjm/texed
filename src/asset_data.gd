@abstract
class_name AssetData
extends Resource

enum AssetType {
	SPRITE,
	ROOM
}

@abstract
func set_image(img: Image) -> void
@abstract
func get_image() -> Image
@abstract
func set_fg_colour(colour: Color) -> void
@abstract
func get_fg_colour() -> Color
@abstract
func set_tex_data_array(tex_data: Array) -> void
@abstract
func get_tex_data_array() -> Array
@abstract
func get_asset_type() -> AssetType
