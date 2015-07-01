#import "SLSliderCell.h"
#import "UIDiscreteSlider.h"
#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIImage+Private.h>
#import <QuartzCore/QuartzCore.h>

@implementation SLSliderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(NSString *)arg2 specifier:(PSSpecifier *)arg3 {
	self = [super initWithStyle:arg1 reuseIdentifier:arg2 specifier:arg3];
	
	if (self) {		
		UIDiscreteSlider *discreteSlider = [[UIDiscreteSlider alloc] initWithFrame:self.control.frame];
		[discreteSlider addTarget:self action:@selector(discreteSliderTapped:) forControlEvents:UIControlEventTouchUpInside];
		discreteSlider.increment = 1.0;
		[self setControl:discreteSlider];
	}

	return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)arg1 {
	[super refreshCellContentsWithSpecifier:arg1];

	NSString *savedValueKey = [[self specifier] propertyForKey:@"key"];

	HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.insanj.sleepyalarm"];
	UIDiscreteSlider *discreteSlider = (UIDiscreteSlider *)self.control;
	discreteSlider.value = [preferences floatForKey:savedValueKey];
}

- (void)discreteSliderTapped:(UIDiscreteSlider *)sender {
	NSString *savedValueKey = [[self specifier] propertyForKey:@"key"];

	HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.insanj.sleepyalarm"];
	[preferences setFloat:sender.value forKey:savedValueKey];
}

@end
