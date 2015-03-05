//
//  HTParseManager.h
//  HackathonTemplate
//
//  Created by Eugene Yee on 3/5/15.
//
//

#import <Foundation/Foundation.h>

@interface HTParseManager : NSObject
/// Returns a singleton instance of a manager that takes care of Parse object saves and object retrievals
+ (instancetype)sharedManager;
- (BOOL)isReachable;
@end
