extends AudioStreamPlayer

var maxvol = -20
var minvol = -70

func _ready():
	volume_db = lerp(minvol, maxvol, 0.8)

func _on_VSlider_value_changed(value):
	print(value)
	volume_db = lerp(minvol, maxvol, value/100)
