extends Node

@onready var canvas: Node2D = %Canvas
@onready var camera_2d: Camera2D = %Camera2D

###
# UI
###

# Project Wide Controls
@onready var project_save_button: Button = %ProjectSaveButton
@onready var project_load_button: Button = $MainUI/Control/MarginContainer/HBoxContainer2/VBoxContainer2/PanelContainer/HBoxContainer/ProjectLoadButton
@onready var app_exit_button: Button = $MainUI/Control/MarginContainer/HBoxContainer2/VBoxContainer2/PanelContainer/HBoxContainer/AppExitButton

@onready var init_panel: Panel = %InitPanel

@onready var canvas_viewport: SubViewport = %CanvasViewport
@onready var toggle_grid_button: Button = %ToggleGridButton
@onready var grid_texture_rect: TextureRect = %GridTextureRect
@onready var canvas_save_button: Button = %CanvasSaveButton
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

# Assets that have not been written to disk
var assets: Dictionary[RID, AssetData] = {}
var active_rid: RID
var last_hash: int = 0

var asset_list_map: Array[RID] = []

var ed_mode: EditorMode = EditorMode.SPRITE_EDIT
var ed_smode: EditorMode = EditorMode.NO_SUBMODE

func _ready() -> void:
	new_asset_button.pressed.connect(_on_create_asset)
	init_asset_button.pressed.connect(_on_create_asset)
	var sd := SpriteData.new()
	assets[sd.get_rid()] = sd

func _on_create_asset() -> void:
	var new_asset: AssetData 
	if ed_mode == EditorMode.SPRITE_EDIT:
		new_asset = SpriteData.new()
	active_rid = new_asset.get_rid()
	assets[active_rid] = new_asset
	last_hash = hash(new_asset)
	populate_asset_list()
	

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
	if ed_mode == EditorMode.SPRITE_EDIT || \
		ed_mode == EditorMode.ROOM_EDIT:
	
		if canvas.active_tile_map.get_used_cells().count() > 0:
			canvas.brush.visible = false
			await RenderingServer.frame_post_draw
			var vp_image := canvas_viewport.get_texture().get_image()
			vp_image.resize(64,64)
			#active_asset_data[ed_mode].set_image(vp_image)
			asset_list.add_item("", ImageTexture.create_from_image(vp_image))
			canvas.brush.visible = true
		else:
			print("Nothing Saved")

func change_ed_mode(mode: EditorMode) -> void:
	if mode != ed_mode:
		if mode == EditorMode.SPRITE_EDIT:
			camera_2d.zoom = Vector2(1.0, 1.0)
			(grid_texture_rect.material as ShaderMaterial).set_shader_parameter("scale", 1.0)
			new_asset_button.text = "New Sprite"
			init_asset_button.text = "New Sprite"
			
		elif mode == EditorMode.ROOM_EDIT:
			camera_2d.zoom = Vector2(0.5, 0.5)
			(grid_texture_rect.material as ShaderMaterial).set_shader_parameter("scale", 2.0)
			new_asset_button.text = "New Room"
			init_asset_button.text = "New Room"

		ed_mode = mode

func populate_asset_list() -> void:
	asset_list.clear()
	asset_list_map.clear()
	for a_data in assets.values():
		if EditorMode.SPRITE_EDIT and a_data is SpriteData:
			#TODO: Sort these into sub categories
			var idx := asset_list.add_icon_item(ImageTexture.create_from_image(a_data.get_image()))
			asset_list_map.set(idx, active_rid)

func _on_asset_list_item_selected(index: int) -> void:
	#TODO: If changes have been made ask about it. Then load image data into tilemap layer
	if last_hash != hash(assets[active_rid]):
		print("NEED TO SAVE! LOST EVERYTHING!")

	active_rid = asset_list_map[index]
	last_hash = hash(assets[active_rid])
	#TODO: Update canvas from data we pulled

func _on_canvas_save_button_pressed() -> void:
	if ed_mode == EditorMode.SPRITE_EDIT || \
		ed_mode == EditorMode.ROOM_EDIT:
	
		#TODO: Change this so that we see if the sprite was changed
		if canvas.active_tile_map.get_used_cells().size() > 0:
			canvas.brush.visible = false
			await RenderingServer.frame_post_draw
			var vp_image := canvas_viewport.get_texture().get_image()
			vp_image.resize(64,64)
			assets[active_rid].set_image(vp_image)
			#asset_list.add_item("", ImageTexture.create_from_image(vp_image))
			#assets[active_asset_data[ed_mode].get_asset_type()].push_back(active_asset)
			canvas.brush.visible = true
		else:
			print("Nothing Saved")


func _on_project_save_button_pressed() -> void:
	pass # Replace with function body.
