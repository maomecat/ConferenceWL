//
//  WLSettingsViewController.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/16/14.
//
//

#import <UIKit/UIKit.h>

@interface WLSettingsViewController : UITableViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>

-(IBAction)logoutClicked:(id)sender;

@end
