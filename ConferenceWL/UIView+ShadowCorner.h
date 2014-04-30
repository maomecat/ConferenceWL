//
//  UIView+ShadowCorner.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/30/14.
//
//

#import <UIKit/UIKit.h>

@interface UIView (ShadowCorner)

-(void)roundCornerWithRadius:(CGFloat)radius shadowColor:(UIColor*)color andShadowOffset:(CGFloat)shadowOffset;

@end
