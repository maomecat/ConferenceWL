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

@interface WLProgrammeViewController ()

@property (strong) IBOutlet UITableView* tableView;

@property (strong) NSMutableArray* datasource;
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
    [barButton setFrame:CGRectMake(0, 0, 30, 30)];
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
            _datasource = [[NSMutableArray alloc] initWithArray:result];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [refreshControl endRefreshing];
        }];
    } else {
    [WLWebCaller getDataFromURL:kURLGetAllProgrammes withCompletionBlock:^(bool success, id result) {
            _datasource = [[NSMutableArray alloc] initWithArray:result];
            NSLog(@"%@", _datasource);
//         [self.tableView reloadData];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [refreshControl endRefreshing];
        }];
    }

    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLGetProgrammesForUser, [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] withCompletionBlock:^(bool success, id result) {
        _programesIAmAttending = [[NSMutableArray alloc] initWithArray:result];
//        [self.tableView reloadData];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [_datasource valueForKey:@"date"][section];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_datasource.count == 0) {
        return 2;
    }
    return [_datasource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_datasource.count == 0) {
        //There are no programmes to show - let the user know
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"No Programmes";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }
        return cell;
        
    } else {
        WLProgrammeTableViewCell* cell = (WLProgrammeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[WLProgrammeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.progNameLabel.text = _datasource[indexPath.row][@"name"];
        cell.timeLabel.text = _datasource[indexPath.row][@"date"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if ([[_programesIAmAttending valueForKey:@"id"] containsObject:_datasource[indexPath.row][@"id"]]) {
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
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)rsvpClicked:(UIButton*)sender {
    NSLog(@"%@", _datasource[sender.tag]);
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLSetRSVPForUser, [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], _datasource[sender.tag][@"id"]] withCompletionBlock:^(bool success, id result) {
        NSLog(@"%@", result);
        [self refreshTable:self.refreshControl];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    if ([segue.identifier isEqualToString:@"ProgrammeDetailSegue"]) {
        WLProgrammeDetailViewController* progDetail = segue.destinationViewController;
        progDetail.dictionary = [_datasource objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

@end
