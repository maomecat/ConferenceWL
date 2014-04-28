//
//  WLProgrammeDetailViewController.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/21/14.
//
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface WLProgrammeDetailViewController : UITableViewController<UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong) NSDictionary* dictionary;

@end
