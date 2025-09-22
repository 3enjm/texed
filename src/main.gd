extends Node

@onready var canvas: Node2D = %Canvas
@onready var camera_2d: Camera2D = %Camera2D

###
# UI
###
@onready var canvas_viewport: SubViewport = %CanvasViewport
@onready var toggle_grid_button: Button = %ToggleGridButton
@onready var grid_texture_rect: TextureRect = %GridTextureRect
@onready var fg_colour_field: HBoxContainer = %FGColourField
@onready var fg_color_picker_button: ColorPickerButton = %ColourField/FGColorPickerButton

# Asset Explorer UI
@onready var new_asset_button: Button = %NewAssetButton
@onready var asset_explorer_header: Label = %AssetExplorerHeader
@onready var asset_list: ItemList = %AssetList
@onready var init_asset_button: Button = %InitAssetButton

enum EditorMode {
	SPRITE_EDIT,
	ROOM_EDIT, # -> View Edit
	LAYOUT_EDIT,
	# Submodes
	NO_SUBMODE,
	ROOM_EDIT_PLACEMENT,
	ROOM_EDIT_POSITION,
}

var assets: Dictionary[AssetData.Type, Array] = {}

var active_asset_data: AssetData

var active_ed_mode: EditorMode = EditorMode.SPRITE_EDIT
var active_ed_smode: EditorMode = EditorMode.NO_SUBMODE

func _on_toggle_grid_button_toggled(toggled_on: bool) -> void:
	grid_texture_rect.visible = toggled_on

func _on_fg_color_picker_button_color_changed(color: Color) -> void:
	canvas.fg_colour = color

func _on_tab_bar_tab_changed(tab: int) -> void:
	match(tab):
		0: change_ed_mode(EditorMode.SPRITE_EDIT)
		1: change_ed_mode(EditorMode.ROOM_EDIT)

func _on_save_button_pressed() -> void:
	#TODO: Are we writing room data or sprite data?
	#TODO: Write data
	if active_ed_mode == EditorMode.SPRITE_EDIT || \
		active_ed_mode == EditorMode.ROOM_EDIT:
	
		canvas.brush.visible = false
		await RenderingServer.frame_post_draw
		var vp_image := canvas_viewport.get_texture().get_image()
		vp_image.resize(64,64)
		active_asset_data.set_image(vp_image)
		asset_list.add_item("", ImageTexture.create_from_image(vp_image))
		canvas.brush.visible = true

func change_ed_mode(mode: EditorMode) -> void:
	if mode != active_ed_mode:
		if mode == EditorMode.SPRITE_EDIT:
			camera_2d.zoom = Vector2(1.0, 1.0)
			(grid_texture_rect.material as ShaderMaterial).set_shader_parameter("scale", 1.0)
			
		elif mode == EditorMode.ROOM_EDIT:
			camera_2d.zoom = Vector2(0.5, 0.5)
			(grid_texture_rect.material as ShaderMaterial).set_shader_parameter("scale", 2.0)
		active_ed_mode = mode

func _on_asset_list_item_selected(index: int) -> void:
	pass # Replace with function body.
