//
//  HDBasePresentationController.m
//  StormGolf
//
//  Created by Evan Ische on 4/26/16.
//  Copyright © 2016 Evan William Ische. All rights reserved.
//

#import "HDBasePresentationController.h"

@implementation HDBaseTransitioningDelegate

- (HDBasePresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                          presentingViewController:(UIViewController *)presenting
                                                              sourceViewController:(UIViewController *)source {
    HDBasePresentationController *presentationController = [[HDBasePresentationController alloc] initWithPresentedViewController:presented
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

@implementation HDBaseAnimatedTransitioning

- (instancetype)init {
    if (self = [super init]) {
        self.isPresentation = NO;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    UIView *containerView = [transitionContext containerView];
    if (_isPresentation) {
        [containerView addSubview:toView];
    }
    
    UIViewController *animatingViewController = _isPresentation ? toViewController : fromViewController;
    UIView *animatingView = animatingViewController.view;
    
    const CGRect finalFrameForViewController = [transitionContext finalFrameForViewController:animatingViewController];
    CGRect initialRectForViewController = finalFrameForViewController;
    initialRectForViewController.origin.x += CGRectGetWidth(initialRectForViewController);
    
    const CGRect initialFrame = _isPresentation ? initialRectForViewController : finalFrameForViewController;
    const CGRect finalFrame = _isPresentation ? finalFrameForViewController : initialRectForViewController;
    
    animatingView.frame = initialFrame;
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0f
         usingSpringWithDamping:300.0f
          initialSpringVelocity:5.0f
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         animatingView.frame = finalFrame;
                     } completion:^(BOOL finished) {
                         if (!_isPresentation) {
                             [fromView removeFromSuperview];
                         }
                         [transitionContext completeTransition:YES];
                     }];
    
}

@end

@implementation HDBasePresentationController {
    UIVisualEffectView *_blurryView;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
    if (self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController]) {
        
        UIBlurEffect *lightBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurryView = [[UIVisualEffectView alloc] initWithEffect:lightBlur];
        _blurryView.hidden = YES;
        [_blurryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_chromeViewTapped:)]];
        
    }
    return self;
}

- (IBAction)_chromeViewTapped:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGRect presentedViewFrame = CGRectZero;
    CGRect containerBounds = self.containerView.bounds;
    presentedViewFrame.size = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerBounds.size];
    presentedViewFrame.origin.x = CGRectGetMidX(containerBounds) - CGRectGetMidX(presentedViewFrame);
    presentedViewFrame.origin.y = CGRectGetMidY(containerBounds) - CGRectGetMidY(presentedViewFrame);
    return  presentedViewFrame;
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeMake(720.0f, 440.0f);
}

- (void)presentationTransitionWillBegin {
    _blurryView.hidden = NO;
    _blurryView.frame = self.containerView.bounds;
    [self.containerView insertSubview:_blurryView atIndex:0];
}

- (void)dismissalTransitionWillBegin {
    _blurryView.hidden = YES;
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
        [_blurryView removeFromSuperview];
    }
}

- (void)containerViewWillLayoutSubviews {
    _blurryView.frame = self.containerView.bounds;
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
}

- (BOOL)shouldPresentInFullscreen {
    return YES;
}

- (UIModalPresentationStyle)adaptivePresentationStyle {
    return UIModalPresentationFullScreen;
}

@end
