//
//  HDUserViewController.m
//  StormGolf
//
//  Created by Evan Ische on 6/3/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDUserViewController.h"
#import "HDDBManager.h"
#import "HDUserObject.h"

@implementation HDUserViewController {
    CGFloat _startingBalance;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.user) {
        [[HDDBManager sharedManager] currentUserBalanceWithUserID:self.user.userID
                                                          results:^(float startingBalance) {
                                                              _startingBalance = startingBalance;
                                                          }];
    }
    
}

@end
