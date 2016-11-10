//
//  WPGesture.m
//  Gesture
//
//  Created by GZCP1897 on 16/11/3.
//  Copyright © 2016年 GZCP1897. All rights reserved.
//

#import "WPGesture.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface WPGesture()
@property(nonatomic, assign)BOOL isCorrected;

@end

@implementation WPGesture

//在began里面识别手势是否正确： 几根手指 几次点击 哪一边  此方法左右：作为手势识别器
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    NSArray *allTouches = [touches allObjects];
    //0.判断手指的tapCount  是否在move里面给出移动初始点
    for (UITouch * tou in allTouches) {
        if(tou.tapCount != (self.wpNumberOfTapsRequired + 1)){
            //不符合的话直接return 不再继续判断
            return;
        }
    }

    //1.判断手指个数是否符合
    if(allTouches.count != self.wpNumberOfTouchesRequired){
        //忽略不正确手指 防止干扰到识别
        for (UITouch * tou in allTouches) {
            [self ignoreTouch:tou forEvent:event];
        }
        return;
    }
    
    //2.手指个数满足情况下 判断手指位置是否满足条件
    //用临时变量topM等接收 防止屏幕旋转出现
    CGFloat topM = self.view.bounds.size.height *0.25;//满足点要小于top
    CGFloat butM = self.view.bounds.size.height *0.75;//满足点要大于but
    CGFloat lefM = self.view.bounds.size.width *0.25;//满足点要小于lef
    CGFloat rigM = self.view.bounds.size.width *0.75;//满足点要大于rig
    if (topM >= 100) {
        topM = 100;
        butM = self.view.bounds.size.height - 100;
    }
    if (lefM >= 100) {
        lefM = 100;
        rigM = self.view.bounds.size.width - 100;
    }
    // 判断手指位置是否满足条件
    for (UITouch * tou in allTouches) {
        if (!self.view) {
            return;
        }//貌似能触发began就肯定有view
        CGPoint touchP = [tou locationInView:self.view];//手指位置
        
        if (self.wpEdges == UIRectEdgeNone) {
            return;//不知道UIRectEdgeNone是什么作用也就什么也不做了
        }
        if (self.wpEdges == UIRectEdgeTop) {
            if (touchP.y > topM) {
                [self ignoreTouch:tou forEvent:event];
                return;
            }
        }
        if (self.wpEdges == UIRectEdgeBottom) {
            if (touchP.y < butM) {
                [self ignoreTouch:tou forEvent:event];
                return;
            }
        }
        if (self.wpEdges == UIRectEdgeLeft) {
            if (touchP.x > lefM) {
                [self ignoreTouch:tou forEvent:event];
                return;
            }
        }
        if (self.wpEdges == UIRectEdgeRight) {
            if (touchP.x < rigM) {
                [self ignoreTouch:tou forEvent:event];
                return;
            }
        }
        if (self.wpEdges == UIRectEdgeAll) {
            if (touchP.y > topM && touchP.y < butM && touchP.x > lefM && touchP.x < rigM) {
                [self ignoreTouch:tou forEvent:event];
                return;
            }
        }
    }
    self.isCorrected = YES;//识别正确，当前状态UIGestureRecognizerStatePossible
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if (!self.isCorrected) {
        //不满足began的情况 直接返回
        return;
    }
    //识别正确 移动既是began
    self.state = UIGestureRecognizerStateBegan;//自动内部会自动改变状态为move 
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if(self.isCorrected){
        self.state = UIGestureRecognizerStateEnded;
        self.state = UIGestureRecognizerStateRecognized;
        [self reset];
    }
}

#pragma mark - 重写方法
- (void)reset{
    [super reset];
    self.isCorrected = NO;
}

//没有end状态 又识别到其他手势的时候  多了手指出来
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer{
    BOOL res = [super canPreventGestureRecognizer:preventedGestureRecognizer];
    self.state = UIGestureRecognizerStateCancelled;
    [self reset];
    return res;
}

//第一次识别 touchBegan之后调用
- (BOOL)shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL res = [super shouldRequireFailureOfGestureRecognizer:otherGestureRecognizer];
    return res;
}

#pragma mark - 默认值设置
//重写init 设置默认值
- (instancetype)init{
    if(self = [super init]){
        self.wpEdges = UIRectEdgeAll;
        self.wpNumberOfTapsRequired = 0;
        self.wpNumberOfTouchesRequired = 1;
        self.isCorrected = NO;
    }
    return self;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action{
    if (self = [super initWithTarget:target action:action]) {
        self.wpEdges = UIRectEdgeAll;
        self.wpNumberOfTapsRequired = 0;
        self.wpNumberOfTouchesRequired = 1;
        self.isCorrected = NO;
    }
    return self;
}
@end
