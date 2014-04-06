#import <UIKit/UIKit.h>

#define SLSETTINGS [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.insanj.sleepyalarm.plist"]]

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property(readonly, nonatomic) UIBarButtonItem *addButton;
- (void)showAddView;
@end

@interface AlarmViewController : TableViewController
@end

@interface AlarmViewController (SleepyAlarm)
- (void)slShouldDarken:(BOOL)should;
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
