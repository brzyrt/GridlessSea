extends Control

@onready var noteObject = load("res://scenes/objects/note.tscn")

var hoveredNote : Note
var noteHovered = false
var pixelsPerBeat : int = 100
var leftMostBeat : float = 0
var coordVector : Vector2 = Vector2(20, 500) #(beats, hz)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_note() -> void:
	var note : Control = noteObject.instantiate()
	note.position = Vector2.ONE * 100
	add_child(note)
