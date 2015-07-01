#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <UIKit/UIActivityViewController.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import <UIKit/UIImage+Private.h>
#import <notify.h>
#import <Preferences/Preferences.h>
#import <Cephei/HBPreferences.h>
#import <Cephei/prefs/HBListController.h>
#import "substrate.h"

#ifndef SL_PREFS_PATH
	#define SL_PREFS_PATH @"/var/mobile/Library/Preferences/com.insanj.sleepyalarm.safe.plist"
#endif

@interface SLListController : HBListController

@end
