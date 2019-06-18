//
//  PairedRingButtons.h
//  PomodoroTimer
//
//  Created by Macbook on 18/06/2019.
//  Copyright © 2019 Sergey Vasilenko. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RingButton;

@interface PairedRingButtons : UIView
@property(nonatomic, readonly) RingButton *leftButton, *rightButton;
@property(nonatomic, assign) NSTimeInterval animationTime;

-(instancetype) initWithButtonSide: (float) theSide andGap: (float) theGap;
-(void) close;
-(void) open;
@end

NS_ASSUME_NONNULL_END
