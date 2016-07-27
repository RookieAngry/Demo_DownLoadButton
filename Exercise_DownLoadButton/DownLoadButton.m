//
//  DownLoadButton.m
//  Exercise_DownLoadButton
//
//  Created by 陈天宇 on 16/7/23.
//  Copyright © 2016年 Angry_Rookie. All rights reserved.
//

#import "DownLoadButton.h"

static CGFloat realProgressValue = 1.0;

@interface DownLoadButton ()

@property (nonatomic, assign) CGRect downLoadButtonOrginFrame;

@property (assign, nonatomic, getter=isAnimating) BOOL animating;

@end

@implementation DownLoadButton

#pragma mark - Initializer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addGestureForDownLoadButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addGestureForDownLoadButton];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addGestureForDownLoadButton];
    }
    return self;
}

#pragma mark - Add UITapGesture

- (void)addGestureForDownLoadButton {
    self.downLoadButtonOrginFrame = self.frame;
    self.progressWidth = 200.0f;
    self.progressHeight = 40.0f;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downLoadButtonTapped)];
    [self addGestureRecognizer:tapGesture];
}

- (void)downLoadButtonTapped {
    
    if (self.animating == YES) {
        return;
    }
    for (CALayer *subLayer in self.layer.sublayers) {
        [subLayer removeFromSuperlayer];
    }
    [self.layer removeAllAnimations];
    self.animating = YES;
    self.backgroundColor = [UIColor blueColor];
    self.layer.cornerRadius = self.progressHeight * 0.5;
    
    CABasicAnimation *circleToRectAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    circleToRectAnimation.duration = 0.2f;
    circleToRectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    circleToRectAnimation.fromValue = @(self.progressHeight * 0.5);
    circleToRectAnimation.delegate = self;
    [self.layer addAnimation:circleToRectAnimation forKey:@"circleToRectAnimation"];
    
}

- (void)animationDidStart:(CAAnimation *)anim {
    if ([anim isEqual:[self.layer animationForKey:@"circleToRectAnimation"]]) {
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, self.progressWidth, self.progressHeight);
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self progressWhiteLine];
        }];
    } else if ([anim isEqual:[self.layer animationForKey:@"rectToCircleAnimation"]]) {
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, self.downLoadButtonOrginFrame.size.width, self.downLoadButtonOrginFrame.size.height);
            self.backgroundColor = [UIColor greenColor];
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self checkAnimation];
            self.animating = NO;
        }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"animationName"] isEqualToString:@"whiteLineLayerAnimation"]) {
        [UIView animateWithDuration:0.3f animations:^{
            for (CALayer *subLayer in self.layer.sublayers) {
                subLayer.opaque = 0.0f;
            }
        } completion:^(BOOL finished) {
            for (CALayer *subLayer in self.layer.sublayers) {
                [subLayer removeFromSuperlayer];
            }
            
            self.layer.cornerRadius = self.downLoadButtonOrginFrame.size.height * 0.5;
            
            CABasicAnimation *rectToCircleAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            rectToCircleAnimation.duration = 0.2f;
            rectToCircleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            rectToCircleAnimation.fromValue = @(self.progressHeight * 0.5);
            rectToCircleAnimation.delegate = self;
            [self.layer addAnimation:rectToCircleAnimation forKey:@"rectToCircleAnimation"];
        }];
    }
}

- (void)progressWhiteLine {
    UIBezierPath *whiteLinePath = [UIBezierPath bezierPath];
    [whiteLinePath moveToPoint:CGPointMake(self.progressHeight * 0.5, self.progressHeight * 0.5)];
    [whiteLinePath addLineToPoint:CGPointMake((self.frame.size.width - self.progressHeight * 0.5) * realProgressValue, self.progressHeight * 0.5)];
    
    CAShapeLayer *whiteLineLayer = [CAShapeLayer layer];
    whiteLineLayer.path = whiteLinePath.CGPath;
    whiteLineLayer.lineWidth = self.progressHeight - 6.0f;
    whiteLineLayer.strokeColor = [UIColor whiteColor].CGColor;
    whiteLineLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:whiteLineLayer];
    
    CABasicAnimation *whiteLineLayerAnimation= [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    whiteLineLayerAnimation.fromValue = @(0.0f);
    whiteLineLayerAnimation.toValue = @(1.0f);
    whiteLineLayerAnimation.duration = 2.0f;
    [whiteLineLayerAnimation setValue:@"whiteLineLayerAnimation" forKey:@"animationName"];
    whiteLineLayerAnimation.delegate = self;
    [whiteLineLayer addAnimation:whiteLineLayerAnimation forKey:nil];
}

- (void)checkAnimation {
    
    UIBezierPath *checkPath = [UIBezierPath bezierPath];
    [checkPath moveToPoint:CGPointMake(self.frame.size.width * 1 / 6, self.frame.size.height * 0.5)];
    [checkPath addLineToPoint:CGPointMake(self.frame.size.width * 1 / 3, self.frame.size.height * 2 / 3)];
    [checkPath addLineToPoint:CGPointMake(self.frame.size.width * 2 / 3, self.frame.size.height * 1 / 3)];
    
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    checkLayer.path = checkPath.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = [UIColor whiteColor].CGColor;
    checkLayer.lineWidth = 10.0f;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:checkLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.2f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    
    [checkLayer addAnimation:checkAnimation forKey:@"checkAnimation"];
}

@end
