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
@onready var item_list: ItemList = %ItemList

var sprite_data_resource: SpriteData = SpriteData.new()

func _on_toggle_grid_button_toggled(toggled_on: bool) -> void:
	grid_texture_rect.visible = toggled_on

func _on_fg_color_picker_button_color_changed(color: Color) -> void:
	canvas.fg_colour = color

func _on_tab_bar_tab_changed(tab: int) -> void:
	if tab == 0:
		camera_2d.zoom = Vector2(1.0, 1.0)
		(grid_texture_rect.material as ShaderMaterial).set_shader_parameter("scale", 1.0)
	elif tab == 1:
		camera_2d.zoom = Vector2(0.5, 0.5)
		(grid_texture_rect.material as ShaderMaterial).set_shader_parameter("scale", 2.0)

func _on_save_button_pressed() -> void:
	#TODO: Are we writing room data or sprite data?
	#TODO: Write data
	canvas.brush.visible = false
	await RenderingServer.frame_post_draw
	var vp_image := canvas_viewport.get_texture().get_image()
	vp_image.resize(64,64)
	item_list.add_item("", ImageTexture.create_from_image(vp_image))
	canvas.brush.visible = true
