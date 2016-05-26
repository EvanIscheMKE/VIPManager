//
//  HDTableViewHeaderBackgroundView.h
//  StormGolf
//
//  Created by Evan Ische on 5/24/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

@interface HDTableViewHeaderBackgroundView : UIView
@property (nonatomic, copy) NSArray *values;
- (instancetype)initWithFrame:(CGRect)frame values:(NSArray *)values;
@end
