#import <UIKit/UIKit.h>
#import "substrate.h"

#define SLSETTINGS [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.sleepyalarm.plist"]]

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property(readonly, nonatomic) UIBarButtonItem *addButton;
- (void)showAddView;
@end

@interface AlarmViewController : TableViewController
@end

@interface AlarmViewController (SleepyAlarm) <UIActionSheetDelegate>
- (void)slShouldDarken:(BOOL)should;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface AlarmView : UIView
@end

@interface AlarmTableViewCell : UITableViewCell
@end

@interface UIImage (Private)
+ (UIImage *)kitImageNamed:(NSString *)name;
@end

@interface EditAlarmViewController
- (id)initWithAlarm:(id)arg1;
@end

@interface EditAlarmView : UIView
@property(readonly, nonatomic) UIDatePicker *timePicker;
@end
