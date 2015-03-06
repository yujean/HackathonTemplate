//
//  HTParseManager.m
//  HackathonTemplate
//
//  Created by Eugene Yee on 3/5/15.
//
//

#import "HTParseManager.h"

#pragma message("Insert your Client Key from Parse here")
NSString * const HTParseApplicationID = @"YOUR APPLICATION ID HERE";
#pragma message("Insert your Client Key from Parse here")
NSString * const HTParseClientKey = @"YOUR CLIENT KEY HERE";

NSString * const HTParseBaseURLString = @"https://api.parse.com/1/";

@interface HTParseManager ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, assign) AFNetworkReachabilityStatus reachabilityStatus;
@end

@implementation HTParseManager

#pragma mark - Initialization and Setup

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static HTParseManager *sharedManager = nil;
    dispatch_once(&once, ^ {
        sharedManager = [[HTParseManager alloc] init];
        [sharedManager setupReachability];
        [Parse setApplicationId:HTParseApplicationID clientKey:HTParseClientKey];
    });
    return sharedManager;
}

- (void)setupReachability {
    // Session manager for requests
    [self setSessionManager:[[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HTParseBaseURLString]]];
    // Setup reachability
    [[[self sessionManager] reachabilityManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self setReachabilityStatus:status];
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                DLog(@"Not reachable");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"Reachable via wifi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"Reachable via WWAN");
                break;
            case AFNetworkReachabilityStatusUnknown:
                DLog(@"Reachability unknown");
                break;
        }
    }];
    [[[self sessionManager] reachabilityManager] startMonitoring];
}

#pragma mark - Examples of posting and retrieving objects to Parse

- (void)postObjectWithTitle:(NSString *)title file:(PFFile*)file {
    PFObject *object = [PFObject objectWithClassName:@"YourObject"];
    [object setValue:title forKey:@"title"];
    [object setObject:file forKey:@"file"];
    [object save];
}

- (void)getObjectsWithCompletion:(void(^)(NSArray *objects, NSError *error))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"YourObject"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completion(objects, error);
    }];
}

/*
 The following may be useful for debugging purposes
 */

//- (void)setupParseUserPermissions {
//    PFUser *user;
//    user = [PFUser logInWithUsername:@"yujean" password:@"Orange11!"];
//    PFACL *defaultACL = [PFACL ACL];
//    [defaultACL setPublicWriteAccess:NO];
//    if (user != nil) {
//        NSLog(@"Successfully logged in as yujean");
//        [defaultACL setPublicReadAccess:NO];
//    } else {
//        NSLog(@"Did not log in as yujean. Now logging in as anonymous user. Anything you save will be public.");
//        [PFUser enableAutomaticUser];
//        [defaultACL setPublicReadAccess:YES];
//    }
//    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
//}


#pragma mark - Convenience

- (BOOL)isReachable {
    AFNetworkReachabilityStatus status = [self reachabilityStatus];
    return status != AFNetworkReachabilityStatusNotReachable && status != AFNetworkReachabilityStatusUnknown;
}

@end
