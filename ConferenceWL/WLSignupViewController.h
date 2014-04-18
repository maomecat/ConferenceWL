//
//  WLSignupViewController.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import <UIKit/UIKit.h>

@interface WLSignupViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

-(IBAction)cancelPressed:(id)sender;
-(IBAction)signupPressed:(id)sender;

@end
