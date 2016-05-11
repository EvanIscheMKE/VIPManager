//
//  HDUserObject.m
//  StormGolf
//
//  Created by Evan Ische on 5/3/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDUserObject.h"

@implementation HDUserObject

- (NSString *)fullname {
    if (self.firstName && self.lastName) {
        return [NSString stringWithFormat:@"%@ %@",self.firstName, self.lastName];
    }
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"LASTNAME:%@, FIRSTNAME:%@, EMAIL:%@", self.lastName, self.firstName, self.email];
}

@end
