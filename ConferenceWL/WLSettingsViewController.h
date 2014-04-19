//
//  WLSettingsViewController.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/16/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface WLSettingsViewController : UITableViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

-(IBAction)logoutClicked:(id)sender;

@end
