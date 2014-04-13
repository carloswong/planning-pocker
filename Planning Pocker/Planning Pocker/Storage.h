//
//  Storage.h
//  Planning Pocker
//
//  Created by carlos on 14-4-13.
//  Copyright (c) 2014年 CarlosWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Storage : NSObject

@property (nonatomic, readonly) BOOL soundEnabled;
@property (nonatomic, readonly) NSArray *cardSet;


+ (Storage*)shared;
- (void)setSoundEnabled:(BOOL)soundEnabled;
- (void)saveCardSet:(NSMutableArray *)set;

@end
