extends Node2D

var image

# Called when the node enters the scene tree for the first time.
func _ready():
	image = get_node('Sprite2D')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	image.position = Vector2(-get_window().position.x + 800,-get_window().position.y + 650)
	pass
