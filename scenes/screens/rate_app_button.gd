extends TextureButton

var reviewFlowLaunched := false;
func _ready():
	pass
	#GooglePlayInAppReview.review_info_requested.connect(func(was_successful: bool):
	#	DebugUI.log("Review info requested %s" % "successfully" if was_successful else "unsucessfully")
	#	if was_successful and not reviewFlowLaunched:
	#		reviewFlowLaunched = true;
	#		GooglePlayInAppReview.launchReviewFlow();
	#)
	#GooglePlayInAppReview.review_flow_complete.connect(func():
	#	DebugUI.log("Review flow completed");
	#)


func _on_button_up():
	#GooglePlayInAppReview.requestReviewInfo();
	var link := "https://play.google.com/store/apps/details?id=net.rcallen.LockBreaker";
	match OS.get_name():
		"Android":
			link = "https://play.google.com/store/apps/details?id=net.rcallen.LockBreaker";
		"iOS":
			link = "https://binarysunrise.dev/games/lock_breaker";

	OS.shell_open(link);
