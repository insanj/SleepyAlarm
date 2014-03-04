#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property(readonly, nonatomic) UIBarButtonItem *addButton;
- (void)showAddView;
@end

@interface AlarmViewController : TableViewController
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
