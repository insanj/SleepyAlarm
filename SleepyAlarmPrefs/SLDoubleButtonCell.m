#import "SLDoubleButtonCell.h"

@interface SLDoubleButtonCell ()

@property (strong, nonatomic) UIButton *left, *center, *right;

@end

@implementation SLDoubleButtonCell

@synthesize left = _left, center = _center, right = _right;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
	if (self) {
		self.backgroundView = [[UIView alloc] init];

		_left = [UIButton buttonWithType:UIButtonTypeCustom];
		_left.layer.borderWidth = 1.0;
		[_left setImage:[UIImage imageNamed:@"hammer.png" inBundle:[NSBundle bundleForClass:self.class]] forState:UIControlStateNormal];
		[_left setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
		[_left setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[_left addTarget:self action:@selector(developer) forControlEvents:UIControlEventTouchUpInside];

		_center = [UIButton buttonWithType:UIButtonTypeCustom];
		_center.layer.borderWidth = 1.0;
		[_center setImage:[UIImage imageNamed:@"reset.png" inBundle:[NSBundle bundleForClass:self.class]] forState:UIControlStateNormal];
		[_center setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
		[_center setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[_center addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];

		_right = [UIButton buttonWithType:UIButtonTypeCustom];
		_right.layer.borderWidth = 1.0;
		[_right setImage:[UIImage imageNamed:@"brush.png" inBundle:[NSBundle bundleForClass:self.class]] forState:UIControlStateNormal];
		[_right setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
		[_right setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[_right addTarget:self action:@selector(designer) forControlEvents:UIControlEventTouchUpInside];

		[self addSubview:_left];
		[self addSubview:_center];
		[self addSubview:_right];
	}

	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGFloat insetWidth = CGRectGetWidth(self.superview.frame) / 3.0;
	CGFloat insetHeight = 80.0;

	_left.frame = CGRectMake(0.0, 0.0, insetWidth, insetHeight);
	_center.frame = CGRectMake(insetWidth, -1.0, insetWidth, insetHeight + 2.0);
	_right.frame = CGRectMake(2.0 * insetWidth, 0.0, insetWidth, insetHeight);
}

- (void)developer {
	[self twitter:@"insanj"];
}

- (void)reset {
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SLReset" object:nil];
}

- (void)designer {
	[self twitter:@"Pronounced_Nor"];
}

- (void)twitter:(NSString *)user {
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:user]]];
	}

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:user]]];
	}

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:user]]];
	}

	else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:user]]];
	}

	else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:user]]];
	}
}

@end
