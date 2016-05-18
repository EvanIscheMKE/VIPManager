//
//  HDUserPresentationController.m
//  StormGolf
//
//  Created by Evan Ische on 5/17/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDUserPresentationController.h"

@implementation HDUserTransitioningDelegate

- (HDUserPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                          presentingViewController:(UIViewController *)presenting
                                                              sourceViewController:(UIViewController *)source {
    HDUserPresentationController *presentationController = [[HDUserPresentationController alloc] initWithPresentedViewController:presented
                                                                                                        presentingViewController:presenting];
    return presentationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    HDBaseAnimatedTransitioning *animationController = [[HDBaseAnimatedTransitioning alloc] init];
    animationController.isPresentation = NO;
    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    HDBaseAnimatedTransitioning *animationController = [[HDBaseAnimatedTransitioning alloc] init];
    animationController.isPresentation = YES;
    return animationController;
}

@end

@implementation HDUserPresentationController

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeMake(500.0f, 560.0f);
}

@end
