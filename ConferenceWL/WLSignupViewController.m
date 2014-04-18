//
//  WLSignupViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import "WLSignupViewController.h"
#import "WLSignupTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CSNotificationView.h"
#import "WLActivityView.h"

@interface WLSignupViewController ()

@property (strong) IBOutlet UIButton* signupButton;
@property (strong) IBOutlet UITableView* tableView;

@end

@implementation WLSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Signup";
    
    [self.signupButton.layer setBorderWidth:1];
    self.signupButton.layer.borderColor = self.signupButton.tintColor.CGColor;
    self.signupButton.layer.cornerRadius = 4;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard:(UIGestureRecognizer*)reco
{
    [self.view endEditing:YES];
}

-(IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signupPressed:(id)sender
{
    WLSignupTableViewCell* nameCell = (WLSignupTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    WLSignupTableViewCell* emailCell = (WLSignupTableViewCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    WLSignupTableViewCell* passwordCell = (WLSignupTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (nameCell.textfield.text.length == 0) {
        [CSNotificationView  showInViewController:self style:CSNotificationViewStyleError message:@"Please enter a name"];
        return;
    }
    if (emailCell.textfield.text.length == 0) {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Please enter a valid email."];
        return;
    }
    if (passwordCell.textfield.text.length == 0) {
        [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"Please enter password"];
        return;
    }
    
    [self signupWithFirstName:nameCell.textfield.text lastName:nameCell.textfield.text email:emailCell.textfield.text pasword:passwordCell.textfield.text];
}

-(void)signupWithFirstName:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email pasword:(NSString*)password
{
    [WLActivityView showInView:self.view loadingMessage:@"Creating account..."];
    
    NSString* urlString = [NSString stringWithFormat:kURLSignup, firstName, lastName,email, password];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [WLWebCaller getDataFromURL:urlString withCompletionBlock:^(bool success, id result) {
        if ([result[@"success"] boolValue]) {
            [self dismissViewControllerAnimated:YES completion:^{
                if (_delegate) {
                    [_delegate signUpVC:self didSigninWithEmail:email password:password];
                }
            }];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:result[@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
}

#pragma mark - UITableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLSignupTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    switch (indexPath.row) {
        case 0:
            cell.textfield.placeholder = @"Name";
            break;
        case 1:
            cell.textfield.placeholder = @"Email";
            cell.textfield.keyboardType = UIKeyboardTypeEmailAddress;
            cell.textfield.autocorrectionType = UITextAutocorrectionTypeNo;
            break;
        default:
            cell.textfield.placeholder = @"Password";
            cell.textfield.keyboardAppearance = UIKeyboardAppearanceAlert;
            cell.textfield.secureTextEntry = YES;
            break;
    }
    
    cell.textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    return cell;
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
