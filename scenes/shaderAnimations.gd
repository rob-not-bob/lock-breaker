extends AnimationPlayer


func _ready():
	EventBus.crit.connect(play.bind("crit"));

	EventBus.lost.connect(func(_score):
		play("screen_shake");
		await animation_finished;
		ScreenManager.switch_to(ScreenManager.Screens.TryAgain);
	);

	EventBus.mute.connect(func(is_muted: bool):
		play("mute", -1, 1 if is_muted else -1);
	);
