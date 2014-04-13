//
//  Storage.m
//  Planning Pocker
//
//  Created by carlos on 14-4-13.
//  Copyright (c) 2014年 CarlosWong. All rights reserved.
//

#import "Storage.h"

@implementation Storage
{
    NSUserDefaults *userDefaults;
}

@synthesize cardSet = _cardSet;

Storage *sharedStorage;

+ (Storage *)shared
{
    if(sharedStorage == nil) {
        sharedStorage = [[Storage alloc] init];
    }
    return sharedStorage;
}

- (id)init
{
    self = [super init];
    if(self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
        _soundEnabled = [userDefaults boolForKey:@"_soundEnabled"];
        if (!_soundEnabled) {
            _soundEnabled = NO;
        }
     }
    return self;
}

- (NSArray *)cardSet
{
    if (!_cardSet) {
        if([userDefaults objectForKey:@"_cardSet"]) {
            _cardSet = [userDefaults objectForKey:@"_cardSet"];
        }else {
            _cardSet = @[@"1",@"2",@"3",@"5",@"8",@"k"];
        }
    }
    return _cardSet;
}

- (void)saveCardSet:(NSMutableArray *)set
{
    _cardSet = set;
    [userDefaults setObject:_cardSet forKey:@"_cardSet"];
}

- (void)setSoundEnabled:(BOOL)soundEnabled
{
    _soundEnabled = soundEnabled;
    [userDefaults setBool:_soundEnabled forKey:@"_soundEnabled"];
}

@end
