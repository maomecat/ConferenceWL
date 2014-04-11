//
//  WLProgrammeViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import "WLProgrammeViewController.h"
#import "WLNavigationController.h"

@interface WLProgrammeViewController ()


@end

@implementation WLProgrammeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];
    
    self.title = @"Programmes";
    
    // Do any additional setup after loading the view.
}

////////DOESN'T SEEM TO BE DOING ANY THING WHEN REMOVED....ADDDED BY REMENU
//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    WLNavigationController *navigationController = (WLNavigationController *)self.navigationController;
//    [navigationController.menu setNeedsLayout];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
