//
//  WLSettingsViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/16/14.
//
//

#import "WLSettingsViewController.h"
#import "WLNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "WLLoginViewController.h"

@interface WLSettingsViewController ()

@property (strong) IBOutlet UIButton* logoutButton;

@end

@implementation WLSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];
    
    self.title = @"Settings";
    
    [self.logoutButton.layer setBorderWidth:1];
    self.logoutButton.layer.borderColor = self.logoutButton.tintColor.CGColor;
    self.logoutButton.layer.cornerRadius = 4;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logoutClicked:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes" otherButtonTitles:nil, nil];
    [sheet showInView:self.view.window];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WLLoginViewController* navC = [sb instantiateViewControllerWithIdentifier:@"WLLoginViewController"];
        self.view.window.rootViewController = navC;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
