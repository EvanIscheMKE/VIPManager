//
//  HDPopoverViewController.h
//  StormGolf
//
//  Created by Evan Ische on 4/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;


@protocol HDPopoverViewControllerDelegate;
@interface HDPopoverViewController : UIViewController
//@property (nonatomic, weak) FSCalendar *startCalendar;
//@property (nonatomic, weak) FSCalendar *finishCalendar;
@property (nonatomic, weak) id<HDPopoverViewControllerDelegate> delegate;
@end

@protocol HDPopoverViewControllerDelegate <NSObject>
@required
- (void)popover:(HDPopoverViewController *)popover updatedQueryStartDate:(NSDate *)start finishDate:(NSDate *)finish;
@end
