//
//  WLFormatter.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/28/14.
//
//

#import <Foundation/Foundation.h>

@interface WLFormatter : NSObject

+(NSString*)formatTime:(NSString*)rawTime;
+(NSString*)formatDate:(NSString*)rawDate;

@end
