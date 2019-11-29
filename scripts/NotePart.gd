extends Sprite

var vel = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	position += vel
	vel = lerp(vel, Vector2.ZERO, 0.15)
	if vel.length() < 0.02: queue_free()