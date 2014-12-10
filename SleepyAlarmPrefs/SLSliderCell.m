#import "SLSliderCell.h"
#import "UIDiscreteSlider.h"

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
	NSDictionary *savedPreferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.insanj.sleepyalarm.plist"];
	NSNumber *savedValue = savedPreferences[savedValueKey];

	if (savedValue) {
		UIDiscreteSlider *discreteSlider = (UIDiscreteSlider *)self.control;
		discreteSlider.value = [savedValue floatValue];
	}
}

- (void)discreteSliderTapped:(UIDiscreteSlider *)sender {
	NSString *savedValueKey = [[self specifier] propertyForKey:@"key"];
	NSMutableDictionary *mutableSavedPreferences = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.insanj.sleepyalarm.plist"];
	[mutableSavedPreferences setObject:@(sender.value) forKey:savedValueKey];
	[mutableSavedPreferences writeToFile:@"/var/mobile/Library/Preferences/com.insanj.sleepyalarm.plist" atomically:YES];
}

@end
