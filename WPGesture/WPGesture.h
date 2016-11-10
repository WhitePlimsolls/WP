//
//  WPGesture.h
//  Gesture
//
//  Created by GZCP1897 on 16/11/3.
//  Copyright © 2016年 GZCP1897. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPGesture : UIGestureRecognizer
//需要几根手指
@property(nonatomic, assign)NSUInteger wpNumberOfTouchesRequired;//默认1
//需要几次点击
@property(nonatomic, assign)NSUInteger wpNumberOfTapsRequired;//默认0
//哪一边
@property (readwrite, nonatomic, assign) UIRectEdge wpEdges;//默认UIRectEdgeAll

@end
