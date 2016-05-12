//
//  HDTransactionObject.h
//  StormGolf
//
//  Created by Evan Ische on 5/3/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import Foundation;

@interface HDTransactionObject : NSObject
@property (nonatomic, assign) NSUInteger iD;
@property (nonatomic, assign) NSUInteger userID;
@property (nonatomic, assign) double cost;
@property (nonatomic, assign) NSDate *date;
@property (nonatomic, copy) NSString *admin;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readonly) BOOL addition;
@end
