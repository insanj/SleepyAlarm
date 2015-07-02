#import "SleepyAlarm.h"
#import "RMPickerViewController/RMPickerViewController.h"

static NSString *kSleepyAlarmTimeAmountKey = @"timesAmount", *kSleepyAlarmWaitAmountKey = @"waitAmount", *kSleepyAlarmUseMoonsKey = @"useMoons";

static NSInteger sl_timesAmount, sl_waitAmount;
static BOOL sl_useMoons;
static NSMutableArray *sl_times;
static NSDate *sl_pickedTime;

/*
  ________  __    __     ______    __   __  ___       ________  __    __    _______   _______  ___________  
 /"       )/" |  | "\   /    " \  |"  |/  \|  "|     /"       )/" |  | "\  /"     "| /"     "|("     _   ") 
(:   \___/(:  (__)  :) // ____  \ |'  /    \:  |    (:   \___/(:  (__)  :)(: ______)(: ______) )__/  \\__/  
 \___  \   \/      \/ /  /    ) :)|: /'        |     \___  \   \/      \/  \/    |   \/    |      \\_ /     
  __/  \\  //  __  \\(: (____/ //  \//  /\'    |      __/  \\  //  __  \\  // ___)_  // ___)_     |.  |     
 /" \   :)(:  (  )  :)\        /   /   /  \\   |     /" \   :)(:  (  )  :)(:      "|(:      "|    \:  |     
(_______/  \__|  |__/  \"_____/   |___/    \___|    (_______/  \__|  |__/  \_______) \_______)     \__|                                                                                                                                                                                                                                                            
*/

@interface AlarmViewController (SleepyAlarm) <RMPickerViewControllerDelegate>

- (void)sl_sleepyPress:(id)sender;

- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray  *)selectedRows;
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

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
		UIBarButtonItem *originalBarButtonItem = self.navigationItem.rightBarButtonItem;
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SleepyAlarmPrefs.bundle/add.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:originalBarButtonItem.target action:originalBarButtonItem.action];

		UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sl_sleepyPress:)];
		[[self.navigationItem.rightBarButtonItem valueForKey:@"view"] addGestureRecognizer:longPress];
	}
}

/*
   _______   __     ______   __   ___      ___________  __     ___      ___   _______  
  |   __ "\ |" \   /" _  "\ |/"| /  ")    ("     _   ")|" \   |"  \    /"  | /"     "| 
  (. |__) :)||  | (: ( \___)(: |/   /      )__/  \\__/ ||  |   \   \  //   |(: ______) 
  |:  ____/ |:  |  \/ \     |    __/          \\_ /    |:  |   /\\  \/.    | \/    |   
  (|  /     |.  |  //  \ _  (// _  \          |.  |    |.  |  |: \.        | // ___)_  
 /|__/ \    /\  |\(:   _) \ |: | \  \         \:  |    /\  |\ |.  \    /:  |(:      "| 
(_______)  (__\_|_)\_______)(__|  \__)         \__|   (__\_|_)|___|\__/|___| \_______) 
*/                                                                                    

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

	HBPreferences *preferences = [HBPreferences preferencesForIdentifier:@"com.insanj.sleepyalarm"];
	sl_waitAmount = [preferences integerForKey:kSleepyAlarmWaitAmountKey default:14];
	sl_timesAmount = [preferences integerForKey:kSleepyAlarmTimeAmountKey default:8];
	sl_useMoons = [preferences boolForKey:kSleepyAlarmUseMoonsKey default:NO];

	SLLog(@"%@, %@, %@", @(sl_waitAmount), @(sl_timesAmount), @(sl_useMoons));

	NSDateComponents *startingTimeDateComponents = [[NSDateComponents alloc] init];
	startingTimeDateComponents.minute = sl_waitAmount;

	NSDate *iteratingWakeUpTime = [[NSCalendar currentCalendar] dateByAddingComponents:startingTimeDateComponents toDate:[NSDate date] options:0];
	startingTimeDateComponents.minute = 90;

	sl_times = [[NSMutableArray alloc] initWithCapacity:sl_timesAmount];
	for (int i = 2; i < sl_timesAmount; i++) {
		// iteratingWakeUpTime.minute = 60 * (fmod(i, 2) + 1);
		iteratingWakeUpTime = [[NSCalendar currentCalendar] dateByAddingComponents:startingTimeDateComponents toDate:iteratingWakeUpTime options:0];
		[sl_times addObject:[iteratingWakeUpTime copy]];
	}

	NSString *descriptiveHeaderString = [NSString stringWithFormat:@"SleepyAlarm\n\nPick your preferred wake up time, assuming it takes about %@ minutes for you to fall asleep", [NSNumberFormatter localizedStringFromNumber:@(sl_waitAmount) numberStyle:NSNumberFormatterSpellOutStyle]];

	RMPickerViewController *sleepyAlarmPickerViewController = [RMPickerViewController pickerController];
	sleepyAlarmPickerViewController.delegate = self;
	sleepyAlarmPickerViewController.titleLabel.text = descriptiveHeaderString;
	[sleepyAlarmPickerViewController show];
}

%new - (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
	NSInteger selectedRow = [selectedRows[0] integerValue];
	sl_pickedTime = sl_times[selectedRow];
	SLLog(@"User picked time [%@], prompting add view...", sl_pickedTime);

	sl_times = nil;
	[self showAddView];
}

%new - (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

%new - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [sl_times count];
}

%new - (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
	UIColor *indicativeTextColor = [UIColor colorWithWhite:102/255.0 alpha:1.0];
	NSString *sleepyAlarmTimeString = [NSDateFormatter localizedStringFromDate:sl_times[row] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
	SLLog(@"%@", @(sl_useMoons));

	if (sl_useMoons) {
		 switch (row) {
			case 3:
				sleepyAlarmTimeString = [sleepyAlarmTimeString stringByAppendingString:@" 🌓"];
				break;
			case 4:
				sleepyAlarmTimeString = [sleepyAlarmTimeString stringByAppendingString:@" 🌔"];
				break;
			case 5:
				sleepyAlarmTimeString = [sleepyAlarmTimeString stringByAppendingString:@" 🌕"];
			default:
				break;
		}
	}

	else {
		switch (row) {
			case 3:
				indicativeTextColor = [UIColor colorWithRed:153/255.0  green:204/255.0 blue:102/255.0 alpha:1.0];
				break;
			case 4:
				indicativeTextColor =  [UIColor colorWithRed:81/255.0 green:204/255.0 blue:73/255.0 alpha:1.0];
				break;
			case 5:
				indicativeTextColor =  [UIColor colorWithRed:0/255.0 green:204/255.0 blue:51/255.0 alpha:1.0];
			default:
				break;
		}
	}

	return [[NSAttributedString alloc] initWithString:sleepyAlarmTimeString attributes:@{ NSForegroundColorAttributeName :indicativeTextColor }];
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

/*
	  __       ________   ________            __      ___            __        _______   ___      ___ 
	 /""\     |"      "\ |"      "\          /""\    |"  |          /""\      /"      \ |"  \    /"  |
	/    \    (.  ___  :)(.  ___  :)        /    \   ||  |         /    \    |:        | \   \  //   |
   /' /\  \   |: \   ) |||: \   ) ||       /' /\  \  |:  |        /' /\  \   |_____/   ) /\\  \/.    |
  //  __'  \  (| (___\ ||(| (___\ ||      //  __'  \  \  |___    //  __'  \   //      / |: \.        |
 /   /  \\  \ |:       :)|:       :)     /   /  \\  \( \_|:  \  /   /  \\  \ |:  __   \ |.  \    /:  |
(___/    \___)(________/ (________/     (___/    \___)\_______)(___/    \___)|__|  \___)|___|\__/|___|
*/
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
