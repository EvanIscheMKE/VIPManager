//
//  HDSearchControllerViewController.h
//  StormGolf
//
//  Created by Evan Ische on 5/11/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@class HDSearchBar;
@import UIKit;
@interface HDSearchViewController : UISearchController
@property (nonatomic, strong) HDSearchBar *customSearchBar;
- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
                                 searchBarFrame:(CGRect)frame
                                      textColor:(UIColor *)textColor
                                      tintColor:(UIColor *)tintColor;
@end

