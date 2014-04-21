//
//  WMMenuViewController.m
//  JPW Sales
//
//  Created by Rishabh Tayal on 4/3/14.
//  Copyright (c) 2014 Rishabh Tayal. All rights reserved.
//

#import "WLMenuViewController.h"
#import "WLProgrammeViewController.h"
#import "WLAttendeesViewController.h"
#import "WLFloorPlanViewController.h"
#import "WLCalendarViewController.h"
#import "WLSettingsViewController.h"
//#import "WMNewsDocument.h"
//#import "WMSPRViewController.h"
#import "MFSideMenu.h"

@interface WLMenuViewController ()

@property (nonatomic, strong) WLProgrammeViewController* prog;
@property (nonatomic, strong) WLAttendeesViewController* att;
@property (nonatomic, strong) WLFloorPlanViewController* floor;
@property (nonatomic, strong) WLCalendarViewController* cal;
@property (nonatomic, strong) WLSettingsViewController* settings;

//@property (nonatomic, strong) WMNewsDocument* doc;

//@property (nonatomic, strong) UINavigationController* navC;
@end

@implementation WLMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.navigationItem setTitleView:[UIView setNavigationTitleImage:NAVIGATIONBARTITLEVIEW]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:NAVIGATIONBARBACKGROUND] forBarMetrics:UIBarMetricsDefault];
    self.title = @"Conference App";
    
    UIImageView* footerIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 8)];
    footerIV.image = [UIImage imageNamed:@"left_panel_shadow_1px.png"];
    self.tableView.tableFooterView = footerIV;
    //
    //    _navC = [[UINavigationController alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReloaded:) name:@"noteModified" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(BOOL)shouldAutorotate
//{
//    if (CURRENTDEVICE == IPHONE)
//        return NO;
//    else
//        return YES;
//}
//
//-(void)dataReloaded:(NSNotification*)notification {
//    _doc = [notification object];
//    [self.tableView reloadData];
//}
//
//-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    if (CURRENTDEVICE == IPHONE)
//        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
//    else
//    {
//        return YES;
//    }
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selection-bar-off.png"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selection-bar-on.png"]]];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Programmes";
            break;
        case 1:
            cell.textLabel.text = @"Attendees";
            break;
        case 2:
            cell.textLabel.text = @"Floor Plan";
            break;
        case 3:
        {
            cell.textLabel.text = @"Calendar";
        }
            break;
        default:
            cell.textLabel.text = @"Settings";
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSMutableArray* array;
    switch (indexPath.row) {
        case 0:
        {
            if (!_prog)

                _prog = [sb instantiateViewControllerWithIdentifier:@"WLProgrammeViewController"];
            array = [[NSMutableArray alloc] initWithObjects:_prog, nil];
        }
            break;
        case 1:
        {
            if (!_att)
                _att = [sb instantiateViewControllerWithIdentifier:@"WLAttendeesViewController"];
            array =[[NSMutableArray alloc] initWithObjects:_att, nil];
        }
            break;
        case 2:
        {
            if (!_floor)
                _floor = [sb instantiateViewControllerWithIdentifier:@"WLFloorPlanViewController"];
            array = [[NSMutableArray alloc] initWithObjects:_floor, nil];
        }
            break;
        case 3:
        {
            if (!_cal)
                _cal = [sb instantiateViewControllerWithIdentifier:@"WLCalendarViewController"];
            array = [[NSMutableArray alloc] initWithObjects:_cal, nil];
        }
            break;
        default:
        {
            if (!_settings)
                _settings = [sb instantiateViewControllerWithIdentifier:@"WLSettingsViewController"];
            array = [[NSMutableArray alloc] initWithObjects:_settings, nil];
        }
            break;
    }
    UINavigationController* nav = self.menuContainerViewController.centerViewController;
    nav.viewControllers = array;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

@end