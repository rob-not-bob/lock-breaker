extends AudioStreamPlayer

func _ready():
	stop() if OS.is_debug_build() else null;
