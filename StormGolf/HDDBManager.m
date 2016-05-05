//
//  HDDBManager.m
//  StormGolf
//
//  Created by Evan Ische on 5/1/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;
#import <sqlite3.h>
#import "HDDBManager.h"
#import "HDHelper.h"

static NSString * const HDDatabaseKey = @"stormgolfdatabase.sql";

typedef void (^CompletionBlock)(NSArray *results);

@interface HDDBManager ()
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation HDDBManager

+ (HDDBManager *)sharedManager {
    static HDDBManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[HDDBManager alloc] initWithDatabaseFilename:HDDatabaseKey];
    });
    return sharedManager;
}

- (instancetype)initWithDatabaseFilename:(NSString *)filename {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths firstObject];
        self.databaseFilename = filename;
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

- (void)copyDatabaseIntoDocumentsDirectory {

    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
       
        NSError *error = nil;
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable {
    
    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    if (self.results != nil) {
        [self.results removeAllObjects];
        self.results = nil;
    }
    
    self.results = [[NSMutableArray alloc] init];
    if (self.columnNames != nil) {
        [self.columnNames removeAllObjects];
        self.columnNames = nil;
    }
    
    self.columnNames = [[NSMutableArray alloc] init];
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if(openDatabaseResult == SQLITE_OK) {

        sqlite3_stmt *compiledStatement;
        
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if (prepareStatementResult == SQLITE_OK) {
            
            if (!queryExecutable){
  
                NSMutableArray *dataRow;
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    dataRow = [[NSMutableArray alloc] init];
                    
                    NSInteger totalColumns = sqlite3_column_count(compiledStatement);
                    for (int i = 0; i < totalColumns; i++) {
                       
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        if (dbDataAsChars != NULL) {
                            [dataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        if (self.columnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.columnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    if (dataRow.count > 0) {
                        [self.results addObject:dataRow];
                    }
                }
            } else {
                
                NSInteger executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                } else {
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
            
        } else {
            NSLog(@"YOU FAILED HOMIE");
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(sqlite3Database);
}

- (void)queryDataFromDatabase:(NSString *)query completion:(CompletionBlock)completion {
    
    __block NSArray *results = nil;
    dispatch_queue_t queue = dispatch_queue_create("com.StormGolf.SerialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self runQuery:[query UTF8String] isQueryExecutable:NO];
        results = [HDHelper userObjectsFromArray:self.results withColumnNames:self.columnNames];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(results);
        });
    });
}

- (void)executeQuery:(NSString *)query {
    dispatch_queue_t queue = dispatch_queue_create("com.StormGolf.SerialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self runQuery:[query UTF8String] isQueryExecutable:YES];
    });
}

#pragma mark - Classy 

+ (NSString *)queryStringForTransactionsFromUserID:(NSUInteger)userID {
    return [NSString stringWithFormat:@"select * from trans where userID=%zd",userID];
}

+ (NSString *)queryStringForTransactionsFromUserID:(NSUInteger)userID
                                beforeTransitionID:(NSUInteger)transitionID {
    return [NSString stringWithFormat:@"select * from trans where userID=%zd AND transitionID<%zd",userID, transitionID];
}

+ (NSString *)queryStringFromUnixStartDate:(NSUInteger)startDate
                                finishDate:(NSUInteger)finishDate {
   return [NSString stringWithFormat:@"select * from trans where createdAt >= %zd AND createdAt <= %zd", startDate, finishDate];
}

+ (NSString *)executableStringWithFirstName:(NSString *)firstname
                                   lastname:(NSString *)lastname
                                      email:(NSString *)email {
    return [NSString stringWithFormat:@"insert into userInfo values(null, '%@', '%@', '%@')",firstname, lastname, email];
}

+ (NSString *)executableStringWithUserName:(NSString *)username
                                     price:(float)price
                               description:(NSString *)description
                                    userID:(NSInteger)userID {
    return [NSString stringWithFormat:@"insert into trans ('username', 'price', 'item', 'userID') values('%@', %f, '%@', %zd)", username, price, description, userID];
}

@end