extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

@onready var next_indicator = $NinePatchRect/Control2/NextIndicator

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_timer = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying()

func _ready():
	scale = Vector2.ZERO #bouncing effect
	
func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await  resized
		await  resized
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x /2
	global_position.y -= size.y + 24
	
	label.text = ""
	
	pivot_offset = Vector2(size.x / 2, size.y) #will make text scale from bottopm center
	var tween = get_tree().create_tween()
	tween.tween_property(
		self, "scale", Vector2(1, 1), 0.15
	).set_trans(
		Tween.TRANS_BACK
	)
	_display_letter()

func _display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		next_indicator.visible = true #hides untill next text is true
		return
	
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_timer)

func _on_letter_display_timer_timeout():
	_display_letter()

