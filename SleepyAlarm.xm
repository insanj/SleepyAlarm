#import "SleepyAlarm.h"
#import "KKActionSheet.h"

/************************** AlarmView Injections **************************/

static NSMutableArray *sl_times;
static NSDate *sl_pickedTime;

%hook AlarmViewController

- (void)viewWillAppear:(BOOL)animated {
    %orig();

    // Using Edit Alarms (best way)...
    if (!self.navigationItem.leftBarButtonItem) {
        SLLog(@"Adding SleepyAlarm button to Alarm view...");
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SleepyAlarmPrefs.bundle/cloud.png"] style:UIBarButtonItemStylePlain target:self action:@selector(sl_sleepyPress:)];
    }

    // Vanilla app...
    else {
        SLLog(@"Adding long-press gesture to add button in Alarm view...");
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sl_sleepyPress:)];
        [[self.navigationItem.rightBarButtonItem valueForKey:@"view"] addGestureRecognizer:longPress];
    }
}

%new - (void)sl_sleepyPress:(id)sender {
    if ([sender isKindOfClass:[UILongPressGestureRecognizer class]] && ((UILongPressGestureRecognizer *)sender).state == UIGestureRecognizerStateBegan) {
        SLLog(@"Detected SleepyAlarm long-press gesture, showing pre-set add view...");
    }

    else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        SLLog(@"Detected Sleep button press, showing pre-set add view...");
    }

    else {   // Preventative (goto fail;) brackets
        return;
    }

    NSDictionary *settings = SLSETTINGS;
    CGFloat waitAmount = [[settings objectForKey:@"waitAmount"] floatValue];
    CGFloat timesAmount = [[settings objectForKey:@"timesAmount"] floatValue];

    NSDateComponents *add = [[NSDateComponents alloc] init];
    add.minute = waitAmount > 0.0 ? waitAmount : 14.0;

    NSDate *runningTimes = [[NSCalendar currentCalendar] dateByAddingComponents:add toDate:[NSDate date] options:0];
    add.minute = 90;

    NSInteger timesToDisplay = timesAmount > 0.0 ? timesAmount : 8;
    sl_times = [[NSMutableArray alloc] initWithCapacity:timesToDisplay];

    for (int i = 2; i < timesToDisplay; i++) {
        // add.minute = 60 * (fmod(i, 2) + 1);
        runningTimes = [[NSCalendar currentCalendar] dateByAddingComponents:add toDate:runningTimes options:0];
        [sl_times addObject:runningTimes.copy];
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];

    KKActionSheet *timePickerSheet = [[KKActionSheet alloc] initWithTitle:@"SleepyAlarm\nPick your preferred wake-up time!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];    
    [timePickerSheet setTitlesTextColor:[UIColor blackColor]];

    for (int i = 0; i < sl_times.count; i++) {
        [timePickerSheet addButtonWithTitle:[formatter stringFromDate:sl_times[i]]];
        
        switch (i) {
            case 3:
                [timePickerSheet setTextColor:[UIColor colorWithRed:153/255.0  green:204/255.0 blue:103/255.0 alpha:1.0] forButtonIndex:i];
                break;
            case 4:
                [timePickerSheet setTextColor:[UIColor colorWithRed:32/255.0 green:204/255.0 blue:53/255.0 alpha:1.0] forButtonIndex:i];
                break;
            case 5:
                [timePickerSheet setTextColor:[UIColor colorWithRed:41/255.0 green:209/255.0 blue:68/255.0 alpha:1.0] forButtonIndex:i];
                break;
        }
    }

    [timePickerSheet addButtonWithTitle:@"Cancel"];
    [timePickerSheet setCancelButtonIndex:sl_times.count];
    [timePickerSheet showInView:self.view];
}

%new - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        sl_pickedTime = sl_times[buttonIndex];
        SLLog(@"User picked time [%@], prompting add view...", sl_pickedTime);

        sl_times = nil;
        [self showAddView];
    }
}

// In case you have Edit Alarms installed...
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    %orig();

    if (!self.navigationItem.leftBarButtonItem) {
        SLLog(@"Resetting SleepyAlarm button to Alarm view...");
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SleepyAlarmPrefs.bundle/cloud.png"] style:UIBarButtonItemStylePlain target:self action:@selector(sl_sleepyPress:)];
    }
}

%end

/*********************** Add (Edit) View Injections ***********************/

%hook EditAlarmView

- (void)layoutSubviews {
    %orig();

    if (sl_pickedTime) {
        SLLog(@"Settings addAlarm's datePicker to %@.", sl_pickedTime);
        [self.timePicker setDate:sl_pickedTime animated:YES];
        sl_pickedTime = nil;
    }
}

%end
