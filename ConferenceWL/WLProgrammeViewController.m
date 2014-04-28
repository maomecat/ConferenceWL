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
    
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];
    
    self.title = @"Programmes";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    [self refreshTable:self.refreshControl];
    
    if (!_userid) {
        [self setupLeftMenuBarButton];
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

-(void)leftSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

-(void)refreshTable:(UIRefreshControl*)refreshControl {
    
    if (_userid) {
        [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLGetProgrammesForUser, _userid] withCompletionBlock:^(bool success, id result) {
            NSArray* datasource = result;
            NSArray* sortedArray = [self sortedArray:datasource withKey:@"date" key2:@"time"];
            self.indexPathController.dataModel = [[TLIndexPathDataModel alloc] initWithItems:sortedArray sectionNameBlock:^NSString *(id item) {
                NSDictionary* dict = item;
                NSString* str = [WLFormatter formatDate:[dict objectForKey:@"date"]];
                return str;
            } identifierBlock:nil];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        }];
    } else {
        [WLWebCaller getDataFromURL:kURLGetAllProgrammes withCompletionBlock:^(bool success, id result) {
            NSArray* datasource = result;
            NSArray* sortedArray = [self sortedArray:datasource withKey:@"date" key2:@"time"];
            self.indexPathController.dataModel = [[TLIndexPathDataModel alloc] initWithItems:sortedArray sectionNameBlock:^NSString *(id item) {
                NSDictionary* dict = item;
                NSString* str = [WLFormatter formatDate:[dict objectForKey:@"date"]];
                return str;
            } identifierBlock:nil];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        }];
    }
    
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLGetProgrammesForUser, [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] withCompletionBlock:^(bool success, id result) {
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
    header.backgroundColor = [UIColor colorWithRed:250 green:250 blue:250 alpha:0.8];
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
    if (!cell) {
        cell = [[WLProgrammeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSDictionary* dict = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
    cell.progNameLabel.text = dict[@"name"];
    cell.timeLabel.text = [WLFormatter formatTime:dict[@"time"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    if ([[_programesIAmAttending valueForKey:@"id"] containsObject:dict[@"id"]]) {
        [button setTitle:@"Attending" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"RSVP" forState:UIControlStateNormal];
        button.tag = indexPath.row;
        [button addTarget:self action:@selector(rsvpClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [button setFrame:CGRectMake(0, 0, 100, 35)];
    cell.accessoryView = button;
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)rsvpClicked:(UIButton*)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSDictionary* dict = [self.indexPathController.dataModel itemAtIndexPath:    [self.tableView indexPathForRowAtPoint:buttonPosition]];
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLSetRSVPForUser, [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], dict[@"id"]] withCompletionBlock:^(bool success, id result) {
        [self refreshTable:self.refreshControl];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"ProgrammeDetailSegue"]) {
        WLProgrammeDetailViewController* progDetail = segue.destinationViewController;
        progDetail.dictionary = [self.indexPathController.dataModel itemAtIndexPath:[self.tableView indexPathForSelectedRow]];
        //        progDetail.dictionary = [_datasource objectAtIndex:[self.tableView indexPathForSelectedRow].row];
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
