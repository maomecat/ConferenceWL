//
//  WLAppDelegate.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import "WLAppDelegate.h"
//#import "WLNavigationController.h"
#import "MFSideMenu.h"
#import "WLProgrammeViewController.h"
#import "WLMenuViewController.h"

@interface WLAppDelegate()

@property (strong) UIViewController* viewConroller;

@end

@implementation WLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loggedIn"] boolValue]) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WLProgrammeViewController* programmeVC = [sb instantiateViewControllerWithIdentifier:@"WLProgrammeViewController"];
        UINavigationController* navc = [[UINavigationController alloc] initWithRootViewController:programmeVC];
        _viewConroller = [MFSideMenuContainerViewController containerWithCenterViewController:navc leftMenuViewController:[[UINavigationController alloc] initWithRootViewController:[[WLMenuViewController alloc] init]] rightMenuViewController:nil];
    } else {
        _viewConroller = [sb instantiateViewControllerWithIdentifier:@"WLLoginViewController"];
    }
    
    self.window.rootViewController = _viewConroller;
    [self.window makeKeyAndVisible];
    
    //SETup navigation bar UI for the app
    [[UINavigationBar appearance] setBackgroundColor:[UIColor blueColor]];
    [UINavigationBar appearance].barTintColor = [UIColor redColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [UIView appearance].tintColor = [UIColor whiteColor];
    [UITextField appearance].tintColor = [UIColor redColor];
    
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    return YES;
}


+(NSString *)appVersionNumberDisplayString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@"%@ (%@)", majorVersion, minorVersion];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
