#import "SLListController.h"
#import "SLBannerButtonCell.h"
#import "SLDoubleButtonCell.h"
#import "version.h"

#define URL_ENCODE(string) [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)(string), NULL, CFSTR(":/=,!$& '()*+;[]@#?"), kCFStringEncodingUTF8) autorelease]
#define IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation SLListController

- (void)loadView {
	[super loadView];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];
	
	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = [UIColor colorWithRed:51/255.0f green:55/255.0f blue:144/255.0f alpha:1.0f];
	[UITableViewCell appearanceWhenContainedIn:self.class, nil].backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];

	[self table].backgroundColor = [UIColor blackColor];
	[self table].tintColor = [UIColor colorWithRed:51/255.0f green:55/255.0f blue:144/255.0f alpha:1.0f];
	[self table].separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"SleepyAlarmPrefs" target:self] retain];
	}

	return _specifiers;
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
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(reset) name:@"SLReset" object:nil];

    [[self table] deselectRowAtIndexPath:[self table].indexPathForSelectedRow animated:YES];
   
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"SLReset" object:nil];

	 if (IS_IOS_OR_NEWER(iOS_8_0)) {
		self.navigationController.navigationController.navigationBar.tintColor = [UIColor blueColor];
	    self.navigationController.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }

    else {
		self.navigationController.navigationBar.tintColor = [UIColor blueColor];
		self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	}
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
	PSTableCell *cell = (PSTableCell *)[super tableView:arg1 cellForRowAtIndexPath:arg2];
	if (cell.type == PSSwitchCell) {
		((UILabel *)cell.titleLabel).textColor = [UIColor whiteColor];
	}

	return cell;
}

- (void)shareTapped:(UIBarButtonItem *)sender {
	NSString *text = @"A better night's slumber, without a blink of trouble. SleepyAlarm by @insanj.";
	NSURL *url = [NSURL URLWithString:@"http://insanj.github.io/SleepyAlarm/"];

	if (%c(UIActivityViewController)) {
		UIActivityViewController *viewController = [[[%c(UIActivityViewController) alloc] initWithActivityItems:[NSArray arrayWithObjects:text, url, nil] applicationActivities:nil] autorelease];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else if (%c(TWTweetComposeViewController) && [TWTweetComposeViewController canSendTweet]) {
		TWTweetComposeViewController *viewController = [[[TWTweetComposeViewController alloc] init] autorelease];
		viewController.initialText = text;
		[viewController addURL:url];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@%%20%@", URL_ENCODE(text), URL_ENCODE(url.absoluteString)]]];
	}
}

- (void)reset {
	NSMutableDictionary *mutableSavedPreferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.insanj.sleepyalarm.plist"];
	[mutableSavedPreferences setObject:@(8.0) forKey:@"timesAmount"];
	[mutableSavedPreferences setObject:@(14.0) forKey:@"waitAmount"];
	[mutableSavedPreferences writeToFile:@"/var/mobile/Library/Preferences/com.insanj.sleepyalarm.plist" atomically:YES];

	PSSpecifier *timesSpecifier = [self specifierForID:@"TimesSlider"];
	[self reloadSpecifier:timesSpecifier animated:YES];

	PSSpecifier *waitSpecifier = [self specifierForID:@"WaitSlider"];
	[self reloadSpecifier:waitSpecifier animated:YES];

	PSSpecifier *moonsSpecifier = [self specifierForID:@"MoonSwitch"];
	[self setPreferenceValue:@(NO) specifier:moonsSpecifier];
	[self reloadSpecifier:moonsSpecifier animated:YES];
}

@end
