//
//  WLFloorPlanViewController.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/11/14.
//
//

#import "WLFloorPlanViewController.h"
//#import "WLNavigationController.h"

@interface WLFloorPlanViewController ()
{
    
}

@property (strong) IBOutlet UIScrollView* scrollView;
@property (strong) IBOutlet UIPageControl* pageControl;

@end

@implementation WLFloorPlanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Floor Plans";
    
    self.automaticallyAdjustsScrollViewInsets = NO;

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.navigationController action:@selector(toggleMenu)];
  
    NSArray* images = [NSArray arrayWithObjects:@"Map_Moscone_SM_L1_Base.png", @"Map_Moscone_SM_L2_Base.png", @"Map_Moscone_SM_L3_Base.png", nil];
    
    for (int i = 0; i < images.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        subview.image = [UIImage imageNamed:images[i]];
        subview.contentMode = UIViewContentModeScaleAspectFit;
        subview.clipsToBounds = YES;
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * images.count, self.scrollView.frame.size.height);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
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
