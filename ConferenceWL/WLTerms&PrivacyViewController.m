//
//  WLTerms&PrivacyViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/19/14.
//
//

#import "WLTerms&PrivacyViewController.h"

@interface WLTerms_PrivacyViewController ()

@property (strong) IBOutlet UITextView* textView;

@end

@implementation WLTerms_PrivacyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_viewType == WLTerms_PrivacyViewTypePrivacy) {
        self.title = @"Privacy Policy";
    } else {
        self.title = @"Terms of Service";
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
