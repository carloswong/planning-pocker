//
//  PlayingCard.m
//  Planning Pocker
//
//  Created by carlos on 14-4-13.
//  Copyright (c) 2014年 CarlosWong. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "PlayingCard.h"
#import "Storage.h"


@implementation PlayingCard
{
    CGPoint originPoint;
    CGPoint originCenter;
    BOOL onStage;
    
}

- (id)initWithFrame:(CGRect)frame andNumber:(NSString *)number
{
    if (self = [super initWithFrame:frame andNumber:number]) {
        originCenter = self.center;
        onStage = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.moveEnabled) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    if ([Storage shared].soundEnabled) {
       AudioServicesPlaySystemSound(1100);
    }
    
    UITouch *touch = [touches anyObject];
    originPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.moveEnabled) {
        [super touchesMoved:touches withEvent:event];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint newPoint = [touch locationInView:self];
    
    CGFloat offsetX = originPoint.x - newPoint.x;
    CGFloat offsetY = originPoint.y - newPoint.y;
    
    if (offsetY < 0) {
        return;
    }
    
    CGPoint center = self.center;
    center.x -= offsetX;
    center.y -= offsetY;
    self.center = center;
    
    if ((originCenter.y - center.y) > 50 || fabsf(originCenter.x - center.x) > 20) {
        if ([self.delegate respondsToSelector:@selector(showCard)]) {
            if ([self.delegate respondsToSelector:@selector(willPutCardOnStage:)]) {
                [self.delegate willPutCardOnStage:self];
            }
            
            [self.delegate showCard];
            self.moveEnabled = NO;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.moveEnabled) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
        CGPoint center = originCenter;
        CGFloat degress = atan2f(self.transform.b, self.transform.a);
        
        if (!onStage) {
            center.y -= 20;
            center.x += 20*degress;
            onStage = YES;
            if ([self.delegate respondsToSelector:@selector(willPutCardOnStage:)]) {
                [self.delegate willPutCardOnStage:self];
            }
        } else {
            onStage = NO;
            if ([self.delegate respondsToSelector:@selector(willPutCardOffStage:)]) {
                [self.delegate willPutCardOffStage:self];
            }
        }
      
        self.center = center;
        return;
    }
    
    self.center = originCenter;
}

- (void)reset
{
    [UIView animateWithDuration:0.2 animations:^{
        self.center = originCenter;
    }];
    self.moveEnabled = YES;
    onStage = NO;
    if ([self.delegate respondsToSelector:@selector(willPutCardOffStage:)]) {
        [self.delegate willPutCardOffStage:self];
    }
}
@end
