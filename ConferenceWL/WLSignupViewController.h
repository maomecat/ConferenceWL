//
//  WLSignupViewController.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import <UIKit/UIKit.h>

@protocol WLSignupDelegate;

@interface WLSignupViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak) id<WLSignupDelegate> delegate;

-(IBAction)cancelPressed:(id)sender;
-(IBAction)signupPressed:(id)sender;

@end

@protocol WLSignupDelegate <NSObject>

-(void)signUpVC:(id)controller didSigninWithEmail:(NSString*)email password:(NSString*)password;

@end