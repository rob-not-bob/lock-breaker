extends Marker2D

var text: String:
	set(new_text):
		text = new_text;
		$Label.text = text;
var color: Color:
	set(new_color):
		color = new_color;
		$Label.add_theme_color_override('font_color', color);
var size: int:
	set(new_size):
		size = new_size;
		var label: Label = $Label;
		label.add_theme_font_size_override('font_size', size);


var velocity := Vector2.ZERO;


func _ready() -> void:
	var tween = create_tween()\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC);

	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2);
	# tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.35);

	# tween.set_parallel();
	# tween.tween_property(self, "scale", Vector2(0.1, 0.1), 0.35);
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.35).set_delay(0.25);

	tween.chain().tween_callback(queue_free);

	velocity = Vector2(0, -200);


func _process(delta: float) -> void:
	position += velocity * delta;
