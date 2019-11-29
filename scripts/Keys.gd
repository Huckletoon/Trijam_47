extends Node

var cSound = preload("res://sound/C.wav")
var cSharpSound = preload("res://sound/Csharp.wav")
var dSound = preload("res://sound/D.wav")
var eFlatSound = preload("res://sound/Eflat.wav")
var eSound = preload("res://sound/E.wav")
var fSound = preload("res://sound/F.wav")
var fSharpSound = preload("res://sound/Fsharp.wav")
var gSound = preload("res://sound/G.wav")
var gSharpSound = preload("res://sound/Gsharp.wav")
var aSound = preload("res://sound/A.wav")
var bFlatSound = preload("res://sound/Bflat.wav")
var bSound = preload("res://sound/B.wav")

var whole = preload("res://wholeNote.png")
var half = preload("res://halfNote.png")
var quarter = preload("res://quarterNote.png")
var eighth = preload("res://eighthNote.png")
var sixteenth = preload("res://sixteenthNote.png")

var OkayButton = preload("res://Okay.tscn")
var NotePart = preload("res://NotePart.tscn")

var rng = RandomNumberGenerator.new()
var keys = []
var target = -1
var targetKey
var previous = -10
var audioArray = []
var complete = false
var cMajor = [0, 2, 4, 5, 7, 9, 11]
var cMinor = [0, 2, 3, 5, 7, 8, 10]
var cDorian = [0, 2, 3, 5, 7, 9, 10]
var cPhrygian = [0, 1, 3, 5, 7, 8, 10]
var cLydian = [0, 2, 4, 6, 7, 9, 11]
var cMixolydian = [0, 2, 4, 5, 7, 9, 10]
var cLocrian =[0, 1, 3, 5, 6, 8, 10]
var scale
var keysHit = []
var timeSinceLast = 0
var scaleString

onready var label = get_node("../Label")
onready var audio = get_node("../Sound")

func _ready():
	rng.randomize()
	keys.append($"C")
	keys.append($"C#")
	keys.append($"D")
	keys.append($"Eb")
	keys.append($"E")
	keys.append($"F")
	keys.append($"F#")
	keys.append($"G")
	keys.append($"G#")
	keys.append($"A")
	keys.append($"Bb")
	keys.append($"B")
	
	audioArray.append(cSound)
	audioArray.append(cSharpSound)
	audioArray.append(dSound)
	audioArray.append(eFlatSound)
	audioArray.append(eSound)
	audioArray.append(fSound)
	audioArray.append(fSharpSound)
	audioArray.append(gSound)
	audioArray.append(gSharpSound)
	audioArray.append(aSound)
	audioArray.append(bFlatSound)
	audioArray.append(bSound)
	
	setTarget()

func _physics_process(delta):
	timeSinceLast += delta

func setTarget():
	var rand = rng.randi_range(0, 6)
	match rand:
		0: 
			scale = cMajor
			scaleString = "C Major"
		1: 
			scale = cMinor
			scaleString = "C Minor"
		2: 
			scale = cDorian
			scaleString = "C Dorian"
		3: 
			scale = cPhrygian
			scaleString = "C Phrygian"
		4: 
			scale = cLydian
			scaleString = "C Lydian"
		5: 
			scale = cMixolydian
			scaleString = "C Mixolydian"
		6: 
			scale = cLocrian
			scaleString = "C Locrian"
	for note in scale:
		keys[note].set_modulate(Color(0.4, 0.8, 0.2, 1))
	var problemStart = scaleString == "C Locrian" or scaleString == "C Phrygian"
	var problemEnd = scaleString == "C Dorian" or scaleString == "C Mixolydian"
	target = rng.randi_range(0,6)
	while (target == 0 and problemStart) or (target == 6 and problemEnd):
		target = rng.randi_range(0,6)
	targetKey = keys[scale[target]]
	targetKey.set_modulate(Color(0.9, 0.8, 0.2, 1))
	target = scale[target]
	label.text = scaleString


func _on_C_input_event(viewport, event, shape_idx, keyIndex):
	if event.is_class("InputEventMouseButton") and event.pressed and !complete:
		
		audio.stream = audioArray[keyIndex]
		audio.play()
		
		var part = NotePart.instance()
		part.position = Vector2(rng.randi_range(60, 800), rng.randi_range(400, 510))
		if timeSinceLast > 2: part.texture = whole
		elif timeSinceLast > 1: part.texture = half
		elif timeSinceLast > 0.5: part.texture = quarter
		elif timeSinceLast > 0.25: part.texture = eighth
		else: part.texture = sixteenth
		timeSinceLast = 0
		var rand = rng.randi_range(0, 4)
		match rand:
			0:
				part.set_modulate(Color(0.2, 0.2, 1, 1))
			1:
				part.set_modulate(Color(0.5, 0.5, 1, 1))
			2:
				part.set_modulate(Color(0.6, 0.9, 0.9, 1))
			3:
				part.set_modulate(Color(0.2, 0.6, 0.7, 1))
			4:
				part.set_modulate(Color(0.2, 0.9, 0.6, 1))
		part.vel = Vector2(rng.randi_range(-10, 10), rng.randi_range(0, 10))
		get_parent().add_child(part)
		
		if keyIndex == target:
			if (previous == target - 2 or previous == target + 2) and keysHit.size() == 6:
				complete = true
				keys[keyIndex].set_modulate(Color(0.8, 0.8, 1, 1))
				get_tree().current_scene.done()
			else:
				pass #fail
		else:
			previous = keyIndex
			if scale.has(keyIndex):
				keys[keyIndex].set_modulate(Color(0.8, 0.8, 1, 1))
				if !keysHit.has(keyIndex): keysHit.append(keyIndex)
			else:
				for note in scale:
					if note != target:
						keys[note].set_modulate(Color(0.4, 0.8, 0.2, 1))
				keysHit.clear()
				part.set_modulate(Color(0.9, 0.1, 0.1, 1))
		