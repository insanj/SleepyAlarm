#import "SleepyAlarm.h"

@interface AlarmViewController (SleepyAlarm) <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

static NSMutableArray *sl_times;
static NSDate *sl_pickedTime;

/************************** AlarmView Injections **************************/

%hook AlarmViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig();

    // Using Edit Alarms (best way)...
    if (!self.navigationItem.leftBarButtonItem) {
        NSLog(@"[SleepyAlarm] Adding SleepyAlarm button to Alarm view...");
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SleepyAlarmPrefs.bundle/cloud.png"] style:UIBarButtonItemStylePlain target:self action:@selector(sl_sleepyPress:)];
    }

    // Vanilla app...
    else {
        NSLog(@"[SleepyAlarm] Adding long-press gesture to add button in Alarm view...");
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sl_sleepyPress:)];
        [[self.navigationItem.rightBarButtonItem valueForKey:@"view"] addGestureRecognizer:longPress];
    }
}

%new - (void)sl_sleepyPress:(id)sender {
    if ([sender isKindOfClass:[UILongPressGestureRecognizer class]] && ((UILongPressGestureRecognizer *)sender).state == UIGestureRecognizerStateBegan) {
        NSLog(@"[SleepyAlarm] Detected SleepyAlarm long-press gesture, showing pre-set add view...");
    }

    else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        NSLog(@"[SleepyAlarm] Detected Sleep button press, showing pre-set add view...");
    }

    else {   // Preventative (goto fail;) brackets
        return;
    }

    NSDictionary *settings = SLSETTINGS;
    CGFloat waitAmount = [[settings objectForKey:@"waitAmount"] floatValue];
    CGFloat timesAmount = [[settings objectForKey:@"timesAmount"] floatValue];

    NSDateComponents *add = [[NSDateComponents alloc] init];
    add.minute = waitAmount > 0.0 ? waitAmount : 14.0;

    NSDate *iterated = [[NSCalendar currentCalendar] dateByAddingComponents:add toDate:[NSDate date] options:0];
    add.minute = 90;

    sl_times = [[NSMutableArray alloc] init];

    int count = timesAmount > 0.0 ? timesAmount : 8;
    for(int i = 2; i < count; i++) {
        //add.minute = 60 * (fmod(i, 2) + 1);
        iterated = [[NSCalendar currentCalendar] dateByAddingComponents:add toDate:iterated options:0];
        [sl_times addObject:iterated.copy];
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];

    UIActionSheet *timePicker = [[UIActionSheet alloc] initWithTitle:@"SleepyAlarm\nPick your preferred wake-up time!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for(int i = 0; i < sl_times.count; i++) {
        [timePicker addButtonWithTitle:[formatter stringFromDate:sl_times[i]]];
    }

    [timePicker addButtonWithTitle:@"Cancel"];
    [timePicker setCancelButtonIndex:sl_times.count];
    [timePicker showInView:self.view];
}

%new - (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (int i = 0; i < actionSheet.subviews.count; i++) {
        UIView *v = actionSheet.subviews[i];
        if ([v isKindOfClass:[UIButton class]] && ![((UIButton *)v).titleLabel.text isEqualToString:@"Cancel"]) {
            switch (i) {
                default:
                    break;
                case 5:
                    [(UIButton *)v setTitleColor:[UIColor colorWithRed:153/255.0f green:204/255.0f blue:103/255.0f alpha:1.0f] forState:UIControlStateNormal];
                    break;
                case 6:
                    [(UIButton *)v setTitleColor:[UIColor colorWithRed:32/255.0f green:204/255.0f blue:53/255.0f alpha:1.0f] forState:UIControlStateNormal];
                    break;
                case 7:
                    [(UIButton *)v setTitleColor:[UIColor colorWithRed:41/255.0f green:209/255.0f blue:68/255.0f alpha:1.0f] forState:UIControlStateNormal];
                    break;
            }
        }
    }
}

%new - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != actionSheet.cancelButtonIndex) {
        sl_pickedTime = sl_times[buttonIndex];
        NSLog(@"[SleepyAlarm] User picked time [%@], prompting add view...", sl_pickedTime);

        sl_times = nil;
        [self showAddView];
    }
}

// In case you have Edit Alarms installed...
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    %orig();

    if (!self.navigationItem.leftBarButtonItem) {
        NSLog(@"[SleepyAlarm] Resetting SleepyAlarm button to Alarm view...");
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage kitImageNamed:@"SleepyAlarm.png"] style:UIBarButtonItemStylePlain target:self action:@selector(sl_sleepyPress:)];
    }
}

%end

/*********************** Add (Edit) View Injections ***********************/

%hook EditAlarmView

- (void)layoutSubviews {
    %orig();

    if (sl_pickedTime) {
        NSLog(@"[SleepyAlarm] Settings addAlarm's datePicker to %@.", sl_pickedTime);
        [self.timePicker setDate:sl_pickedTime animated:YES];
        sl_pickedTime = nil;
    }
}

%end
