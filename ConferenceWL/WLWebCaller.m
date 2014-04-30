//
//  WLWebCaller.m
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/18/14.
//
//

#import "WLWebCaller.h"

@implementation WLWebCaller

+(void)signupWithFirstName:(NSString *)firstName lastName:(NSString *)lastName email:(NSString *)email password:(NSString *)passwor completion:(void (^)(bool, id))completion
{
    NSString* urlString = [NSString stringWithFormat:kURLSignup, firstName, lastName,email, passwor];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [WLWebCaller getDataFromURL:urlString withCompletionBlock:completion];
}

+(void)loginForUsername:(NSString*)username password:(NSString*)password completion:(void(^)(bool success, id result))completion
{
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLLogin, username, password] withCompletionBlock:completion];
}

+(void)getAllProgrammesWithCompletion:(void (^)(bool, id))completion
{
    [WLWebCaller getDataFromURL:kURLGetAllProgrammes withCompletionBlock:completion];
}

+(void)getProgrammesForUser:(NSString *)userid completion:(void (^)(bool, id))completion
{
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLGetProgrammesForUser, userid] withCompletionBlock:completion];
}

+(void)checkRSVPForProgramme:(NSString *)programmeid completion:(void (^)(bool, id))completion
{
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLCheckRSVPForProgram, programmeid] withCompletionBlock:completion];
}

+(void)RSVPForUser:(NSString *)username forProgramme:(NSString *)programmeid completion:(void (^)(bool, id))completion
{
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLSetRSVPForUser, username, programmeid] withCompletionBlock:completion];
}

+(void)getAllAttendeesWithCompletion:(void (^)(bool, id))completion
{
    [WLWebCaller getDataFromURL:kURLGetAttendees withCompletionBlock:completion];
}

+(void)getAttendeesForProgramme:(NSString *)programmeid completion:(void (^)(bool, id))completion
{
    [WLWebCaller getDataFromURL:[NSString stringWithFormat:kURLGetAttendeesForProgramme, programmeid] withCompletionBlock:completion];
}

+(void)getDataFromURL:(NSString*)url withCompletionBlock:(void(^)(bool success, id result))completion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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
