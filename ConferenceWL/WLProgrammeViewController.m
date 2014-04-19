//
//  WLProgrammeViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import "WLProgrammeViewController.h"
//#import "WLNavigationController.h"

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
    
    // Do any additional setup after loading the view.
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
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            [refreshControl endRefreshing];
        }];
    }
    
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLGetProgrammesForUser, [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] withCompletionBlock:^(bool success, id result) {
        _programesIAmAttending = [[NSMutableArray alloc] initWithArray:result];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_datasource.count == 0) {
        return 2;
    }
    return _datasource.count;
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
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = _datasource[indexPath.row][@"name"];
        cell.detailTextLabel.text = _datasource[indexPath.row][@"date"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if ([[_programesIAmAttending valueForKey:@"id"] containsObject:_datasource[indexPath.row][@"id"]]) {
            [button setTitle:@"Attending" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"RSVP" forState:UIControlStateNormal];
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
