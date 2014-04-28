//
//  WLFormatter.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/28/14.
//
//

#import "WLFormatter.h"

@implementation WLFormatter

+(NSString*)formatTime:(NSString*)rawTime
{
    NSDateFormatter* formattter = [[NSDateFormatter alloc] init];
    [formattter setDateFormat:@"HH:mm:ss"];
    NSDate* date = [formattter dateFromString:rawTime];
    [formattter setDateFormat:@"h:mm a"];
    NSString* convertedTime = [formattter stringFromDate:date];
    NSLog(@"%@", convertedTime);
    return convertedTime;
}

+(NSString*)formatDate:(NSString*)rawDate
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [formatter dateFromString:rawDate];
    [formatter setDateFormat:@"MMM dd"];
    NSString* convertedDate = [formatter stringFromDate:date];
    NSLog(@"%@", convertedDate);
    return convertedDate;
}

@end
