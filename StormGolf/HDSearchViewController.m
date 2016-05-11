//
//  HDSearchControllerViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/11/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDSearchBar.h"
#import "HDSearchViewController.h"

@interface HDSearchViewController ()<UISearchBarDelegate>
@end

@implementation HDSearchViewController

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
                                 searchBarFrame:(CGRect)frame
                                      textColor:(UIColor *)textColor
                                      tintColor:(UIColor *)tintColor {
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        self.customSearchBar = [[HDSearchBar alloc] initWithFrame:frame textColor:textColor];
        self.customSearchBar.tintColor = textColor;
        self.customSearchBar.barTintColor = tintColor;
        self.customSearchBar.showsCancelButton = YES;
    }
    return self;
}

- (HDSearchBar *)searchBar {
    return self.customSearchBar;
}

@end
