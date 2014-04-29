//
//  WLSettingsViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/16/14.
//
//

#import "WLSettingsViewController.h"
//#import "WLNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "WLLoginViewController.h"
#import "WLActivityView.h"
#import "WLAppDelegate.h"
#import "WLTerms&PrivacyViewController.h"
#import "MFSideMenu.h"

@interface WLSettingsViewController ()

@property (strong) IBOutlet UIButton* logoutButton;
@property (strong) IBOutlet UILabel* usernameLabel;
@property (strong) IBOutlet UILabel* versionLabel;

@end

@implementation WLSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];
    
    self.title = NSLocalizedString(@"Settings", nil);
    
    _usernameLabel.text = [NSString stringWithFormat:@"%@ %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_firstname"], [[NSUserDefaults standardUserDefaults] objectForKey:@"user_lastname"]];
    
    [self.logoutButton.layer setBorderWidth:1];
    self.logoutButton.layer.borderColor = self.logoutButton.tintColor.CGColor;
    self.logoutButton.layer.cornerRadius = 4;
    
    _versionLabel.text = [WLAppDelegate appVersionNumberDisplayString];
    
    [self setupLeftMenuBarButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupLeftMenuBarButton
{
    UIButton* barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setBackgroundImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
    [barButton setFrame:CGRectMake(0, 0, 20, 20)];
    [barButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:barButton]];
}

-(void)leftSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

-(void)logoutClicked:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:@"Logout" otherButtonTitles:nil, nil];
    [sheet showInView:self.view.window];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [WLActivityView showInView:self.view loadingMessage:@"Signing out..."];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(logoutComplete:) userInfo:nil repeats:NO];
    }
}

-(void)logoutComplete:(NSTimer*)logoutTimer
{
    [WLActivityView hide];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WLLoginViewController* navC = [sb instantiateViewControllerWithIdentifier:@"WLLoginViewController"];
    
    [UIView transitionWithView:self.view.window duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.view.window.rootViewController = navC;
    } completion:nil];
}

#pragma mark - UITableView Datasource

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
            mailVC.mailComposeDelegate = self;
            mailVC.view.tintColor = [UIColor whiteColor];
            [mailVC setToRecipients:@[@"email@example.com"]];
            [mailVC setSubject:@"example subject"];
            [self presentViewController: mailVC animated:YES completion:nil];
            
        }
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
        [self logoutClicked:nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"TermsSegue"]) {
        WLTerms_PrivacyViewController* termPrivacyVC = [segue destinationViewController];
        termPrivacyVC.viewType = WLTerms_PrivacyViewTypeTerms;
    }
    if ([segue.identifier isEqualToString:@"PrivacySegue"]) {
        WLTerms_PrivacyViewController* termsPrivacyVC = [segue destinationViewController];
        termsPrivacyVC.viewType = WLTerms_PrivacyViewTypePrivacy;
    }
}

@end
