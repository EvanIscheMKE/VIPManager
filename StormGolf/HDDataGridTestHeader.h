//
//  HDDataGridTestHeader.h
//  StormGolf
//
//  Created by Evan Ische on 5/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDDataGridTestHeader : UICollectionReusableView
- (void)layoutColumnWidths:(NSArray *)columnWidths
              columnTitles:(NSArray *)columnTitles;
@end
