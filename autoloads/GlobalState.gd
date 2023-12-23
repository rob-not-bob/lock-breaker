extends Node

func _ready() -> void:
	SignInClient.user_authenticated.connect(func(is_authenticated: bool) -> void:
		is_signed_in_google_play = is_authenticated;
	);
	SignInClient.is_authenticated();

var is_signed_in_google_play := false;
var allow_extra_life := true;
