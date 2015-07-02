#import "SLListController.h"
#import "SLBannerButtonCell.h"
#import "version.h"

#define URL_ENCODE(string) [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)(string), NULL, CFSTR(":/=,!$& '()*+;[]@#?"), kCFStringEncodingUTF8) autorelease]
#define IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation SLListController

+ (NSString *)hb_specifierPlist {
	return @"SleepyAlarmPrefs";
}

+ (UIColor *)hb_tintColor {
	return [UIColor colorWithRed:51/255.0f green:55/255.0f blue:144/255.0f alpha:1.0f];
}

- (void)loadView {
	[super loadView];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];
	
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

- (void)shareTapped:(UIBarButtonItem *)sender {
	NSString *text = @"A better night's slumber, without a blink of trouble. SleepyAlarm by @insanj.";
	NSURL *url = [NSURL URLWithString:@"http://insanj.github.io/SleepyAlarm/"];

	if (%c(UIActivityViewController)) {
		UIActivityViewController *viewController = [[[%c(UIActivityViewController) alloc] initWithActivityItems:[NSArray arrayWithObjects:text, url, nil] applicationActivities:nil] autorelease];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@%%20%@", URL_ENCODE(text), URL_ENCODE(url.absoluteString)]]];
	}
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
