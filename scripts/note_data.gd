class_name NoteData


var frequencyInteger : int
var frequencyFrac : float
##note position in ticks
var position : int
##note length in ticks
var length : int

func _init(_freq, _position, _length) -> void:
	setFrequency(_freq)
	position = _position
	length = _length

func setFrequency(_frequency : float):
	frequencyInteger = floor(_frequency)
	frequencyFrac = _frequency - floor(_frequency)

func getFrequency() -> float:
	return frequencyInteger + frequencyFrac

func getPositionAsBeats() -> float:
	return float(position)/float(Global.tickRate)

func getLengthAsBeats() -> float:
	return float(length)/float(Global.tickRate)
