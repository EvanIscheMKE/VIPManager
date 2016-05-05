//
//  HDBasePresentationController.h
//  StormGolf
//
//  Created by Evan Ische on 4/26/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

@import UIKit;

@interface HDBaseTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>
@end

@interface HDBaseAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL isPresentation;
@end

@interface HDBasePresentationController : UIPresentationController <UIAdaptivePresentationControllerDelegate>
@end
