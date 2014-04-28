//
//  WLProgrammeDetailViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/21/14.
//
//

#import "WLProgrammeDetailViewController.h"
#import "WLFormatter.h"

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
    _progDate.text = [WLFormatter formatDate:_dictionary[@"date"]];
    _progTime.text = [WLFormatter formatTime:_dictionary[@"time"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareProgram)];
    
    self.tableView.tableFooterView = [UIView new];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shareProgram
{
    NSArray* array = @[_dictionary[@"name"], _progVenue.text, _progDate.text, _progTime.text];
    UIActivityViewController* actController = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    [self presentViewController:actController animated:YES completion:nil];
}

#pragma mark - UITableView Datasource

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _dictionary[@"name"];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width, 60)];
    label.text = _dictionary[@"name"];
    label.font = [UIFont boldSystemFontOfSize:20];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Open in..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Google Maps", @"Apple Maps", nil];
        [sheet showFromRect:self.view.window.frame inView:self.view animated:YES];
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //Google Maps
        NSString* locationTitleWithAddedPlusSigns = [_progVenue.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?q=%@&zoom=14&views=traffic", locationTitleWithAddedPlusSigns]]];
    }
    if (buttonIndex == 1) {
        //Apple Maps
        
        NSString* locationTitleWithAddedPlusSigns = [_progVenue.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@", locationTitleWithAddedPlusSigns]]];
//        [selectedLocation.mapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving}];
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
