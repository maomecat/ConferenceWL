//
//  WLLoginViewController.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import <UIKit/UIKit.h>
#import "WLSignupViewController.h"

@interface WLLoginViewController : UIViewController<WLSignupDelegate>

-(IBAction)LoginPressed:(id)sender;

@end
