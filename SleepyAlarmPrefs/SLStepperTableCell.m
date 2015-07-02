#import "SLStepperTableCell.h"

@interface HBStepperTableCell (Private)

- (void)_updateLabel;

@end

@implementation SLStepperTableCell

- (void)_updateLabel {
	[super _updateLabel];

	self.textLabel.textColor = [UIColor whiteColor];
}

@end