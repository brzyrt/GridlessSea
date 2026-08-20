extends Control

@export var gridColorA : Color
@export var gridColorB : Color

@onready var noteObject = load("res://scenes/objects/note.tscn")
@onready var timeRectangle = load("res://scenes/objects/time_rectangle.tscn")
@onready var timeGrid : HBoxContainer = $TimeGrid
var timeNum = 4
var timeDem = 4
var snapType #hard snap, soft snap, no snap. more i think i forgor

#keep track of note objects, out of view noteData 
#possibly also notes added modified or deleted since last save?
#	this sounds like it could be a headache but rewriting the entire file every save seems crazy
#	note modifications could be recorded as both a deletion and addition,
#		this would be much easier to implement with little downside

var noteObjects : Array[Note]
## notes that still exist but are currently not in view (not represented by a note object)
var oovNotes : Array[NoteData]

var timeGridRects : Array[ColorRect]

var hoveredNote : Note
var noteHovered = false
var pixelsPerBeat : int = 100

var transportTransform : Rect2 #rectangle of what note data is currently being displayed, in beats, hz
var previousTransportTransform : Rect2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Note.selfScene = load(Note.selfScenePath)
	
	transportTransform = Rect2(0, 0, 20, 500)
	previousTransportTransform = transportTransform
	generateBeatGrid()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !Input.is_action_pressed("Alt") and !Input.is_action_pressed("Ctrl"):
			if !Input.is_action_pressed("Shift"):
				if event.button_index == 4:
					transportTransform.position.x -= 2
				if event.button_index == 5:
					transportTransform.position.x += 2
			else:
				if event.button_index == 4:
					transportTransform.size.x *= 1.2
				if event.button_index == 5:
					transportTransform.size.x *= 0.8333
		
		if event.button_index == 4 || event.button_index == 5:
			generateBeatGrid()
		
		if event.double_click == true && event.button_index == 1:
			_add_note(get_global_mouse_position())
			

func _add_note(_position : Vector2i = Vector2.ZERO) -> void:
	var note : Control = noteObject.instantiate()
	note.position = _position
	noteObjects.append(note)
	add_child(note)

func generateBeatGrid():
	var currentWidth : int = 0
	var oddColor : bool = false
	var beat : int = ceil(transportTransform.position.x)
	for rect in timeGridRects:
		rect.queue_free()
	timeGridRects.clear()
	
	print(transportTransform)
	var beatRemainder : float = 1 - fmod(transportTransform.position.x, 1)
	if beatRemainder != 0:
		currentWidth += addBeatRect(beatRemainder * getBeatWidth(), oddColor)
	
	var safety : int = 0
	while(currentWidth < get_viewport_rect().size.x - getBeatWidth()):
		oddColor = !oddColor
		var labelText : String = ""
		if(beat % timeDem == 0 || false):
			labelText = str(beat/timeDem + 1) + "." + str(beat % timeDem + 1)
		currentWidth += addBeatRect(getBeatWidth(), oddColor, labelText)
		safety += 1
		beat += 1
	oddColor = !oddColor
	if currentWidth != get_viewport_rect().size.x:
		addBeatRect(get_viewport_rect().size.x - currentWidth, oddColor)
	
func addBeatRect(width : float, oddColor : bool, labelText : String = "") -> int:
	var rect : ColorRect = ColorRect.new()
	var label : Label = Label.new()
	
	rect.set_anchors_preset(Control.PRESET_LEFT_WIDE)
	rect.custom_minimum_size.x = width
	rect.color = gridColorA if oddColor else gridColorB
	timeGrid.add_child(rect)
	
	label.text = labelText
	label.z_index = 1
	rect.add_child(label)
	
	timeGridRects.append(rect)
	return width

func getBeatWidth() -> int:
	return get_viewport_rect().size.x/transportTransform.size.x
