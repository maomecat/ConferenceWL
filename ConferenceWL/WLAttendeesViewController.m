//
//  WLAttendeesViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/11/14.
//
//

#import "WLAttendeesViewController.h"
//#import "WLNavigationController.h"
#import "WLProgrammeViewController.h"
#import "MFSideMenu.h"
#import "WLAttendeesTableViewCell.h"

@interface WLAttendeesViewController ()

@property (strong) IBOutlet UITableView* tableView;

@property (strong) UIRefreshControl* refreshControl;
@property (strong) NSMutableArray* datasource;

@end

@implementation WLAttendeesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];
    
    self.title = @"Attendees";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
    [self refreshTable:self.refreshControl];
    [self setupLeftMenuBarButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)refreshTable:(UIRefreshControl*)refreshControl
{
    [WLWebCaller getDataFromURL:kURLGetAttendees withCompletionBlock:^(bool success, id result) {
        self.datasource = [[NSMutableArray alloc] initWithArray:result];
        NSSortDescriptor* sorter = [[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        [self.datasource sortUsingDescriptors:[NSArray arrayWithObjects:sorter, nil]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [refreshControl endRefreshing];
    }];
}

#pragma mark - UITableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLAttendeesTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WLAttendeesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.datasource[indexPath.row][@"firstname"], _datasource[indexPath.row][@"lastname"]];
    cell.thumbImageView.image = [UIImage imageNamed:@"profile-placeholder-75"];
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", _datasource[indexPath.row]);
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WLProgrammeViewController* prog = [sb instantiateViewControllerWithIdentifier:@"WLProgrammeViewController"];
    prog.userid = _datasource[indexPath.row][@"id"];
    [self.navigationController pushViewController:prog animated:YES];
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
