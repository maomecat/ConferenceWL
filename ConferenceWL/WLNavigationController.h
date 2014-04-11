//
//  WLNavigationController.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/11/14.
//
//

#import <UIKit/UIKit.h>
#import "REMenu.h"

@interface WLNavigationController : UINavigationController

@property (strong, readonly, nonatomic) REMenu *menu;

- (void)toggleMenu;

@end
