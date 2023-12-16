extends Node2D

func _ready():
	$GameController.init();
	$EndlessMode.init();

	Themes.theme_set.connect(set_theme)
	Themes.get_random_theme();

	ScreenManager.switch_to(ScreenManager.Screens.Start);
	ScreenManager.start.connect(_start_game);
	ScreenManager.restart.connect(func():
		$GameController.restart();
		$EndlessMode.restart();
	);


func set_theme(theme: Dictionary) -> void:
	$UI/GameUI/bg.color = theme.bg;
	%Score.add_theme_color_override("font_color", theme.countdown);


func _start_game():
	%shaderAnimations.play("RESET");
	$UI/StaticGameUI.show();
	$EndlessMode.start();
	Ads.load(Ads.AdType.RewardedInterstitial);
