extends Node2D

func _ready():
	set_theme();
	$GameController.init();
	$EndlessMode.init();
	ScreenManager.switch_to(ScreenManager.Screens.Start);
	ScreenManager.start.connect(_start_game);
	ScreenManager.restart.connect(func(with_extra_life: bool):
		print('restart with extra life: %s' % with_extra_life);

		if not with_extra_life:
			set_theme();

		$GameController.restart();
		$EndlessMode.restart(with_extra_life);
	);


func set_theme():
	var theme = Themes.get_random_theme();
	EventBus.theme_set.emit(theme);
	$UI/GameUI/bg.color = theme.bg;
	%Score.modulate = theme.countdown;


func _start_game():
	%shaderAnimations.play("RESET");
	$UI/StaticGameUI.show();
	$EndlessMode.start();
	Ads.load(Ads.AdType.RewardedInterstitial);
