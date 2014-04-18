//
//  WLSignupViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import "WLSignupViewController.h"

@interface WLSignupViewController ()

@end

@implementation WLSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Signup";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    
    http://localhost:8080/api.php/?method=signup&firstname=rishabh&lastname=tayal&email=e@s.c&password=123
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)signupPressed:(id)sender
{
    NSString* urlString =[NSString stringWithFormat:@"%@method=signup&firstname=newFirstName&lastname=newLastName&email=newEmail&password=newPass", webservice_base_url];
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@", json);
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
