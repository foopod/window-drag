extends Control
# Adapted from https://github.com/finepointcgi/Drag-Rescale-and-Drop-Windows
# under the following license:
#
# MIT License
#
# Copyright (c) 2023 FinepointCGI
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

var arrows_diagonal = load("res://icons/tabler/tabler-arrows-diagonal.png")
var arrows_diagonal_2 = load("res://icons/tabler/tabler-arrows-diagonal-2.png")
var arrows_move_horizontal = load("res://icons/tabler/tabler-arrows-move-horizontal.png")
var arrows_move_vertical = load("res://icons/tabler/tabler-arrows-move-vertical.png")
var arrows_move = load("res://icons/tabler/tabler-arrows-move.png")

var start : Vector2
var initialPosition : Vector2
var initialSize : Vector2

var isMoving : bool
var isResizing : bool

var resizeLeft : bool
var resizeRight : bool
var resizeTop : bool
var resizeBottom : bool

var left_relative_position : Vector2
var right_relative_position : Vector2
var top_relative_position : Vector2
var bottom_relative_position : Vector2

@export var ResizeThreshold := 25

func _ready():
	var virtual_window_start = get_node("World/LevelOne/VirtualWindowStart")
	# The virtual window will start with the same position and size as VirtualWindowStart
	set_position(virtual_window_start.get_position())
	set_size(virtual_window_start.get_size())
	%World.set_position(-get_global_position())

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Mouse is moving
		show_hovering_cursors()
		
		var displacement = event.position - start
		
		if isMoving:
			Input.set_custom_mouse_cursor(arrows_move)
			set_position(initialPosition + displacement)
			%World.set_position(-initialPosition - displacement)
			update_mouse_passthrough()
			
			# Move the walls to align with the virtual window
			%WallLeft.set_position(initialPosition + left_relative_position + displacement)
			%WallRight.set_position(initialPosition + right_relative_position + displacement)
			%WallTop.set_position(initialPosition + top_relative_position + displacement)
			%WallBottom.set_position(initialPosition + bottom_relative_position + displacement)
			
		if isResizing:
			var newWidth = get_size().x
			var newHeight = get_size().y
			
			if resizeRight:
				newWidth = initialSize.x + displacement.x
				%WallRight.set_position(Vector2((initialPosition + right_relative_position + displacement).x, %WallRight.get_position().y))
				
			if resizeBottom:
				newHeight = initialSize.y + displacement.y
				%WallBottom.set_position(Vector2(%WallBottom.get_position().x, (initialPosition + bottom_relative_position + displacement).y))
				
			if resizeLeft:
				newWidth = initialSize.x - displacement.x
				set_position(Vector2(initialPosition.x - (newWidth - initialSize.x), get_position().y))
				%World.set_position(-Vector2(initialPosition.x - (newWidth - initialSize.x), get_position().y))
				%WallLeft.set_position(Vector2((initialPosition + left_relative_position + displacement).x, %WallLeft.get_position().y))
			
			if resizeTop:
				newHeight = initialSize.y - displacement.y
				set_position(Vector2(get_position().x, initialPosition.y - (newHeight - initialSize.y)))
				%World.set_position(-Vector2(get_position().x, initialPosition.y - (newHeight - initialSize.y)))
				%WallTop.set_position(Vector2(%WallTop.get_position().x, (initialPosition + top_relative_position + displacement).y))
			
			set_size(Vector2(newWidth, newHeight))
			update_mouse_passthrough()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Left mouse just pressed
		var rect = get_global_rect()
		var localMousePos = event.position - get_global_position()
		if abs(localMousePos.x - rect.size.x) < ResizeThreshold:
			# Right side of window
			start.x = event.position.x
			initialSize.x = get_size().x
			isResizing = true
			resizeRight = true
		
		if abs(localMousePos.y - rect.size.y) < ResizeThreshold:
			# Bottom side of window
			start.y = event.position.y
			initialSize.y = get_size().y
			isResizing = true
			resizeBottom = true
		
		if localMousePos.x < ResizeThreshold && localMousePos.x > -ResizeThreshold:
			# Left side of window
			start.x = event.position.x
			initialPosition.x = get_global_position().x
			initialSize.x = get_size().x
			isResizing = true
			resizeLeft = true
		
		if localMousePos.y < ResizeThreshold && localMousePos.y > -ResizeThreshold:
			# Top side of window
			start.y = event.position.y
			initialPosition.y = get_global_position().y
			initialSize.y = get_size().y
			isResizing = true
			resizeTop = true
		
		if !isResizing && localMousePos.x > 0 && localMousePos.y > 0 && localMousePos.x < rect.size.x && localMousePos.y < rect.size.y:
			# Everywhere else within the window
			start = event.position
			initialPosition = get_global_position()
			isMoving = true
		
		# Get initial relative positions of walls
		left_relative_position = %WallLeft.get_position() - initialPosition
		right_relative_position = %WallRight.get_position() - initialPosition
		top_relative_position = %WallTop.get_position() - initialPosition
		bottom_relative_position = %WallBottom.get_position() - initialPosition
			
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		# Left mouse just released
		isMoving = false
		initialPosition = Vector2(0,0)
		resizeLeft = false
		resizeRight = false
		resizeTop = false
		resizeBottom = false
		isResizing = false
		Input.set_custom_mouse_cursor(null)
		

## We want to show alternative cursors when hovering over the border of the window
func show_hovering_cursors():
	var rect = get_global_rect()
	var localMousePos = get_global_mouse_position() - get_global_position()
	
	var hoveringRight = abs(localMousePos.x - rect.size.x) < ResizeThreshold
	var hoveringBottom = abs(localMousePos.y - rect.size.y) < ResizeThreshold
	var hoveringLeft = localMousePos.x < ResizeThreshold && localMousePos.x > -ResizeThreshold
	var hoveringTop = localMousePos.y < ResizeThreshold && localMousePos.y > -ResizeThreshold
	
	if (hoveringTop && hoveringLeft) || (hoveringBottom && hoveringRight):
		Input.set_custom_mouse_cursor(arrows_diagonal_2)
	elif (hoveringTop && hoveringRight) || (hoveringBottom && hoveringLeft):
		Input.set_custom_mouse_cursor(arrows_diagonal)
	elif hoveringTop || hoveringBottom:
		Input.set_custom_mouse_cursor(arrows_move_vertical)
	elif hoveringLeft || hoveringRight:
		Input.set_custom_mouse_cursor(arrows_move_horizontal)
	else:
		Input.set_custom_mouse_cursor(null)

## Pass mouse input events through if they aren't close enough to the virtual window to drag
func update_mouse_passthrough():
	# Note: The mouse passthrough polygon takes pixel values that map to the actual size of the
	# user's screen, not the viewport size.
	var low = Global.screen_scale_ratio * (get_position() - ResizeThreshold * Vector2.ONE)
	var high = Global.screen_scale_ratio * (get_position() + get_size() + ResizeThreshold * Vector2.ONE)
	var left = low.x
	var right = high.x
	var top = low.y
	var bottom = high.y
	var virtual_window_polygon := PackedVector2Array([
		Vector2(left, top),
		Vector2(left, bottom),
		Vector2(right, bottom),
		Vector2(right, top)
		])
	get_window().mouse_passthrough_polygon = virtual_window_polygon
