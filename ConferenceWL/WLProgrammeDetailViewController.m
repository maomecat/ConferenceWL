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
#import "WLProgrammeViewController.h"

@interface WLProgrammeDetailViewController ()

@property (strong) NSMutableArray* attendeesArray;

@property (assign) bool shouldRefreshPreviousView;

@end

@implementation WLProgrammeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareProgram)];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self getAttendees];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_shouldRefreshPreviousView) {
        NSInteger numberOfVC = self.navigationController.viewControllers.count;
        if (numberOfVC > 0) {
            WLProgrammeViewController* vc = self.navigationController.viewControllers[numberOfVC - 1];
            [vc refreshTable:vc.refreshControl];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAttendees {
    [WLWebCaller getAttendeesForProgramme:_dictionary[@"id"] completion:^(bool success, id result) {
        _attendeesArray = [[NSMutableArray alloc] initWithArray:result];
        [self.tableView reloadData];
    }];
}

-(void)shareProgram
{
    NSArray* array = @[_dictionary[@"name"], _dictionary[@"venue"], _dictionary[@"date"], _dictionary[@"time"], _dictionary[@"description"]];
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
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return _attendeesArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            NSString* text = _dictionary[@"description"];
            CGSize constraint = CGSizeMake(300, 20000);
            CGRect textSize = [text boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], NSFontAttributeName, nil] context:nil];
            return textSize.size.height + 30;
        }
        return tableView.rowHeight;
    }
    return 78;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 80;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIButton* rsvpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rsvpButton.frame = CGRectMake(0, 0, 220, 40);
        
        [WLWebCaller checkRSVPForProgramme:_dictionary[@"id"] userid:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyUserid] completion:^(bool success, id result) {
            NSLog(@"%@", result);
            NSDictionary* dict = result;
            if ([dict[@"success"] boolValue]) {
                [rsvpButton setTitle:@"Attending" forState:UIControlStateNormal];
                rsvpButton.backgroundColor = [UIColor darkGrayColor];
            } else {
                [rsvpButton setTitle:@"RSVP" forState:UIControlStateNormal];
                rsvpButton.backgroundColor = [UIColor redColor];
                [rsvpButton addTarget:self action:@selector(rsvpClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }];
        
        rsvpButton.layer.cornerRadius = 4;
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        [view addSubview:rsvpButton];
        
        rsvpButton.center = view.center;
        
        return view;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = _dictionary[@"venue"];
            cell.textLabel.numberOfLines = 0;
            cell.detailTextLabel.text = @"";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = [WLFormatter formatDate:_dictionary[@"date"]];
            cell.detailTextLabel.text = [WLFormatter formatTime:_dictionary[@"time"]];
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = _dictionary[@"description"];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (indexPath.section == 1) {
        WLAttendeesTableViewCell*  attendeeCell = (WLAttendeesTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"attendeeCell"];
        if ([_attendeesArray[indexPath.row][@"id"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyUserid]]) {
            attendeeCell.nameLabel.text = NSLocalizedString(@"You", nil);
        } else {
            attendeeCell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",_attendeesArray[indexPath.row][@"firstname"], _attendeesArray[indexPath.row][@"lastname"]];
        }
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
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Open in...", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Google Maps", @"Apple Maps", nil];
        [sheet showFromRect:self.view.window.frame inView:self.view animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add to Calendar", nil) message:[NSString stringWithFormat:NSLocalizedString(@"Add %@ to Calendar?", nil), _dictionary[@"name"]] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Add", nil), nil];
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
            event.location = _dictionary[@"venue"];
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError* err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        }];
    }
}

-(void)rsvpClicked:(id)sender
{
    [WLWebCaller RSVPForUser:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyUserid] forProgramme:_dictionary[@"id"] completion:^(bool success, id result) {
        NSLog(@"%@", result);
        [self getAttendees];
        _shouldRefreshPreviousView = true;
    }];
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

@end
