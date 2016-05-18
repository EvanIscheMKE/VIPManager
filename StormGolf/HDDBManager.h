//
//  HDDBManager.h
//  StormGolf
//
//  Created by Evan Ische on 5/1/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import Foundation;

typedef void (^CompletionBlock)(NSArray *results);
typedef void (^ResultsBlock)(float startingBalance);

@interface HDDBManager : NSObject
+ (HDDBManager *)sharedManager;
@property (nonatomic, strong) NSMutableArray *columnNames;
@property (nonatomic, assign) NSInteger affectedRows;
@property (nonatomic, assign) long long lastInsertedRowID;
@property (nonatomic, copy) NSString *documentsDirectory;
@property (nonatomic, copy) NSString *databaseFilename;
- (instancetype)initWithDatabaseFilename:(NSString *)filename;
- (void)copyDatabaseIntoDocumentsDirectory;
- (void)queryUserDataFromDatabase:(NSString *)query
                       completion:(CompletionBlock)completion;
- (void)queryTransactionDataFromDatabase:(NSString *)query
                              completion:(CompletionBlock)completion;
- (void)executeQuery:(NSString *)query;
- (void)closeDatabase;
- (void)currentUserBalanceWithUserID:(NSInteger)userID
                             results:(ResultsBlock)resultsBlock;
- (void)currentUser:(NSInteger)userID
balanceForTransactionID:(NSInteger)transactionID
            results:(ResultsBlock)resultsBlock;

+ (NSString *)queryStringForFirstName:(NSString *)firstName
                             lastName:(NSString *)lastName;
+ (NSString *)executableStringWithFirstName:(NSString *)firstname
                                   lastname:(NSString *)lastname
                                      email:(NSString *)email;
+ (NSString *)executableStringWithUserName:(NSString *)username
                                     price:(double)price
                               description:(NSString *)description
                                    userID:(NSInteger)userID
                                     admin:(NSString *)admin;
+ (NSString *)queryStringFromUnixStartDate:(NSInteger)startDate
                                finishDate:(NSInteger)finishDate;
+ (NSString *)queryStringForTransactionsFromUserID:(NSInteger)userID;
+ (NSString *)queryStringForTransactionsFromUserID:(NSInteger)userID
                                beforeTransitionID:(NSInteger)transitionID;
@end
