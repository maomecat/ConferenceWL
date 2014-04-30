//
//  WLLoginViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import "WLLoginViewController.h"
#import "WLProgrammeViewController.h"
#import "CSNotificationView.h"
#import "WLActivityView.h"
#import "MFSideMenu.h"
#import "WLMenuViewController.h"

@interface WLLoginViewController ()

@property (strong) IBOutlet UITextField* emailTextField;
@property (strong) IBOutlet UITextField* passwordTextField;

@property (strong) IBOutlet UIButton* loginButton;
@property (strong) IBOutlet UIButton* signupButton;

@end

@implementation WLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    [self.loginButton.layer setBorderWidth:1];
    self.loginButton.layer.borderColor = self.loginButton.tintColor.CGColor;
    self.loginButton.layer.cornerRadius = 4;
    
    [self.signupButton.layer setBorderWidth:1];
    self.signupButton.layer.borderColor = self.signupButton.tintColor.CGColor;
    self.signupButton.layer.cornerRadius = 4;
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

- (BOOL)validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(IBAction)LoginPressed:(id)sender
{
    if (self.emailTextField.text.length == 0 || ![self validateEmail:self.emailTextField.text]) {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:NSLocalizedString(@"Please enter a valid email.", nil)];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:NSLocalizedString(@"Please enter password.", nil)];
        return;
    }
    
    [self loginWithEmail:self.emailTextField.text password:self.passwordTextField.text];
}

-(void)loginWithEmail:(NSString*)email password:(NSString*)password {
    
    [WLActivityView showInView:self.view loadingMessage:@"Logging in..."];
    
    [WLWebCaller loginForUsername:email password:password completion:^(bool success, id result) {
        [WLActivityView hide];
        if ([result[@"success"] boolValue]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"loggedIn"];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:result[@"user"][@"id"] forKey:@"userid"];
            [[NSUserDefaults standardUserDefaults] setObject:result[@"user"][@"firstname"] forKey:@"user_firstname"];
            [[NSUserDefaults standardUserDefaults] setObject:result[@"user"][@"lastname"] forKey:@"user_lastname"];
            [[NSUserDefaults standardUserDefaults] setObject:result[@"user"][@"photo"] forKey:@"photoURL"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WLProgrammeViewController* programVC = [sb instantiateViewControllerWithIdentifier:@"WLProgrammeViewController"];
            UINavigationController* navC = [[UINavigationController alloc] initWithRootViewController:programVC];
            MFSideMenuContainerViewController* sideMenu = [MFSideMenuContainerViewController containerWithCenterViewController:navC leftMenuViewController:[[UINavigationController alloc] initWithRootViewController:[[WLMenuViewController alloc] initWithStyle:UITableViewStyleGrouped]] rightMenuViewController:nil];
            
            [UIView transitionWithView:self.view.window duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                self.view.window.rootViewController = sideMenu;
            } completion:nil];
            
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login" message:result[@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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