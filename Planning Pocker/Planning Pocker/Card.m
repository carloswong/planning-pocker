//
//  Card.m
//  Planning Pocker
//
//  Created by carlos on 14-4-13.
//  Copyright (c) 2014年 CarlosWong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Card.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation Card
{
    BOOL drawPoint;
}

- (id)initWithFrame:(CGRect)frame
{
    return nil;
}

- (id)initWithFrame:(CGRect)frame andNumber:(NSString *)number {
    self = [super initWithFrame:frame];
    if (self) {
        self.number = number;
        self.moveEnabled = YES;
        drawPoint = NO;
        
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:7.5] CGPath];
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.25;
        self.layer.shadowRadius = 1;
        
        self.layer.cornerRadius = 7.0;
        self.opaque = NO;
    }
    return self;
}

- (void)reset{}

- (void)drawRect:(CGRect)rect
{
    UIImage *backgroundImage;
    NSString *imageName;
    NSUInteger cardNumber = [self.number integerValue];

    if (cardNumber == 0) {
        if ([self.number isEqualToString:@"j"] || [self.number isEqualToString:@"J"]) {
            imageName = @"card-j";
        } else if ([self.number isEqualToString:@"q"] || [self.number isEqualToString:@"Q"]) {
            imageName = @"card-q";
        } else if ([self.number isEqualToString:@"k"] || [self.number isEqualToString:@"K"]) {
            imageName = @"card-k";
        } else if ([self.number isEqualToString:@"?"]) {
            imageName = @"card-joker";
            drawPoint = YES;
        } else {
            imageName = @"blank-card";
            drawPoint = YES;
        }
    }else if(cardNumber > 0 && cardNumber <= 10) {
        imageName = [NSString stringWithFormat:@"card-%lu", (unsigned long)cardNumber];
    }else if(cardNumber >= 11 && cardNumber <= 13) {
        switch (cardNumber) {
            case 11:
                imageName = @"card-j";
                break;
            case 12:
                imageName = @"card-q";
                break;
            case 13:
                 imageName = @"card-k";
                break;
        }
    }else {
        imageName = @"blank-card";
        drawPoint = YES;
    }
    
    backgroundImage = [UIImage imageNamed:imageName];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    
    CGContextDrawImage(context, rect, [backgroundImage CGImage]);
    
    if (drawPoint) {
        CGContextSetTextDrawingMode(context, kCGTextFill);
        CGFloat fontHeight = rect.size.width * 0.22;
        CGFloat marginLeft = rect.size.width * 0.04;
        CGContextSelectFont(context, "Arial", fontHeight, kCGEncodingMacRoman);

        [UIColorFromRGB(0xE60012) set];
        
        CGContextSetTextPosition(context, marginLeft, rect.size.height - fontHeight);
        NSString *topLabel = [NSString stringWithFormat:@"%@",self.number ];
        CGContextShowText(context, [topLabel UTF8String], strlen([topLabel UTF8String]));
    
        CGAffineTransform xform = CGAffineTransformMake(-1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
        CGContextSetTextMatrix(context, xform);
        CGContextSetTextPosition(context, rect.size.width - marginLeft, fontHeight);
        CGContextShowText(context, [topLabel UTF8String], strlen([topLabel UTF8String]));
    }
}
@end
