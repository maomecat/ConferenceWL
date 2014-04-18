//
//  WLLoginViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import "WLLoginViewController.h"
#import "WLProgrammeViewController.h"
#import "WLNavigationController.h"
#import "CSNotificationView.h"
#import "WLActivityView.h"

@interface WLLoginViewController ()

@property (strong) IBOutlet UITextField* emailTextField;
@property (strong) IBOutlet UITextField* passwordTextField;

@end

@implementation WLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapped:(UIGestureRecognizer*)reco {
    [self.view endEditing:YES];
}

-(IBAction)LoginPressed:(id)sender
{
    if (self.emailTextField.text.length == 0) {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Please enter a valid email."];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Please enter password."];
        return;
    }
    
    [self loginWithEmail:self.emailTextField.text password:self.passwordTextField.text];
}

-(void)loginWithEmail:(NSString*)email password:(NSString*)password {
    
    [WLActivityView showInView:self.view loadingMessage:@"Logging in..."];
    
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLLogin, email, password] withCompletionBlock:^(bool success, id result) {
        [WLActivityView hide];
        if ([result[@"success"] boolValue]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"loggedIn"];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WLProgrammeViewController* programVC = [sb instantiateViewControllerWithIdentifier:@"WLProgrammeViewController"];
            WLNavigationController* navC = [[WLNavigationController alloc] initWithRootViewController:programVC];
            [UIView transitionWithView:self.view.window duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                self.view.window.rootViewController = navC;
            } completion:nil];
            
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error Signing in" message:result[@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"signupSegue"]) {
        UINavigationController* navC = segue.destinationViewController;
        WLSignupViewController* signupVC = navC.viewControllers[0];
        signupVC.delegate = self;
    }
}

#pragma mark - Signup ViewController Delegate

-(void)signUpVC:(id)controller didSigninWithEmail:(NSString *)email password:(NSString *)password
{
    [self loginWithEmail:email password:password];
}

@end