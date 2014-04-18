//
//  WLWebCaller.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/18/14.
//
//

#import <Foundation/Foundation.h>

@interface WLWebCaller : NSObject

+(void)getDataFromURL:(NSString*)url withCompletionBlock:(void(^)(bool success, id result))completion;

@end
