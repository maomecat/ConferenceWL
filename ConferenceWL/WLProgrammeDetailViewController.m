//
//  WLProgrammeDetailViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/21/14.
//
//

#import "WLProgrammeDetailViewController.h"

@interface WLProgrammeDetailViewController ()

@property (strong) IBOutlet UILabel* progNameLabel;
@property (strong) IBOutlet UILabel* progVenue;
@property (strong) IBOutlet UILabel* progDate;
@property (strong) IBOutlet UILabel* progTime;

@end

@implementation WLProgrammeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", _dictionary);
    
    _progNameLabel.text = _dictionary[@"name"];
    _progVenue.text = _dictionary[@"venue"];
    _progDate.text = _dictionary[@"date"];
    _progTime.text = _dictionary[@"time"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    // Do any additional setup after loading the view.
}

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