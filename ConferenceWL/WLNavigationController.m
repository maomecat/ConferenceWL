//
//  WLNavigationController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/11/14.
//
//

#import "WLNavigationController.h"
#import "WLProgrammeViewController.h"
#import "WLAttendeesViewController.h"

@interface WLNavigationController ()

@property (strong, readwrite, nonatomic) REMenu *menu;

@end

@implementation WLNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (REUIKitIsFlatMode()) {
        [self.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:0/255.0 green:213/255.0 blue:161/255.0 alpha:1]];
        self.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navigationBar.tintColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
    }
    
    __typeof (self) __weak weakSelf = self;
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"Home"
                                                    subtitle:@"Return to Home Screen"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                          UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                          WLProgrammeViewController *controller = [sb instantiateViewControllerWithIdentifier:@"WLProgrammeViewController"];
                                                          [weakSelf setViewControllers:@[controller] animated:NO];
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"Explore"
                                                       subtitle:@"Explore 47 additional options"
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                             WLAttendeesViewController *controller = [sb instantiateViewControllerWithIdentifier:@"WLAttendeesViewController"];
                                                             [weakSelf setViewControllers:@[controller] animated:NO];
                                                         }];
    
    //    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"Activity"
    //                                                        subtitle:@"Perform 3 additional activities"
    //                                                           image:[UIImage imageNamed:@"Icon_Activity"]
    //                                                highlightedImage:nil
    //                                                          action:^(REMenuItem *item) {
    //                                                              NSLog(@"Item: %@", item);
    //                                                              ActivityViewController *controller = [[ActivityViewController alloc] init];
    //                                                              [weakSelf setViewControllers:@[controller] animated:NO];
    //                                                          }];
    //
    //    activityItem.badge = @"12";
    //
    //    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"Profile"
    //                                                          image:[UIImage imageNamed:@"Icon_Profile"]
    //                                               highlightedImage:nil
    //                                                         action:^(REMenuItem *item) {
    //                                                             NSLog(@"Item: %@", item);
    //                                                             ProfileViewController *controller = [[ProfileViewController alloc] init];
    //                                                             [weakSelf setViewControllers:@[controller] animated:NO];
    //                                                         }];
    
    // You can also assign a custom view for any particular item
    // Uncomment the code below and add `customViewItem` to `initWithItems` array, for example:
    // self.menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem, customViewItem]]
    //
    /*
     UIView *customView = [[UIView alloc] init];
     customView.backgroundColor = [UIColor blueColor];
     customView.alpha = 0.4;
     REMenuItem *customViewItem = [[REMenuItem alloc] initWithCustomView:customView action:^(REMenuItem *item) {
     NSLog(@"Tap on customView");
     }];
     */
    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    
    self.menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem]];
    
    // Background view
    //
    //self.menu.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    //self.menu.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //self.menu.backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
    
    //self.menu.imageAlignment = REMenuImageAlignmentRight;
    //self.menu.closeOnSelection = NO;
    //self.menu.appearsBehindNavigationBar = NO; // Affects only iOS 7
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    }
    
    // Blurred background in iOS 7
    //
    self.menu.liveBlur = YES;
    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    
    [self.menu setClosePreparationBlock:^{
        NSLog(@"Menu will close");
    }];
    
    [self.menu setCloseCompletionHandler:^{
        NSLog(@"Menu did close");
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self];
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
