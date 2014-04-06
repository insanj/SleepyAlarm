#import "SleepyAlarm.h"

%group Darken

%hook AlarmViewController

%new - (void)slShouldDarken:(BOOL)should {
	UITabBarController *tabBarController = (UITabBarController *) [UIApplication sharedApplication].keyWindow.rootViewController;
	UINavigationController *navigationController = (UINavigationController *) tabBarController.viewControllers[1];
	UITableView *tableView = MSHookIvar<UITableView *>(self, "_tableView");

	if (should) {
		tableView.backgroundColor = [UIColor blackColor];
		tabBarController.tabBar.barStyle = navigationController.navigationBar.barStyle = UIBarStyleBlack;
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	}

	else {
		tableView.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1];
		tabBarController.tabBar.barStyle = navigationController.navigationBar.barStyle = UIBarStyleDefault;
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[self slShouldDarken:YES];
	%orig(animated);
}

// If this is alone, it will graphically glitch when dismissing add view, but
// will be effective afterwards (-willAppear alone won't work first view).
- (void)viewDidAppear:(BOOL)animated {
	[self slShouldDarken:YES];
	%orig(animated);
}

- (void)viewDidDisappear:(BOOL)animated {
	[self slShouldDarken:NO];
	%orig(animated);
}

%end

%hook AlarmTableViewCell

- (void)internalSetBackgroundColor:(UIColor *)arg1 {
	%orig([UIColor blackColor]);

	if ([arg1 isEqual:[UIColor whiteColor]]) {
		AlarmView *alarmView = [self.contentView.subviews firstObject];
		for (UIView *v in alarmView.subviews) {
			if ([v isKindOfClass:[UILabel class]]) {
				((UILabel *)v).textColor = [UIColor whiteColor];
			}
		}
	}
}

- (void)layoutSubviews {
	%orig();

	AlarmView *alarmView = [self.contentView.subviews firstObject];
	for (UIView *v in alarmView.subviews) {
		if ([v isKindOfClass:[UISwitch class]]) {
			((UISwitch *)v).onTintColor = [UIColor redColor];
		}
	}
}

%end

%end // %group Darken

%ctor {
	if (![[SLSETTINGS objectForKey:@"preventDarken"] boolValue]) {
		%init(Darken);
	}
}
