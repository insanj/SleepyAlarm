#import <UIKit/UIKit.h>
#import <UIKit/UIImage+Private.h>
#import "substrate.h"

#define SLSETTINGS [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.sleepyalarm.plist"]]
#define SLLog(fmt, ...) NSLog((@"%s[SleepyAlarm] " fmt @"%s"), "\e[1;35m", ##__VA_ARGS__, "\x1B[0m")

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(readonly, nonatomic) UIBarButtonItem *addButton;

- (void)showAddView;

@end

@interface AlarmViewController : TableViewController
@end

@interface AlarmViewController (SleepyAlarm) <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)sl_sleepyPress:(id)sender;

@end

@interface AlarmView : UIView
@end

@interface AlarmTableViewCell : UITableViewCell
@end

@interface EditAlarmViewController

- (id)initWithAlarm:(id)arg1;

@end

@interface EditAlarmView : UIView

@property (readonly, nonatomic) UIDatePicker *timePicker;

@end
