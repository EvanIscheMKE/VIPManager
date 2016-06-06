//
//  HDCashierViewController.m
//  StormGolf
//
//  Created by Evan Ische on 5/28/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDCashierPopoverViewController.h"
#import "UIFont+FontAdditions.h"
#import "UIColor+ColorAdditions.h"

NSString * const HDCollectionViewReuseIdentifier = @"HDTableViewReuseIdentifier";

NSString * const HDCashierUserDefaultsKey = @"HDCashierUserDefaultsKey";

NSString * const HDCurrentKey = @"HDCurrentKey";
NSString * const HDImageKey = @"HDImageKey";
NSString * const HDNameKey = @"HDNameKey";
@implementation HDCashier

- (instancetype)initWithName:(NSString *)name image:(UIImage *)image {
    if (self = [super init]) {
        self.image = image;
        self.name = name;
        self.current = NO;
    }
    return self;
}

#pragma mark - Decoder

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.image = [aDecoder decodeObjectForKey:HDImageKey];
        self.name = [aDecoder decodeObjectForKey:HDNameKey];
        self.current = [aDecoder decodeBoolForKey:HDCurrentKey];
    }
    return self;
}

#pragma mark - Encoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.current forKey:HDCurrentKey];
    [aCoder encodeObject:self.image forKey:HDImageKey];
    [aCoder encodeObject:self.name  forKey:HDNameKey];
}

@end

@implementation HDCashierCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont stormGolfFontOfSize:16.0f];
        self.textLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.textLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 46.0f, 46.0f)];
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    self.textLabel.center = CGPointMake(CGRectGetMidX(self.contentView.bounds),
                                        CGRectGetHeight(self.contentView.bounds) - CGRectGetMidY(self.textLabel.bounds) - 5.0f);//Padding
    
    self.imageView.center = CGPointMake(self.textLabel.center.x, CGRectGetHeight(self.contentView.bounds) / 2.65f);
    
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

- (HDCashier *)currentCashier {
    for (HDCashier *cashier in self.cashiers) {
        if (cashier.current) {
            return cashier;
        }
    }
    return nil;
}

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

- (void)updateCurrentCashier:(HDCashier *)cashier {
    [self.cashiers makeObjectsPerformSelector:@selector(setCurrent:) withObject:0];
    cashier.current = YES;
    [self _save];
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
        
        HDCashier *cashier = [[HDCashier alloc] initWithName:@"Admin" image:[UIImage imageNamed:@"User"]];
        cashier.current = YES;
        
        [_cashiers addObject:cashier];
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
    NSUInteger _numberOfColumns;
    CGFloat _spacing;
}

- (instancetype)init {
    
     _spacing = 10.0f;
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    flow.sectionInset = UIEdgeInsetsMake(_spacing, _spacing, _spacing, _spacing);
    flow.minimumLineSpacing = _spacing;
    flow.minimumInteritemSpacing = _spacing;
    
    if (self = [super initWithCollectionViewLayout:flow]) {
        
        _numberOfColumns = 3;
        
        self.title = @"Cashier";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor flatDataGridCellColor];
    [self.collectionView registerClass:[HDCashierCollectionViewCell class] forCellWithReuseIdentifier:HDCollectionViewReuseIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(_presentCreateAccountMenu:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.view.superview.layer.cornerRadius = 0;
    self.navigationController.view.layer.cornerRadius = 0;
}

- (IBAction)_presentCreateAccountMenu:(id)sender {

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[HDCashierManager sharedManager] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger amountOfSpacers = _numberOfColumns + 1;
    CGFloat totalSpace = amountOfSpacers * _spacing;
    CGFloat itemWidth = (CGRectGetWidth(self.view.bounds) - totalSpace) / _numberOfColumns ;
    
    return CGSizeMake(itemWidth, itemWidth * 1.25f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDCashier *cashier = [[HDCashierManager sharedManager] cashierAtIndex:indexPath.item];
    HDCashierCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HDCollectionViewReuseIdentifier
                                                                                  forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = cashier.name;
    cell.imageView.image = cashier.image;
    return cell;
}


@end
