extends RigidBody2D

@export var min_speed = 300
func _integrate_forces(state):
	var velocity : Vector2 = state.get_linear_velocity()
	var speed = velocity.length()
	if speed < min_speed && speed != 0:
		state.set_linear_velocity(min_speed * velocity.normalized())
