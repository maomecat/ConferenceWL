//
//  WLWebCaller.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/18/14.
//
//

#import <Foundation/Foundation.h>

@interface WLWebCaller : NSObject

+(void)signupWithFirstName:(NSString*)firstName lastName:(NSString*)lastName email:(NSString*)email password:(NSString*)passwor completion:(void(^)(bool success, id result))completion;
+(void)loginForUsername:(NSString*)username password:(NSString*)password completion:(void(^)(bool success, id result))completion;

+(void)getAllProgrammesWithCompletion:(void(^)(bool success, id result))completion;
+(void)getProgrammesForUser:(NSString*)userid completion:(void(^)(bool success, id result))completion;

+(void)getAllAttendeesWithCompletion:(void(^)(bool success, id result))completion;
+(void)getAttendeesForProgramme:(NSString*)programmeid completion:(void(^)(bool success, id result))completion;


+(void)checkRSVPForProgramme:(NSString*)programmeid userid:(NSString*)userid completion:(void(^)(bool success, id result))completion;
+(void)RSVPForUser:(NSString*)username forProgramme:(NSString*)programmeid completion:(void(^)(bool success, id result))completion;

@end
