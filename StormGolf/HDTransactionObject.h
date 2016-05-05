//
//  HDTransactionObject.h
//  StormGolf
//
//  Created by Evan Ische on 5/3/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import Foundation;

#if 0
CREATE TABLE trans(transactionID integer primary key, createdAt timestamp default (strftime('%s','now')), username text, price real, item text,userID integer);
CREATE TABLE trans(transactionID integer primary key, createdAt date DEFAULT (datetime('now','localtime')), username text, price real, item text,userID integer);
#endif

@interface HDTransactionObject : NSObject
@property (nonatomic, assign) NSUInteger transactionID;
@property (nonatomic, assign) NSUInteger userID;
@property (nonatomic, assign) float transactionPrice;
@property (nonatomic, assign) NSDate *transactionDate;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *transactionDescription;
@end
