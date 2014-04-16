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

@interface WLLoginViewController ()

@end

@implementation WLLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)LoginPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"loggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WLProgrammeViewController* navC = [sb instantiateViewControllerWithIdentifier:@"WLProgrammeViewController"];
    self.view.window.rootViewController = [[WLNavigationController alloc] initWithRootViewController:navC];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

@end
