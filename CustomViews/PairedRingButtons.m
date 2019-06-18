//
//  PairedRingButtons.m
//  PomodoroTimer
//
//  Created by Macbook on 18/06/2019.
//  Copyright © 2019 Sergey Vasilenko. All rights reserved.
//

#import "PairedRingButtons.h"
#import "RingButton.h"

@implementation PairedRingButtons

double gap = 35; //TODO: Maybe I should think about it

-(instancetype) initWithFrame:(CGRect)frame {
    float side = (frame.size.width - gap) / 2;
    frame.size.height = side;
    self = [super initWithFrame:frame];
    
    if(self)
    {
        self.animationTime = 0.3;
        _leftButton = [RingButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:@"Left" forState:UIControlStateNormal];
        [_leftButton setFrame:CGRectMake(0, 0, side, side)];
        [self addSubview:_leftButton];

        _rightButton = [RingButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"Right" forState:UIControlStateNormal];
        [_rightButton setFrame:CGRectMake(frame.size.width/2 + gap/2, 0, side, side)];
        [self addSubview:_rightButton];
    }
    
    return self;
}

-(instancetype) initWithButtonSide: (float) theSide andGap: (float) theGap {
    gap = theGap;
    CGRect frame = CGRectMake(0, 0, 2*theSide + theGap, theSide);
    self = [self initWithFrame:frame];
    
    return self;
}

-(void) close {
    [UIView animateWithDuration:_animationTime animations:^(void){
        [self->_leftButton setAlpha: 0.0f];
        [self->_rightButton setAlpha: 0.0f];
        
        CGPoint newCenterPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self->_leftButton setCenter: newCenterPoint];
        [self->_rightButton setCenter: newCenterPoint];
    }];
}

-(void) open {
    [UIView animateWithDuration:_animationTime animations:^(void){
        [self->_leftButton setAlpha: 1.0f];
        [self->_rightButton setAlpha: 1.0f];
        
        CGRect lFrame = self->_leftButton.frame;
        lFrame.origin.x = 0;
        [self->_leftButton setFrame:lFrame];
        
        CGRect rFrame = self->_rightButton.frame;
        rFrame.origin.x = self.frame.size.width/2 + gap/2;
        [self->_rightButton setFrame:rFrame];
    }];
}

@end
