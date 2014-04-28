//
//  WLWebCaller.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/18/14.
//
//

#import "WLWebCaller.h"

@implementation WLWebCaller

+(void)getDataFromURL:(NSString*)url withCompletionBlock:(void(^)(bool success, id result))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (completion) {
                    completion(true, json);
                }
            } else {
                if (completion) {
                    completion(false, nil);
                }
            }
        });
    });
}

@end
