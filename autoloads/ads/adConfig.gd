const types = preload("./types.gd");
const AdType = types.AdType;
const Platform = types.Platform;
const Env = types.Env;

const ADS = {
	Platform.Android: {
		AdType.Banner: {
			Env.Test: "ca-app-pub-3940256099942544/6300978111",
			Env.Prod: "ca-app-pub-3502216226418364/3112329634"
		},
		AdType.RewardedInterstitial: {
			Env.Test: "ca-app-pub-3940256099942544/5354046379",
			Env.Prod: "ca-app-pub-3502216226418364/6560633366"
		}
	},
	Platform.IOS: {
		AdType.Banner: {
			Env.Test: "ca-app-pub-3940256099942544/6978759866",
			Env.Prod: "NOT-YET-IMPLEMENTED"
		},
		AdType.RewardedInterstitial: {
			Env.Test: "NOT-YET-IMPLEMENTED",
			Env.Prod: "NOT-YET-IMPLEMENTED"
		}
	}
}
