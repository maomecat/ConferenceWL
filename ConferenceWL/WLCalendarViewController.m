//
//  WLCalendarViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/11/14.
//
//

#import "WLCalendarViewController.h"
//#import "WLNavigationController.h"
#import "MFSideMenu.h"

@interface WLCalendarViewController ()

@property (strong) IBOutlet MZDayPicker* dayPicker;
@property (strong) IBOutlet UITableView* tableView;

@property (strong) NSMutableArray* datasource;
@property (strong) NSArray* allProgrammesArray;

@end

@implementation WLCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Calendar", nil);
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];
    
    self.datasource = [NSMutableArray new];
    
    [WLWebCaller getDataFromURL:kURLGetAllProgrammes withCompletionBlock:^(bool success, id result) {
        _allProgrammesArray = [NSArray arrayWithArray:result];
    }];
    
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    self.dayPicker.year = 2014;
    [self.dayPicker setStartDate:[NSDate dateFromDay:18 month:4 year:2014] endDate:[NSDate dateFromDay:30 month:4 year:2014]];
    [self.dayPicker setCurrentDate:[NSDate date] animated:YES];

    self.dayPicker.dayNameLabelFontSize = 12.0f;
    self.dayPicker.dayLabelFontSize = 18.0f;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(todayClicked:)];
    
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
    [barButton setFrame:CGRectMake(0, 0, 20, 20)];
    [barButton addTarget:self action:@selector(leftSideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:barButton]];
}

-(void)leftSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

-(void)todayClicked:(id)sender {
    [self.dayPicker setCurrentDate:[NSDate date] animated:YES];
}

#pragma mark - UITableView Datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_datasource.count == 0) {
        return 2;
    }
    return [self.datasource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (_datasource.count == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"No Programmes";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor lightGrayColor];
            
        }
        return cell;
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", _datasource[indexPath.row][@"name"]];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MZDayPicker Datasource

#pragma mark - MZDayPicker Delegate

-(void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    self.datasource = [NSMutableArray new];
    
    for (NSDictionary* dict in _allProgrammesArray) {
        if ([dict[@"date"] isEqualToString:getStringFromDate(day.date)]) {
            [self.datasource addObject:dict];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Helper Function

NSString * getStringFromDate(NSDate* date) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
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
