#import "SLTwitterTableCell.h"

@implementation SLTwitterTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];
	self.textLabel.textColor = [UIColor whiteColor];
	return self;
}

@end