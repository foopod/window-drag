extends Node

var first_load : bool = true
var window : Window
var screen : int
var screen_size : Vector2i
var screen_position : Vector2i
var screen_scale_ratio : float
var target_height = ProjectSettings.get_setting("display/window/size/viewport_height")
var target_width = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var virtual_window : Control = get_node("/root/Main/VirtualWindow")

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if first_load:
		# For some reason setting the position in _ready() does not do anything
		reset_window()
		first_load = false
	
	# For when the window changes screens
	if window.current_screen != screen:
		reset_window()
	
func reset_window():
	window = get_window()
	screen = window.current_screen
	
	var usable_rect = DisplayServer.screen_get_usable_rect(screen).size
	screen_scale_ratio = min(float(usable_rect.x) / target_width,
		float(usable_rect.y) / target_height)
	
	screen_size = Vector2i(screen_scale_ratio * Vector2i(target_width, target_height))
	screen_position = DisplayServer.screen_get_position(screen) + (usable_rect - screen_size) / 2
	
	window.set_size(screen_size)
	window.set_position(screen_position)
	virtual_window.update_mouse_passthrough()