#import "SLListController.h"
#import "SLBannerButtonCell.h"
#import "version.h"

#define IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation SLListController

+ (NSString *)hb_specifierPlist {
	return @"SleepyAlarmPrefs";
}

+ (UIColor *)hb_tintColor {
	return [UIColor colorWithRed:51/255.0f green:55/255.0f blue:144/255.0f alpha:1.0f];
}

+ (NSString *)hb_shareText {
	return @"Easily calculate the healthiest & most comfortable time to wake up, right from the Clock app. SleepyAlarm by @insanj.";
}

+ (NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"http://insanj.github.io/SleepyAlarm/"];
}

- (void)loadView {
	[super loadView];

	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor colorWithRed:51/255.0f green:55/255.0f blue:144/255.0f alpha:1.0f];
	[UITableViewCell appearanceWhenContainedIn:self.class, nil].backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
	[UILabel appearanceWhenContainedIn:self.class, nil].textColor = [UIColor whiteColor];

	[self table].backgroundColor = [UIColor blackColor];
	[self table].tintColor = [UIColor colorWithRed:51/255.0f green:55/255.0f blue:144/255.0f alpha:1.0f];
	[self table].separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
	if (IS_IOS_OR_NEWER(iOS_8_0)) {
		self.navigationController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0f green:55/255.0f blue:144/255.0f alpha:1.0f];
		self.navigationController.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	}

	else {
		self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:51/255.0f green:55/255.0f blue:144/255.0f alpha:1.0f];
		self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	}

	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	 if (IS_IOS_OR_NEWER(iOS_8_0)) {
		self.navigationController.navigationController.navigationBar.tintColor = [UIColor blueColor];
		self.navigationController.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	}

	else {
		self.navigationController.navigationBar.tintColor = [UIColor blueColor];
		self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	}

	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
	PSTableCell *cell = (PSTableCell *)[super tableView:arg1 cellForRowAtIndexPath:arg2];
	if (cell.type == PSSwitchCell) {
		((UILabel *)cell.titleLabel).textColor = [UIColor whiteColor];
	}

	((UILabel *)cell.textLabel).textColor = [UIColor whiteColor];

	return cell;
}

@end
