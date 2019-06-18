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

double gap = 20;

-(instancetype) initWithFrame:(CGRect)frame {
    
    float side = (frame.size.width - gap) / 2;
    frame.size.height = side;
    self = [super initWithFrame:frame];
    
    if(self)
    {
        //TEMP
        [self setBackgroundColor:[UIColor blueColor]];
    
        _leftButton = [RingButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:@"Left" forState:UIControlStateNormal];
        [_leftButton setFrame:CGRectMake(0, 0, side, side)];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize: 12];
        [self addSubview:_leftButton];

        _rightButton = [RingButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"Right" forState:UIControlStateNormal];
        [_rightButton setFrame:CGRectMake(frame.size.width/2 + gap/2, 0, side, side)];
        [self addSubview:_rightButton];
    }
    
    return self;
}

-(void) close {
    [UIView animateWithDuration:0.5 animations:^(void){
        [self->_leftButton setAlpha: 0.0f];
        [self->_rightButton setAlpha: 0.0f];
        
        CGPoint newCenterPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self->_leftButton setCenter: newCenterPoint];
        [self->_rightButton setCenter: newCenterPoint];
    }];
}

-(void) open {
    [UIView animateWithDuration:0.5 animations:^(void){
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
