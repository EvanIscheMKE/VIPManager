//
//  HDDBManager.h
//  StormGolf
//
//  Created by Evan Ische on 5/1/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import Foundation;

@interface HDDBManager : NSObject
+ (HDDBManager *)sharedManager;
@property (nonatomic, strong) NSMutableArray *columnNames;
@property (nonatomic, assign) NSInteger affectedRows;
@property (nonatomic, assign) long long lastInsertedRowID;
@property (nonatomic, copy) NSString *documentsDirectory;
@property (nonatomic, copy) NSString *databaseFilename;
- (instancetype)initWithDatabaseFilename:(NSString *)filename;
- (void)copyDatabaseIntoDocumentsDirectory;
- (NSArray *)loadUserDataFromDatabase:(NSString *)query;
- (NSArray *)loadTransactionDataFromDatabase:(NSString *)query;
- (void)executeQuery:(NSString *)query;
+ (NSString *)executableStringWithFirstName:(NSString *)firstname
                                   lastname:(NSString *)lastname
                                      email:(NSString *)email;
+ (NSString *)executableStringWithUserName:(NSString *)username
                                     price:(float)price
                               description:(NSString *)description
                                    userID:(NSInteger)userID;
@end
