extends CanvasLayer

@onready var crosshair = $TextureRect
@onready var crosshair_hit = $TextureRect2
@onready var hint = $hint

var hint_timer := 0.0
var hint_shown := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hint_shown:
		hint_timer += delta
		if hint_timer >= 7.0:
			hint.visible = false
			hint_shown = false
