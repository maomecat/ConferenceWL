//
//  WLTerms&PrivacyViewController.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/19/14.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    WLTerms_PrivacyViewTypeTerms = 0,
    WLTerms_PrivacyViewTypePrivacy
}WLTerms_PrivacyViewType;

@interface WLTerms_PrivacyViewController : UIViewController

@property (assign) WLTerms_PrivacyViewType viewType;

@end
