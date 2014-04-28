//
//  WLProgrammeDetailViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/21/14.
//
//

#import "WLProgrammeDetailViewController.h"
#import "WLFormatter.h"
#import "WLWebCaller.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "WLAttendeesTableViewCell.h"

@interface WLProgrammeDetailViewController ()

@property (strong) NSMutableArray* attendeesArray;

@end

@implementation WLProgrammeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareProgram)];
    
    self.tableView.tableFooterView = [UIView new];
    
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLGetAttendeesForProgramme, _dictionary[@"id"]] withCompletionBlock:^(bool success, id result) {
        _attendeesArray = [[NSMutableArray alloc] initWithArray:result];
        [self.tableView reloadData];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shareProgram
{
    NSArray* array = @[_dictionary[@"name"], _dictionary[@"venue"], _dictionary[@"date"], _dictionary[@"time"]];
    UIActivityViewController* actController = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    [self presentViewController:actController animated:YES completion:nil];
}

#pragma mark - UITableView Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width, 60)];
    UIView *view = [[UIView alloc] init];
    
    if (section == 0) {
        label.text = _dictionary[@"name"];
        label.font = [UIFont boldSystemFontOfSize:20];
    } else if (section == 1) {
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor darkGrayColor];
        label.text = [NSString stringWithFormat:@"%d attending", _attendeesArray.count];
    }
    
    [view addSubview:label];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 60;
    }
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return _attendeesArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return tableView.rowHeight;
    }
    return 78;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = _dictionary[@"venue"];
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = [WLFormatter formatDate:_dictionary[@"date"]];
            cell.detailTextLabel.text = [WLFormatter formatTime:_dictionary[@"time"]];
        }
    }
    if (indexPath.section == 1) {
        WLAttendeesTableViewCell*  attendeeCell = (WLAttendeesTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"attendeeCell"];
        attendeeCell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",_attendeesArray[indexPath.row][@"firstname"], _attendeesArray[indexPath.row][@"lastname"]];
        [attendeeCell.thumbImageView setImageWithURL:[NSURL URLWithString:_attendeesArray[indexPath.row][@"photo"]]];
        return attendeeCell;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Open in..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Google Maps", @"Apple Maps", nil];
        [sheet showFromRect:self.view.window.frame inView:self.view animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Add to Calendar" message:[NSString stringWithFormat:@"Add %@ to calendar?", _dictionary[@"name"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        EKEventStore* store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) {
                return;
            }
            EKEvent* event = [EKEvent eventWithEventStore:store];
            event.title = _dictionary[@"name"];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            event.startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",_dictionary[@"date"], _dictionary[@"time"]]];
            event.endDate = event.startDate;
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError* err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        }];
    }
}

#pragma mark - UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //Google Maps
        NSString* locationTitleWithAddedPlusSigns = [_dictionary[@"venue"] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?q=%@&zoom=14&views=traffic", locationTitleWithAddedPlusSigns]]];
    }
    if (buttonIndex == 1) {
        //Apple Maps
        NSString* locationTitleWithAddedPlusSigns = [_dictionary[@"venue"] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@", locationTitleWithAddedPlusSigns]]];
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
