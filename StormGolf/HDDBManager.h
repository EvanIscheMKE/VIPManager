//
//  HDDBManager.h
//  StormGolf
//
//  Created by Evan Ische on 5/1/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import Foundation;

typedef void (^CompletionBlock)(NSArray *results);

@interface HDDBManager : NSObject
+ (HDDBManager *)sharedManager;
@property (nonatomic, strong) NSMutableArray *columnNames;
@property (nonatomic, assign) NSInteger affectedRows;
@property (nonatomic, assign) long long lastInsertedRowID;
@property (nonatomic, copy) NSString *documentsDirectory;
@property (nonatomic, copy) NSString *databaseFilename;
- (instancetype)initWithDatabaseFilename:(NSString *)filename;
- (void)copyDatabaseIntoDocumentsDirectory;
- (void)queryDataFromDatabase:(NSString *)query
                   completion:(CompletionBlock)completion;
- (void)executeQuery:(NSString *)query;

+ (NSString *)executableStringWithFirstName:(NSString *)firstname
                                   lastname:(NSString *)lastname
                                      email:(NSString *)email;
+ (NSString *)executableStringWithUserName:(NSString *)username
                                     price:(float)price
                               description:(NSString *)description
                                    userID:(NSInteger)userID;
+ (NSString *)queryStringFromUnixStartDate:(NSUInteger)startDate
                                finishDate:(NSUInteger)finishDate;
+ (NSString *)queryStringForTransactionsFromUserID:(NSUInteger)userID;
+ (NSString *)queryStringForTransactionsFromUserID:(NSUInteger)userID
                                beforeTransitionID:(NSUInteger)transitionID;
@end
