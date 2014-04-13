//
//  Card.h
//  Planning Pocker
//
//  Created by carlos on 14-4-13.
//  Copyright (c) 2014年 CarlosWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card : UIView
@property (nonatomic) NSString *number;
@property (nonatomic) BOOL moveEnabled;

- (id)initWithFrame:(CGRect)frame andNumber:(NSString *)number;
- (void)reset;
@end
