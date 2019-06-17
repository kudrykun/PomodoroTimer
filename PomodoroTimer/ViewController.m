//
//  ViewController.m
//  PomodoroTimer
//
//  Created by Macbook on 17/06/2019.
//  Copyright © 2019 Sergey Vasilenko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
- (IBAction)toggleTimerAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *toggleTimerButton;

-(void) startTimer;
-(void) updateTimerLabel;
-(void) stopTimer;
-(void) updateTimerWithSeconds: (int) s;

@end


@implementation ViewController

BOOL timerStarted = NO;
NSTimer *timer;
int seconds;
double timeMod = 1.0;
int pomodoroMinutes = 25;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)toggleTimerAction:(UIButton *)sender {
    
    if(timerStarted)
        [self stopTimer];
    else
        [self startTimer];
}

-(void) startTimer {
    timerStarted = YES;
    [_toggleTimerButton setTitle:@"Стоп" forState:UIControlStateNormal];
    seconds = pomodoroMinutes * 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / timeMod target:self selector:@selector(updateTimerLabel) userInfo:nil repeats:YES];
}

-(void) stopTimer {
    timerStarted = NO;
    [timer invalidate];
    timer = nil;
    [_toggleTimerButton setTitle:@"Начать" forState:UIControlStateNormal];
    
    seconds = pomodoroMinutes * 60;
    [self updateTimerWithSeconds: seconds];
}

-(void) updateTimerLabel
{
    if(seconds <= 0 )
    {
        [self stopTimer];
        return;
    }
    seconds -= 1;
    [self updateTimerWithSeconds: seconds];
}

-(void) updateTimerWithSeconds: (int) s {
    NSString *minutesStr = [NSString stringWithFormat:@"%02i", s / 60];
    NSString *secondsStr = [NSString stringWithFormat:@"%02i", s % 60];
    NSString *timerString = [minutesStr stringByAppendingString: [@":" stringByAppendingString:secondsStr]];
    [_timerLabel setText:timerString];
}

@end
