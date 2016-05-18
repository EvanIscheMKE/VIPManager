//
//  HDUserTableViewController.h
//  StormGolf
//
//  Created by Evan Ische on 5/17/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

@class HDUserObject;
@interface HDUserTableViewController : UITableViewController
@property (nonatomic, strong) HDUserObject *selectedUser;
@end
