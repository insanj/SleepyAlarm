#import "SLBannerButtonCell.h"

@interface SLBannerButtonCell ()

@property (strong, nonatomic) UIButton *button;

@property (strong, nonatomic) CAGradientLayer *bannerGradientLayer;

@end

@implementation SLBannerButtonCell

@synthesize button = _button, bannerGradientLayer = _bannerGradientLayer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

	if (self) {
		self.backgroundView = [[UIView alloc] init];

		_button = [UIButton buttonWithType:UIButtonTypeCustom];
		[_button addTarget:self action:@selector(website) forControlEvents:UIControlEventTouchUpInside];
		[_button setImage:[UIImage imageNamed:@"banner-icon.png" inBundle:[NSBundle bundleForClass:self.class]] forState:UIControlStateNormal];

		_bannerGradientLayer = [CAGradientLayer layer];
		_bannerGradientLayer.frame = self.frame;
		_bannerGradientLayer.colors = @[
			(id)[UIColor colorWithRed:15.0/255.0 green:15.0/255.0 blue:51.0/255.0 alpha:1.0].CGColor,
			(id)[UIColor colorWithRed:15.0/255.0 green:15.0/255.0 blue:51.0/255.0 alpha:1.0].CGColor,
			(id)[UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:125.0/255.0 alpha:1.0].CGColor,
			(id)[UIColor colorWithRed:38.0/255.0 green:36.0/255.0 blue:125.0/255.0 alpha:1.0].CGColor,
		];
		_bannerGradientLayer.locations = @[@(0.0), @(0.1616), @(0.8787), @(1.0)];

		[self.contentView.layer insertSublayer:_bannerGradientLayer atIndex:0];
		[self.contentView addSubview:_button];
	}

	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	_button.frame = CGRectMake(0.0, 0.0, self.superview.frame.size.width, 205.5);
	_bannerGradientLayer.frame = _button.frame;
}

- (void)website {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://insanj.github.io/SleepyAlarm/"]];
}

@end
