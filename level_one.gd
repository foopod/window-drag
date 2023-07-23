extends Node2D

@export var brick_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for n in 10:
		var brick = brick_scene.instantiate()
		brick.position = Vector2(200 + 100 * n, 300)
		var sprite = brick.get_child(0)
		sprite.frame = n
		add_child(brick)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
