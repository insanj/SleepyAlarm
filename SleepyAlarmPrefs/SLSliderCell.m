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

- (void)layoutSubviews {
	[super layoutSubviews];

	NSString *savedValueKey = [[self specifier] propertyForKey:@"key"];
	NSDictionary *savedPreferences = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.sleepyalarm.plist"]];
	NSNumber *savedValue = savedPreferences[savedValueKey];

	if (savedValue) {
		UIDiscreteSlider *discreteSlider = (UIDiscreteSlider *)self.control;
		discreteSlider.value = [savedValue floatValue];
	}
}

- (void)discreteSliderTapped:(UIDiscreteSlider *)sender {
	NSString *savedValueKey = [[self specifier] propertyForKey:@"key"];
	NSDictionary *savedPreferences = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.sleepyalarm.plist"]];
	NSNumber *savedValue = @(sender.value);

	NSMutableDictionary *mutableSavedPreferences = [[NSMutableDictionary alloc] initWithDictionary:savedPreferences];
	[mutableSavedPreferences setObject:savedValue forKey:savedValueKey];
	[mutableSavedPreferences writeToFile:@"/var/mobile/Library/Preferences/com.insanj.sleepyalarm.plist" atomically:YES];
	[mutableSavedPreferences release];
}

@end
