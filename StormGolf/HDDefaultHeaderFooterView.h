//
//  HDDefaultHeaderFooterView.h
//  StormGolf
//
//  Created by Evan Ische on 5/25/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

static const CGFloat DEFAULT_HEADER_HEIGHT = 44.0f;
@interface HDDefaultHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic, copy) NSArray *values;
- (NSString *)labelForIndex:(NSUInteger)index;
@end
