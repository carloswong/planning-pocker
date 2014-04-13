//
//  DeskViewController.m
//  Planning Pocker
//
//  Created by carlos on 14-4-13.
//  Copyright (c) 2014年 CarlosWong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "DeskViewController.h"
#import "SettingsViewController.h"
#import "Storage.h"

@interface DeskViewController ()
@property (nonatomic,retain) NSMutableArray *cards;
@property (nonatomic,retain) PlayingCard *onStageCard;
@property (nonatomic,retain) UIButton *displayCardButton;
@property (nonatomic,retain) StaticCard *onDisplayCard;
@property (nonatomic) BOOL soundEnabled;
@property (nonatomic,retain) NSArray *cardSet;
@end

@implementation DeskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cards = [[NSMutableArray alloc] init];
        
        [self addObserver:self
               forKeyPath:@"onStageCard"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"onStageCard"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self putCardsOnDesk];
}

- (void)putCardsOnDesk
{
    self.cardSet = [Storage shared].cardSet;
    self.soundEnabled = [Storage shared].soundEnabled;
   
    if ([self.cards count]) {
        for (Card *card in self.cards) {
            [card removeFromSuperview];
        }
         [self.cards removeAllObjects];
    }
    self.onDisplayCard = nil;
    self.onStageCard = nil;

    for (NSString *point in self.cardSet) {
        PlayingCard *card = [[PlayingCard alloc] initWithFrame:CGRectMake(self.view.center.x - 60,
                                                                          self.view.center.y + 20, 120, 180)
                                                     andNumber:point];
        card.delegate = self;
        card.layer.anchorPoint = CGPointMake(0.5,1.0);
        
        [self.cards addObject:card];
        [self.view addSubview:card];
    }
    
    [self performSelector:@selector(shuffleCards)
               withObject:nil
               afterDelay:1];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(10, 10, 32, 32);
    settingsButton.alpha = 0.2;
    
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"configuration"] forState:UIControlStateNormal];
    [settingsButton addTarget:self
                       action:@selector(showSettingsView)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:settingsButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (UIButton *)displayCardButton
{
    if (!_displayCardButton) {
        _displayCardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _displayCardButton.frame = CGRectMake(0, 0, 142, 39.5);
        _displayCardButton.center = CGPointMake(self.view.center.x, self.view.center.y+200);
        _displayCardButton.hidden = YES;
        
        [_displayCardButton setBackgroundImage:[UIImage imageNamed:@"button"]
                                   forState:UIControlStateNormal];
        [_displayCardButton addTarget:self
                            action:@selector(tapdDisplayCardButton)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_displayCardButton];
    }
    return _displayCardButton;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"onStageCard"]) {
        id card = [change objectForKey:NSKeyValueChangeNewKey];
        if ([card isKindOfClass:[PlayingCard class]]) {
            self.displayCardButton.hidden = NO;
        }else {
            self.displayCardButton.hidden = YES;
        }
    }
}


- (void)shuffleCards
{
    CGFloat rotation = - (0.1 * [self.cardSet count]);
    for (PlayingCard *card in self.cards) {
        [UIView animateWithDuration:0.35
                         animations:^{
                            CGAffineTransform transform = card.transform;
                            transform = CGAffineTransformRotate(transform, rotation);
                            card.transform = transform;
                        }];

        rotation += 0.25;
    }
}

-(void)showCard
{
    if(self.onDisplayCard) return;
    
    self.displayCardButton.hidden = YES;
    StaticCard *card = [[StaticCard alloc] initWithFrame:self.onStageCard.frame
                                   andNumber:self.onStageCard.number];
     card.transform = self.onStageCard.transform;
    
    self.onDisplayCard = card;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                           action:@selector(dismissCard)];
    [card addGestureRecognizer:tapGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(dismissCard)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [card addGestureRecognizer:swipeGesture];
    
    [self.view addSubview:card];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGAffineTransform transform = CGAffineTransformIdentity;
         card.transform = transform;
        
         card.frame = CGRectMake((self.view.bounds.size.width - 320)/2,
                                (self.view.bounds.size.height - 480)/2,
                                320, 480);
    }];
}

- (void)dismissCard
{
    StaticCard *card = self.onDisplayCard;
    [UIView animateWithDuration:0.35
                     animations:^{
                         CGPoint center = self.view.center;
                         center.y += card.frame.size.height + card.frame.size.height;
                         card.center = center;
                     }
                     completion:^(BOOL finished){
                         [card removeFromSuperview];
                         [self.onStageCard reset];
                     }];
    self.onDisplayCard = nil;
}

- (void)willPutCardOnStage:(PlayingCard *)card
{
    
    if (self.onStageCard && self.onStageCard != card) {
        [self.onStageCard reset];
    }
    self.onStageCard = card;
}

- (void)willPutCardOffStage:(PlayingCard *)card
{
    self.onStageCard = nil;
}

- (void)tapdDisplayCardButton
{
    if(self.soundEnabled) {
         AudioServicesPlaySystemSound(1100);
    }
  
    [self showCard];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        if (self.onStageCard) {
            if(self.soundEnabled) {
                AudioServicesPlaySystemSound(1109);
            }
            
            if (self.onDisplayCard) {
                [self dismissCard];
            }else {
               [self showCard];
            }
        }
    }
}

- (void)showSettingsView
{
    SettingsViewController *settingsController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingsController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    UINavigationController *settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    
    [self presentViewController:settingsNavigationController animated:YES completion:nil];
    [self dismissCard];
}


@end
