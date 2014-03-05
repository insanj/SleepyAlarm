#import "SleepyAlarm.h"

static UIBarStyle slOriginalStyle = UIBarStyleDefault;
void sl_darken(BOOL should, UITableView *tableView) {
	UITabBarController *tabBarController = (UITabBarController *) [UIApplication sharedApplication].keyWindow.rootViewController;
	UINavigationController *navigationController = (UINavigationController *) tabBarController.viewControllers[1];

	if(should && ![[SLSETTINGS objectForKey:@"preventDarken"] boolValue]) {
		tableView.backgroundColor = [UIColor blackColor];
		slOriginalStyle = tabBarController.tabBar.barStyle;
		tabBarController.tabBar.barStyle = navigationController.navigationBar.barStyle = UIBarStyleBlack;
	}

	else {
		tableView.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1];
		tabBarController.tabBar.barStyle = navigationController.navigationBar.barStyle = slOriginalStyle;
	}
}

%hook AlarmViewController

- (void)viewDidAppear:(BOOL)animated {
	sl_darken(YES, MSHookIvar<UITableView *>(self, "_tableView"));
	%orig(animated);
}

- (void)viewDidDisappear:(BOOL)animated {
	sl_darken(NO, MSHookIvar<UITableView *>(self, "_tableView"));
	%orig(animated);
}

%end

%hook AlarmTableViewCell

-(void)internalSetBackgroundColor:(UIColor *)arg1{
	BOOL shouldDarken = ![[SLSETTINGS objectForKey:@"preventDarken"] boolValue];
	%orig(shouldDarken ? [UIColor blackColor] : arg1);

	if([arg1 isEqual:[UIColor whiteColor]]) {
		AlarmView *alarmView = [self.contentView.subviews firstObject];
		for(UIView *v in alarmView.subviews) {
			if([v isKindOfClass:[UILabel class]]) {
				((UILabel *)v).textColor = shouldDarken ? [UIColor whiteColor] : [UIColor darkGrayColor];
			}
		}
	}

}

-(void)layoutSubviews{
	%orig();

	BOOL shouldDarken = ![[SLSETTINGS objectForKey:@"preventDarken"] boolValue];
	AlarmView *alarmView = [self.contentView.subviews firstObject];
	for(UIView *v in alarmView.subviews) {
		if([v isKindOfClass:[UISwitch class]]) {
				((UISwitch *)v).onTintColor = shouldDarken ? [UIColor redColor] : [UIColor greenColor];
		}
	}
}

%end
