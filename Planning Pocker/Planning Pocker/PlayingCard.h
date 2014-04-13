//
//  PlayingCard.h
//  Planning Pocker
//
//  Created by carlos on 14-4-13.
//  Copyright (c) 2014年 CarlosWong. All rights reserved.
//

#import "Card.h"
@protocol PlayingCardDelegate <NSObject>
- (void)willPutCardOnStage:(Card *)card;
- (void)willPutCardOffStage:(Card *)card;
- (void)showCard;
@end

@interface PlayingCard : Card
@property (nonatomic, retain) id<PlayingCardDelegate> delegate;

@end
