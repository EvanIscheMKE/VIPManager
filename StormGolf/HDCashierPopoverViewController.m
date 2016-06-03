//
//  HDCashierViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDCashierPopoverViewController.h"
#import "UIFont+FontAdditions.h"

NSString * const HDTableViewReuseIdentifier = @"HDTableViewReuseIdentifier";

NSString * const HDCashierUserDefaultsKey = @"HDCashierUserDefaultsKey";
NSString * const HDImageKey = @"HDImageKey";
NSString * const HDNameKey = @"HDNameKey";


@implementation HDCashier

- (instancetype)initWithName:(NSString *)name image:(UIImage *)image {
    if (self = [super init]) {
        self.image = image;
        self.name = name;
    }
    return self;
}

#pragma mark - Decoder

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.image = [aDecoder decodeObjectForKey:HDImageKey];
        self.name = [aDecoder decodeObjectForKey:HDNameKey];
    }
    return self;
}

#pragma mark - Encoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.image forKey:HDImageKey];
    [aCoder encodeObject:self.name  forKey:HDNameKey];
}

@end

@interface HDCashierManager ()
@property (nonatomic, strong) NSMutableArray *cashiers;
@end

@implementation HDCashierManager

+ (HDCashierManager *)sharedManager {
    static HDCashierManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [HDCashierManager new];
    });
    return sharedManager;
}

#pragma mark - Public

- (void)addCashier:(HDCashier *)cashier {
    [self.cashiers addObject:cashier];
    [self _save];
}

- (void)removeCashier:(HDCashier *)cashier {
    [self.cashiers removeObjectIdenticalTo:cashier];
    [self _save];
}

- (HDCashier *)cashierAtIndex:(NSInteger)index {
    return self.cashiers[index];
}

- (void)saveChanges {
    [self _save];
}

- (NSMutableArray *)cashiers {
    
    if (_cashiers) {
        return _cashiers;
    }
    
    NSMutableArray *cashiers = [NSMutableArray new];
    NSMutableArray *itemsAsData = [[NSUserDefaults standardUserDefaults] objectForKey:HDCashierUserDefaultsKey];
    for (NSData *itemData in itemsAsData) {
        [cashiers addObject:[NSKeyedUnarchiver unarchiveObjectWithData:itemData]];
    }
    
    if (cashiers.count) {
        _cashiers = cashiers;
    } else {
        _cashiers = [NSMutableArray new];
        [_cashiers addObject:[[HDCashier alloc] initWithName:@"Admin"
                                                       image:[UIImage imageNamed:@""]]];
        [self _save:_cashiers];
    }
    return _cashiers;
}

- (void)removeCashierAtIndex:(NSInteger)index {
    [self.cashiers removeObjectAtIndex:index];
    [self _save];
}

- (NSUInteger)count {
    return self.cashiers.count;
}

#pragma mark - Private

- (void)_save {
    [self _save:nil];
}

- (void)_save:(NSMutableArray *)cashiers {
    NSMutableArray *saveTheseCashier = [NSMutableArray new];
    for (HDCashier *cashier in (cashiers == nil) ? self.cashiers : cashiers) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cashier];
        [saveTheseCashier addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:saveTheseCashier forKey:HDCashierUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end





@implementation HDCashierPopoverViewController {
    BOOL _isTableViewHeaderPresented;
}

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Cashier Manager";
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.clipsToBounds = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:HDTableViewReuseIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(_presentCreateAccountMenu:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /* */
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.clipsToBounds = NO;
    self.navigationController.view.superview.layer.cornerRadius = 0;
    self.navigationController.view.layer.cornerRadius = 0;
}

- (IBAction)_presentCreateAccountMenu:(id)sender {
    if (!self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 200.0f)];
    } else {
        self.tableView.tableHeaderView = nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[HDCashierManager sharedManager] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HDTableViewReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = @"Admin";
    cell.textLabel.font = [UIFont stormGolfLightFontOfSize:18.0f];
    //cell.imageView.image =
    cell.imageView.backgroundColor = [UIColor redColor];
    return cell;
}

@end
