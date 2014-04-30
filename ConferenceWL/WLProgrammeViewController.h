//
//  WLProgrammeViewController.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/10/14.
//
//

#import <UIKit/UIKit.h>
#import <TLIndexPathTools/TLTableViewController.h>

@interface WLProgrammeViewController : TLTableViewController

@property (strong) NSString* userid;

-(void)refreshTable:(UIRefreshControl*)refreshControl;

@end
