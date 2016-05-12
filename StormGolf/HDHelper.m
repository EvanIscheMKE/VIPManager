//
//  HDHelper.m
//  StormGolf
//
//  Created by Evan Ische on 5/3/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDHelper.h"
#import "HDDBManager.h"
#import "HDUserObject.h"
#import "HDTransactionObject.h"

@implementation HDHelper

+ (NSArray *)userObjectsFromArray:(NSArray *)rawUserData
                  withColumnNames:(NSArray *)columns {
    
    NSInteger indexOfFirstname = [columns indexOfObject:@"firstname"];
    NSInteger indexOfLastname = [columns indexOfObject:@"lastname"];
    NSInteger indexOfEmail = [columns indexOfObject:@"email"];
    NSInteger indexOfUserID = [columns indexOfObject:@"userInfoID"];
    
    NSMutableArray *temporaryArray = [NSMutableArray arrayWithCapacity:rawUserData.count];
    for (NSArray *userInfo in rawUserData) {
        HDUserObject *user = [HDUserObject new];
        user.email = userInfo[indexOfEmail];
        user.firstName = userInfo[indexOfFirstname];
        user.lastName = userInfo[indexOfLastname];
        user.userID = [userInfo[indexOfUserID] integerValue];
        [temporaryArray addObject:user];
    }
    return temporaryArray;
}

+ (NSArray *)transactionObjectsFromArray:(NSArray *)rawTransactionData
                         withColumnNames:(NSArray *)columns {

    NSInteger indexOfUsername = [columns indexOfObject:@"username"];
    NSInteger indexOfDate = [columns indexOfObject:@"createdAt"];
    NSInteger indexOfPrice = [columns indexOfObject:@"price"];
    NSInteger indexOfUserID = [columns indexOfObject:@"userID"];
    NSInteger indexOfDescription = [columns indexOfObject:@"item"];
    NSInteger indexOfTransactionID = [columns indexOfObject:@"transactionID"];
    NSInteger indexOfAdmin = [columns indexOfObject:@"admin"];
    
    NSMutableArray *temporaryArray = [NSMutableArray arrayWithCapacity:rawTransactionData.count];
    for (NSArray *transactionInfo in rawTransactionData) {
        HDTransactionObject *transaction = [HDTransactionObject new];
        transaction.iD = [transactionInfo[indexOfTransactionID] integerValue];
        transaction.date = [NSDate dateWithTimeIntervalSince1970:[transactionInfo[indexOfDate] integerValue]];
        transaction.title = transactionInfo[indexOfDescription];
        transaction.cost = [transactionInfo[indexOfPrice] floatValue];
        transaction.userID = [transactionInfo[indexOfUserID] integerValue];
        transaction.username = transactionInfo[indexOfUsername];
        transaction.admin = transactionInfo[indexOfAdmin];
        [temporaryArray addObject:transaction];
    }
    return temporaryArray;
}

+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter * formatter = [[self class] formatter];
    return [formatter dateFromString:string];
}

+ (NSDateFormatter *)formatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterLongStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
    });
    return formatter;
}

+ (NSString *)stringFromNumber:(double)number {
    return [[[self class] numberFormatter] stringFromNumber:[NSNumber numberWithDouble:number]];
}

+ (NSNumberFormatter *)numberFormatter {
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    });
    return formatter;
}

@end
