//
//  WLActivityView.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/18/14.
//
//

#import "WLActivityView.h"

@interface WLActivityView()

@property (strong) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (strong) IBOutlet UILabel* loadingMessageLabel;

@end

@implementation WLActivityView

+(void)showInView:(UIView *)view loadingMessage:(NSString *)loadingMessage
{
    WLActivityView* activity = [WLActivityView sharedInstance];
    activity.frame = view.frame;
    [activity.activityIndicator startAnimating];
    if (loadingMessage.length) {
        activity.loadingMessageLabel.text = loadingMessage;
    }
    activity.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [view addSubview:activity];
        activity.alpha = 1;
    }];
}

+(void)hide
{
    WLActivityView* activity = [WLActivityView sharedInstance];
    [activity.activityIndicator stopAnimating];
    [activity removeFromSuperview];
}

+(id)sharedInstance {
    static dispatch_once_t p = 0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* view = [[[NSBundle mainBundle] loadNibNamed:@"WLActivityView" owner:self options:nil] objectAtIndex:0];
//        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
        [self addSubview:view];
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
