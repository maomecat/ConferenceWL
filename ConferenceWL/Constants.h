//
//  Constants.h
//  ConferenceWL
//
//  Created by Rishabh Tayal on 4/17/14.
//
//

#ifndef ConferenceWL_Constants_h
#define ConferenceWL_Constants_h

#define kURLPrefix @"http://appikon.com/Webservices/api.php?"
#define kURLSignup [NSString stringWithFormat:@"%@%@", kURLPrefix, @"method=signup&firstname=%@&lastname=%@&email=%@&password=%@"]
#define kURLLogin [NSString stringWithFormat:@"%@%@", kURLPrefix, @"method=login&email=%@&password=%@"]
#define kURLGetAttendees [NSString stringWithFormat:@"%@%@", kURLPrefix, @"method=getAllUsers"]
#define kURLGetAllProgrammes [NSString stringWithFormat:@"%@%@", kURLPrefix, @"method=getAllProgrammes"]
#define kURLGetProgrammesForUser [NSString stringWithFormat:@"%@%@", kURLPrefix, @"method=getProgrammesForUser&userid=%@"]
#define kURLGetAttendeesForProgramme [NSString stringWithFormat:@"%@%@", kURLPrefix, @"method=getAttendeesForProgramm&programmeid=%@"]
#define kURLSetRSVPForUser [NSString stringWithFormat:@"%@%@",kURLPrefix, @"method=setRSVPForUser&userid=%@&programmeid=%@"]

#endif
