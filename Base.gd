extends Node2D

var OkayButton = preload("res://Okay.tscn")
var Keys = preload("res://Keys.tscn")

var keys
var okay

func _ready():
	keys = Keys.instance()
	add_child(keys)

func done():
	okay = OkayButton.instance()
	okay.position = Vector2(900, 500)
	add_child(okay)
	okay.connect("input_event", self, "okayClick")

func okayClick(viewport, event, shape_idx):
	if event.is_class("InputEventMouseButton") and !event.pressed:
		keys.queue_free()
		keys = null
		okay.queue_free()
		okay = null
		keys = Keys.instance()
		add_child(keys)
		
