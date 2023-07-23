extends Node2D

@export var brick_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	for n in 19:
		for m in 5:
			var brick = brick_scene.instantiate()
			brick.position = Vector2(60 + 100 * n, 200 + 100 * m)
			var sprite = brick.get_child(0)
			sprite.frame = rng.randi_range(0,9)
			add_child(brick)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
