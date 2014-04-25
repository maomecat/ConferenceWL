//
//  WLAttendeesViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/11/14.
//
//

#import "WLAttendeesViewController.h"
#import "WLProgrammeViewController.h"
#import "MFSideMenu.h"
#import "WLAttendeesTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <TLIndexPathTools/TLIndexPathDataModel.h>

@interface WLAttendeesViewController ()

@property (strong) UIRefreshControl* refreshControl;

@end

@implementation WLAttendeesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Attendees";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.sectionIndexColor = [UIColor redColor];

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
        
        NSArray* datasource = result;
        NSSortDescriptor* firstNameSorter = [[NSSortDescriptor alloc] initWithKey:@"firstname" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        NSSortDescriptor* lastNameSorter = [[NSSortDescriptor alloc] initWithKey:@"lastname" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray* sortedArray = [datasource sortedArrayUsingDescriptors:[NSArray arrayWithObjects:firstNameSorter, lastNameSorter, nil]];
        
        self.indexPathController.dataModel = [[TLIndexPathDataModel alloc] initWithItems:sortedArray sectionNameBlock:^NSString *(id item) {
            NSDictionary* dict = item;
            NSString* str = [[dict objectForKey:@"firstname"] substringToIndex:1];
            return str;
        } identifierBlock:nil];
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    }];
}

#pragma mark - UITableView Datasource

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.indexPathController.dataModel sectionNameForSection:section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
//    return [self.indexPathController.dataModel sectionNames];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.indexPathController.dataModel sectionForSectionName:title];
}

-(UITableViewCell *)tableView:(UITableView *)tableView prototypeForCellIdentifier:(NSString *)cellIdentifier
{
    WLAttendeesTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WLAttendeesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WLAttendeesTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[WLAttendeesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    NSDictionary* dict = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", dict[@"firstname"], dict[@"lastname"]];

    if (dict[@"photo"] != NULL) {
        [cell.thumbImageView setImageWithURL:[NSURL URLWithString:dict[@"photo"]] placeholderImage:[UIImage imageNamed:@"profile-placeholder-75"]];
    }
   
    return cell;
}

#pragma mark - UITableView Delegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dict = [self.indexPathController.dataModel itemAtIndexPath:indexPath];
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WLProgrammeViewController* prog = [sb instantiateViewControllerWithIdentifier:@"WLProgrammeViewController"];
    prog.userid = dict[@"id"];
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
