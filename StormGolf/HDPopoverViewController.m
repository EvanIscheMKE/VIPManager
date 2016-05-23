//
//  HDPopoverViewController.m
//  StormGolf
//
//  Created by Evan Ische on 4/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDPopoverViewController.h"
#import "UIColor+ColorAdditions.h"

@interface HDPopoverViewController ()
@end

@implementation HDPopoverViewController {
    NSDate *_startDate;
    NSDate *_finishDate;
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Select Dates";

        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        _startDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:NSDate.date options:0];
        _finishDate = NSDate.date;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    for (int i = 0; i < 2; i++) {
//        FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectZero];
//        calendar.tag = i;
//        calendar.dataSource = self;
//        calendar.delegate = self;
//        calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
//        calendar.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:calendar];
//        
//        switch (i) {
//            case 0:
//                self.startCalendar = calendar;
//                self.startCalendar.appearance.todaySelectionColor = [UIColor flatPeterRiverColor];
//                self.startCalendar.appearance.todayColor = [self.startCalendar.appearance.todaySelectionColor colorWithAlphaComponent:.6f];
//                self.startCalendar.appearance.headerTitleColor = self.startCalendar.appearance.todaySelectionColor;
//                self.startCalendar.appearance.weekdayTextColor = self.startCalendar.appearance.todaySelectionColor;
//                self.startCalendar.appearance.selectionColor = self.startCalendar.appearance.todaySelectionColor;
//                break;
//            default:
//                self.finishCalendar = calendar;
//                self.finishCalendar.appearance.headerTitleColor = [UIColor flatSTRedColor];
//                self.finishCalendar.appearance.todayColor = [self.finishCalendar.appearance.headerTitleColor colorWithAlphaComponent:.6f];
//                self.finishCalendar.appearance.weekdayTextColor = self.finishCalendar.appearance.headerTitleColor;
//                self.finishCalendar.appearance.todaySelectionColor = self.finishCalendar.appearance.headerTitleColor;
//                self.finishCalendar.appearance.selectionColor = self.finishCalendar.appearance.headerTitleColor;
//                break;
//        }
//    }
    
    self.view.layer.cornerRadius = 5.0f;
    self.view.layer.masksToBounds = true;
    self.view.backgroundColor = [UIColor colorWithRed:(240.0/255.0f) green:(240.0/255.0f) blue:(244.0/255.0f) alpha:1.0];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(_remove:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                           target:self
                                                                                           action:@selector(_remove:)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = [[UIBezierPath bezierPathWithRoundedRect:self.view.bounds
                                            byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                  cornerRadii:CGSizeMake(5.0f, 5.0f)] CGPath];
    self.navigationController.navigationBar.layer.mask = maskLayer;
}

- (IBAction)_remove:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    const CGRect startCalendarBounds = CGRectMake(0.0f,
                                                  0.0f,
                                                  CGRectGetMidX(self.view.bounds),
                                                  CGRectGetHeight(self.view.bounds));
    const CGRect finishCalendarBounds = CGRectMake(CGRectGetMaxX(startCalendarBounds),
                                                   0.0f,
                                                   CGRectGetMidX(self.view.bounds),
                                                   CGRectGetHeight(self.view.bounds));
    
    NSUInteger index = 0;
    for (UIView *subview in self.view.subviews) {
        subview.frame = index == 0 ? startCalendarBounds : finishCalendarBounds;
        index++;
    }
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0.0, 0.0, 1.0, CGRectGetHeight(self.view.bounds));
    layer.position = self.view.center;
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:layer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = [[UIBezierPath bezierPathWithRoundedRect:self.view.bounds
                                            byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                                  cornerRadii:CGSizeMake(5.0f, 5.0f)] CGPath];
    
    self.navigationController.navigationBar.layer.mask = maskLayer;
}

//#pragma mark - <FSCalendarDataSource>
//
//- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
//    return NSDate.date;
//}
//
//#pragma mark - <FSCalendarDelegate>
//
//- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
//    
//    if (calendar.tag == 0) {
//        if ([date compare:NSDate.date] == NSOrderedDescending) {
//            return;
//        }
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
//        _startDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
//    } else {
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
//        NSDate *morningOfSelectedDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:date options:0];
//        NSDate *morningOfTodaysDate = [calendar dateBySettingHour:0 minute:0 second:0 ofDate:NSDate.date options:0];
//        if ([morningOfSelectedDate compare:morningOfTodaysDate] == NSOrderedSame) {
//            _finishDate = NSDate.date;
//        } else {
//            _finishDate = date;
//        }
//    }
//    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(popover:updatedQueryStartDate:finishDate:)]) {
//        [self.delegate popover:self updatedQueryStartDate:_startDate finishDate:_finishDate];
//    }
//    
//    // get current date/time
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    NSString *startTime = [dateFormatter stringFromDate:_startDate];
//    NSString *finishTime = [dateFormatter stringFromDate:_finishDate];
//    NSLog(startTime);
//    NSLog(finishTime);
//}

@end
