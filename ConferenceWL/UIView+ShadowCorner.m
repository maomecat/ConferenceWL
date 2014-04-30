//
//  UIView+ShadowCorner.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/30/14.
//
//

#import "UIView+ShadowCorner.h"

@implementation UIView (ShadowCorner)

-(void)roundCornerWithRadius:(CGFloat)radius shadowColor:(UIColor*)color andShadowOffset:(CGFloat)shadowOffset
{
    const float CORNER_RADIUS = radius;
    const float SHADOW_OFFSET = shadowOffset;
    const float SHADOW_OPACITY = 0.5;
    const float SHADOW_RADIUS = 3.0;
    
    UIView *superView = self.superview;
    
    CGRect oldBackgroundFrame = self.frame;
    [self removeFromSuperview];
    
    CGRect frameForShadowView = CGRectMake(0, 0, oldBackgroundFrame.size.width, oldBackgroundFrame.size.height);
    UIView *shadowView = [[UIView alloc] initWithFrame:frameForShadowView];
    [shadowView.layer setShadowOpacity:SHADOW_OPACITY];
    [shadowView.layer setShadowRadius:SHADOW_RADIUS];
    [shadowView.layer setShadowOffset:CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET)];
    [shadowView.layer setShadowColor:color.CGColor];
    
    [self.layer setCornerRadius:CORNER_RADIUS];
    [self.layer setMasksToBounds:YES];
    
    [shadowView addSubview:self];
    [superView addSubview:shadowView];
}

@end
