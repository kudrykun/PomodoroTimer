//
//  RingButton.m
//  PomodoroTimer
//
//  Created by Macbook on 17/06/2019.
//  Copyright © 2019 Sergey Vasilenko. All rights reserved.
//

#import "RingButton.h"

@implementation RingButton
{
    CAShapeLayer *circleLayer;
}

- (void)drawRect:(CGRect)rect {
    [circleLayer removeFromSuperlayer];
    circleLayer = nil;
    circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:rect] CGPath]];
    
    CGRect cFrame = circleLayer.frame;
    cFrame.size = CGSizeMake(rect.size.width, rect.size.height);
    cFrame.origin = CGPointMake(0.0, 0.0);
    circleLayer.frame = cFrame;
    
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    [circleLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
    [circleLayer setZPosition: -1.0];
    [circleLayer setLineWidth: 1.0];

    [[self layer] addSublayer:circleLayer];
}

@end
