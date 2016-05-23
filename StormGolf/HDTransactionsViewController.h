//
//  HDTransactionsViewController.h
//  StormGolf
//
//  Created by Evan Ische on 4/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;
@import QuartzCore;

typedef NS_ENUM(NSInteger,HDCalendarType) {
    HDCalendarTypeStarting = 0,
    HDCalendarTypeEnding = 1
};

@protocol HDCalendarViewDelegate;
@interface HDCalendarContainerView : UIView
@property (nonatomic, weak) id<HDCalendarViewDelegate> delegate;
- (void)updateStartingDate:(NSDate *)startingDate;
- (void)updateEndingDate:(NSDate *)endingDate;
@end
@protocol HDCalendarViewDelegate <NSObject>
@optional
- (void)presentCalendarOfType:(HDCalendarType)type;
@end

@interface HDTransactionsViewController : UITableViewController
@end
