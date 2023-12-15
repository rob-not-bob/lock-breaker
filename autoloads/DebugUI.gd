extends CanvasLayer

func _ready():
	hide();


func log(text: String):
	print(text);
	%DebugText.append_text(text + "\n");
