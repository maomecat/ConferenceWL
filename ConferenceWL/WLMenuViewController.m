//
//  WLMenuViewController.m
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
#import "MFSideMenu.h"
#import "FXBlurView.h"
#import "UIImageView+AFNetworking.h"

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
    
    self.title = @"Conference App";
    
    UIImageView* footerIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 8)];
    footerIV.image = [UIImage imageNamed:@"left_panel_shadow_1px.png"];
    self.tableView.tableFooterView = footerIV;
   
    UIImage* img = [UIImage imageNamed:@"chicago1.jpg"];
    UIImage* blurImage = [self gaussianBlur:img];
    UIImageView* iv = [[UIImageView alloc] initWithImage:blurImage];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.frame = self.tableView.frame;
    self.tableView.backgroundView = iv;
    self.tableView.backgroundColor = [UIColor clearColor];
       
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage*)gaussianBlur:(UIImage*)img
{
    CIFilter* gaussianBLurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBLurFilter setDefaults];
    [gaussianBLurFilter setValue:[CIImage imageWithCGImage:[img CGImage]] forKey:kCIInputImageKey];
    [gaussianBLurFilter setValue:@10 forKey:kCIInputRadiusKey];
    
    CIImage* outImage = [gaussianBLurFilter outputImage];
    CIContext* context = [CIContext contextWithOptions:nil];
    CGRect rect = [outImage extent];
    
    rect.origin.x += (rect.size.width - img.size.width) / 2;
    rect.origin.y += (rect.size.height - img.size.height) / 2;
    rect.size = img.size;
    
    CGImageRef cgimg = [context createCGImage:outImage fromRect:rect];
    UIImage* image = [UIImage imageWithCGImage:cgimg];
    return image;
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 80, 80)];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.layer.cornerRadius = iv.frame.size.height/2;
    iv.layer.masksToBounds = YES;
    iv.layer.borderColor = [UIColor redColor].CGColor;
    iv.layer.borderWidth = 1;
    
    [iv setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"photoURL"]] placeholderImage:[UIImage imageNamed:@"profile-placeholder-75"]];
    
    CGPoint center;
    center.x = view.center.x;
    center.y = iv.center.y;
    iv.center = center;
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iv.frame.origin.y + iv.frame.size.height, self.view.frame.size.width, 40)];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_firstname"], [[NSUserDefaults standardUserDefaults] objectForKey:@"user_lastname"]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor lightGrayColor];
    
    center.x = view.center.x;
    center.y = nameLabel.center.y;
    nameLabel.center = center;
    
    [view addSubview:nameLabel];
    [view addSubview:iv];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectedBackgroundView = [UIView new];
    }
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:28];
    cell.backgroundColor = [UIColor clearColor];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Programmes";
            break;
        case 1:
            NSLog(@"%@", NSLocalizedString(@"Attendees", nil));
            cell.textLabel.text = NSLocalizedString(@"Attendees", nil);
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
