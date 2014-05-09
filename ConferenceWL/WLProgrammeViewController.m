//
//  WLProgrammeViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import "WLProgrammeViewController.h"
//#import "WLNavigationController.h"
#import "WLProgrammeTableViewCell.h"
#import "WLProgrammeDetailViewController.h"
#import "MFSideMenu.h"
#import <TLIndexPathTools/TLIndexPathDataModel.h>
#import "WLFormatter.h"

@interface WLProgrammeViewController ()

@property (strong) NSMutableArray* programesIAmAttending;
@property (strong) UIRefreshControl* refreshControl;

@end

@implementation WLProgrammeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    self.title = NSLocalizedString(@"Programmes", nil);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    [self refreshTable:self.refreshControl];
    
    if (!_userid) {
        [self setupLeftMenuBarButton];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(scrollToToday:)]];
    }
    // Do any additional setup after loading the view.
}

-(void)setupLeftMenuBarButton
{
    UIButton* barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setBackgroundImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
    [barButton setFrame:CGRectMake(0, 0, 20, 20)];
    [barButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:barButton]];
}

-(void)scrollToToday:(id)sender
{
    NSDate* todayDate = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd"];
    NSString* stringDate = [formatter stringFromDate:todayDate];
    int section = 0;
    
    //Get current date from data soruce
    if ([self.indexPathController.dataModel.sectionNames containsObject:stringDate] ) {
        section = [self.indexPathController.dataModel.sectionNames indexOfObject:stringDate];
    } else {
        //Get closes date to current date from data source.
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* firstDate = [formatter dateFromString:self.indexPathController.dataModel.items[0][@"date"]];
        double min = [todayDate timeIntervalSinceDate:firstDate];
        
        for (int i = 1 ; i < [self.indexPathController.dataModel.items count]; ++i) {
            NSDate* date = [formatter dateFromString:self.indexPathController.dataModel.items[i][@"date"]];
            double currentMin = abs([todayDate timeIntervalSinceDate:date]);
            if (currentMin < min) {
                min = currentMin;
                section = i;
            }
        }
        
        NSDate* selectedDate = [formatter dateFromString:self.indexPathController.dataModel.items[section][@"date"]];
        [formatter setDateFormat:@"MMM dd"];
        NSString* selectedString = [formatter stringFromDate:selectedDate];
        
        section = [self.indexPathController.dataModel.sectionNames indexOfObject:selectedString];
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)leftSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

-(void)refreshTable:(UIRefreshControl*)refreshControl {
    
    if (_userid) {
        [WLWebCaller getProgrammesForUser:_userid completion:^(bool success, id result) {
            if (result != nil) {
                
                NSArray* datasource = result;
                NSArray* sortedArray = [self sortedArray:datasource withKey:@"date" key2:@"time"];
                self.indexPathController.dataModel = [[TLIndexPathDataModel alloc] initWithItems:sortedArray sectionNameBlock:^NSString *(id item) {
                    NSDictionary* dict = item;
                    NSString* str = [WLFormatter formatDate:[dict objectForKey:@"date"]];
                    return str;
                } identifierBlock:nil];
                [self.tableView reloadData];
            }
            [refreshControl endRefreshing];
            
        }];
    } else {
        
        [WLWebCaller getAllProgrammesWithCompletion:^(bool success, id result) {
            NSArray* datasource = result;
            NSArray* sortedArray = [self sortedArray:datasource withKey:@"date" key2:@"time"];
            self.indexPathController.dataModel = [[TLIndexPathDataModel alloc] initWithItems:sortedArray sectionNameBlock:^NSString *(id item) {
                NSDictionary* dict = item;
                NSString* str = [WLFormatter formatDate:[dict objectForKey:@"date"]];
                return str;
            } identifierBlock:nil];
            
            UILabel* footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
            footerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d Programmes", nil), sortedArray.count];
            footerLabel.textColor = [UIColor lightGrayColor];
            footerLabel.font = [UIFont systemFontOfSize:24];
            footerLabel.textAlignment = NSTextAlignmentCenter;
            self.tableView.tableFooterView = footerLabel;
            
            //            [self.tableView reloadData];
            [refreshControl endRefreshing];
        }];
    }
    
    [WLWebCaller getProgrammesForUser:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyUserid] completion:^(bool success, id result) {
        _programesIAmAttending = [[NSMutableArray alloc] initWithArray:result];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, 320, 40);
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = [self.indexPathController.dataModel sectionNameForSection:section];
    
    UIView* header = [[UIView alloc] initWithFrame:label.bounds];
    header.backgroundColor = [UIColor colorWithRed:2 green:2 blue:2 alpha:0.5];
    [header addSubview:label];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.indexPathController.dataModel sectionForSectionName:title];
}

-(UITableViewCell *)tableView:(UITableView *)tableView prototypeForCellIdentifier:(NSString *)cellIdentifier
{
    WLProgrammeTableViewCell* cell = (WLProgrammeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WLProgrammeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLProgrammeTableViewCell* cell = (WLProgrammeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary* dict = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
    cell.progNameLabel.text = dict[@"name"];
    cell.timeLabel.text = [WLFormatter formatTime:dict[@"time"]];
    
    if (!_userid) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        if ([[_programesIAmAttending valueForKey:@"id"] containsObject:dict[@"id"]]) {
            [button setTitle:@"Attending" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"RSVP" forState:UIControlStateNormal];
            button.tag = indexPath.row;
            [button addTarget:self action:@selector(rsvpClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.borderColor = [UIColor redColor].CGColor;
            button.layer.cornerRadius = 4;
            button.layer.borderWidth = 1;
        }
        [button setFrame:CGRectMake(0, 0, 70, 35)];
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 45)];
        [view addSubview:button];
        button.center = CGPointMake(button.center.x, view.center.y);
        
        cell.accessoryView = view;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

-(void)rsvpClicked:(UIButton*)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    WLProgrammeTableViewCell* cell = (WLProgrammeTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView* indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indView.frame = CGRectMake(0, 0, 80, 35);
    [indView startAnimating];
    cell.accessoryView = indView;
    
    NSDictionary* dict = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
    [WLWebCaller RSVPForUser:[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyUserid] forProgramme:dict[@"id"] completion:^(bool success, id result) {
        [self refreshTable:self.refreshControl];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ProgrammeDetailSegue"]) {
        WLProgrammeDetailViewController* progDetail = segue.destinationViewController;
        progDetail.dictionary = [self.indexPathController.dataModel itemAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}

#pragma mark -

-(NSArray*)sortedArray:(NSArray*)orgArray withKey:(NSString*)key1 key2:(NSString*)key2
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss"];
    NSSortDescriptor* timeDesc = [[NSSortDescriptor alloc] initWithKey:key2 ascending:YES];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSSortDescriptor* dateDesc = [[NSSortDescriptor alloc] initWithKey:key1 ascending:YES];
    
    NSArray* desc = [NSArray arrayWithObjects:dateDesc, timeDesc, nil];
    NSArray* sortedArray = [orgArray sortedArrayUsingDescriptors:desc];
    return sortedArray;
}

@end
