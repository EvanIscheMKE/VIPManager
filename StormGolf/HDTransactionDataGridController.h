//
//  HDTransactionsViewController.h
//  StormGolf
//
//  Created by Evan Ische on 4/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;
@import QuartzCore;

#import "HDDataGridController.h"

/* Transactions */
static const CGFloat MEMBER_NAME_SCREEN_PERCENTAGE = 210.0f;
static const CGFloat STARTING_BALANCE_SCREEN_PERCENTAGE = 100.0f;
static const CGFloat ENDING_BALANCE_SCREEN_PERCENTAGE  = 100.0f;
static const CGFloat ITEM_COST_SCREEN_PERCENTAGE = 100.0f;
static const CGFloat ADMIN_NAME_SCREEN_PERCENTAGE = 100.0f;
static const CGFloat TRANSITION_DATE_SCREEN_PERCENTAGE = 230.0f;
static const CGFloat TRANSITION_DESCRIPTION_SCREEN_PERCENTAGE = 184.0f;

/* Sales */
static const CGFloat ITEM_NAME_SCREEN_PERCENTAGE = 206.00f;
static const CGFloat SALE_GRAPH_FULL_PERCENTAGE = 406.00f;
static const CGFloat SALE_NUMBER_SCREEN_PERCENTAGE  = 206.0f;
static const CGFloat TOTAL_AMOUNT_SCREEN_PERCENTAGE  = 206.f;


@interface HDTransactionDataGridController : HDDataGridController
@end
