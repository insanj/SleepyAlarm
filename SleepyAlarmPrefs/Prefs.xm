#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <UIKit/UIActivityViewController.h>
#import <Twitter/Twitter.h>
#include <notify.h>

#define URL_ENCODE(string) [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)(string), NULL, CFSTR(":/=,!$& '()*+;[]@#?"), kCFStringEncodingUTF8) autorelease]
#define SLTintColor [UIColor colorWithRed:51/255.0f green:55/255.0f blue:144/255.0f alpha:1.0f];

@interface NSDistributedNotificationCenter : NSNotificationCenter
@end

@interface UIImage (Private)
+(UIImage *)imageNamed:(NSString *)named inBundle:(NSBundle *)bundle;
@end

@interface SleepyAlarmPrefsListController : PSListController {
	UIStatusBarStyle prevStatusStyle;
	UIBarStyle prevBarStyle;
}
@end

@implementation SleepyAlarmPrefsListController

-(void)viewDidLoad{
	[super viewDidLoad];
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(reset) name:@"SLReset" object:nil];

	[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = SLTintColor;
    [UITableViewCell appearanceWhenContainedIn:self.class, nil].backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    [UILabel appearanceWhenContainedIn:self.class, nil].tintColor = SLTintColor;
}

-(void)loadView{
	[super loadView];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];
}

-(NSArray *)specifiers{
	if(!_specifiers)
		_specifiers = [[self loadSpecifiersFromPlistName:@"SleepyAlarmPrefs" target:self] retain];

	return _specifiers;
}

-(void)viewWillAppear:(BOOL)animated{
    [(UITableView *)self.view deselectRowAtIndexPath:((UITableView *)self.view).indexPathForSelectedRow animated:YES];

	self.view.tintColor = SLTintColor;
	self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = SLTintColor;
    ((UITableView *)self.view).separatorStyle = UITableViewCellSeparatorStyleNone;

    prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    prevBarStyle = self.navigationController.navigationBar.barStyle;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	self.view.tintColor = nil;
	self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [[UIApplication sharedApplication] setStatusBarStyle:prevStatusStyle];
    self.navigationController.navigationBar.barStyle = prevBarStyle;

	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"SLReset" object:nil];
}

-(void)shareTapped:(UIBarButtonItem *)sender{
	NSString *text = @"A better night's slumber, without a blink of trouble. SleepyAlarm by @insanj.";
	NSURL *url = [NSURL URLWithString:@"http://insanj.github.io/SleepyAlarm/"];

	if(%c(UIActivityViewController)){
		UIActivityViewController *viewController = [[[%c(UIActivityViewController) alloc] initWithActivityItems:[NSArray arrayWithObjects:text, url, nil] applicationActivities:nil] autorelease];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else if (%c(TWTweetComposeViewController) && [TWTweetComposeViewController canSendTweet]){
		TWTweetComposeViewController *viewController = [[[TWTweetComposeViewController alloc] init] autorelease];
		viewController.initialText = text;
		[viewController addURL:url];
		[self.navigationController presentViewController:viewController animated:YES completion:NULL];
	}

	else
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/intent/tweet?text=%@%%20%@", URL_ENCODE(text), URL_ENCODE(url.absoluteString)]]];
}

-(void)reset{
	PSSpecifier *timesSpecifier = [self specifierForID:@"TimesSlider"];
	[self setPreferenceValue:@(8.0) specifier:timesSpecifier];
	[self reloadSpecifier:timesSpecifier];

	PSSpecifier *waitSpecifier = [self specifierForID:@"WaitSlider"];
	[self setPreferenceValue:@(14.0) specifier:waitSpecifier];
	[self reloadSpecifier:waitSpecifier];
}

@end

@interface SLLogoCell : PSTableCell {
	UIImageView *_logo;
}
@end

@implementation SLLogoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])){
	//	self.separatorColor = [UIColor clearColor];
		self.backgroundView = [[UIView alloc] init];

		_logo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner.png" inBundle:[NSBundle bundleForClass:self.class]]] autorelease];
		[self addSubview:_logo];
	}

	return self;
}

-(void)layoutSubviews {
	[super layoutSubviews];
	_logo.center = CGPointMake(self.frame.size.width / 2, _logo.center.y);

	for(UIView *v in self.subviews)
		NSLog(@"---- v : %@", v);
}

@end

@interface SLDoubleButton : PSTableCell {
	UIButton *_left, *_right;
}
@end

@implementation SLDoubleButton

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])){
		self.backgroundView = [[UIView alloc] init];

		_left = [UIButton buttonWithType:UIButtonTypeCustom];
		_left.layer.borderWidth = 1.0;
		[_left setImage:[UIImage imageNamed:@"refresh.png" inBundle:[NSBundle bundleForClass:self.class]] forState:UIControlStateNormal];
		[_left setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
		[_left setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[_left addTarget:self action:@selector(promptReset) forControlEvents:UIControlEventTouchUpInside];

		_right = [UIButton buttonWithType:UIButtonTypeCustom];
		_right.layer.borderWidth = 1.0;
		[_right setImage:[UIImage imageNamed:@"owl.png" inBundle:[NSBundle bundleForClass:self.class]] forState:UIControlStateNormal];
		[_right setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
		[_right setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[_right addTarget:self action:@selector(twitter) forControlEvents:UIControlEventTouchUpInside];

		[self addSubview:_left];
		[self addSubview:_right];
	}

	return self;
}

-(void)layoutSubviews {
	[super layoutSubviews];

	[_left setFrame:CGRectMake(0.0, 0.0, self.superview.frame.size.width / 2.0, 80.0)];
	[_right setFrame:CGRectMake(self.superview.frame.size.width / 2.0, 0.0, self.superview.frame.size.width / 2.0, 80.0)];
}


-(void)twitter{
	if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]])
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/insanj"]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=insanj"]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=insanj"]];

	else if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=insanj"]];

	else 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/insanj"]];
}

-(void)promptReset{
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SLReset" object:nil];
}

@end