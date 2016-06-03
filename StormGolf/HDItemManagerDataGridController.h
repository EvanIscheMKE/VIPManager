//
//  HDItemManagerViewController.h
//  StormGolf
//
//  Created by Evan Ische on 4/27/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

#import "HDDataGridController.h"

static const CGFloat CHECK_BOX_SCREEN_PERCENTAGE = 50.0f;
static const CGFloat ITEM_TITLE_SCREEN_PERCENTAGE = 699.0f;
static const CGFloat ITEM_VALUE_SCREEN_PERCENTAGE = 273.0f;

@interface HDDataGridCheckBoxCell : UICollectionViewCell
@property (nonatomic, assign, getter=isCheckedForRemoval) BOOL checkedForRemoval;
@end

@interface HDItemManagerDataGridController : HDDataGridController <UIPopoverPresentationControllerDelegate>
@end
