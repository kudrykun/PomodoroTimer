//
//  ViewController.m
//  PomodoroTimer
//
//  Created by Macbook on 17/06/2019.
//  Copyright © 2019 Sergey Vasilenko. All rights reserved.
//

#import "ViewController.h"
#import "RingButton.h"
#import "PairedRingButtons.h"

enum PomodoroState {WORK, BREAK, LONG_BREAK};

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
-(void) startTimer;
-(void) updateTimer;
-(void) stopTimer;
-(void) setTimerWithSeconds: (int) s;
-(void) pauseTimer;
-(void) proceedTimer;

@end

@interface ViewController ()
-(RingButton*) createRingButtonWithString: (NSString*) str andTouchSelector: (SEL) selector;
-(void) initProceedAndStopButtons;
-(void) initStartButton;
-(void) initPauseButton;
-(void) initInterruptButton;
-(void) setViewByState;

-(void) startButtonTouch;
-(void) pauseButtonTouch;
-(void) proceedButtonTouch;
-(void) stopButtonTouch;
-(void) interruptButtonTouch;

-(int) secondsForMode: (enum PomodoroState) mode;
-(NSString*) statusStringForMode: (enum PomodoroState) mode;
-(UIColor*) backgroundColorForMode: (enum PomodoroState) mode;
@end


@implementation ViewController
{
    RingButton *startButton, *pauseButton, *interruptButton;
    PairedRingButtons *proceedAndStopButtons;
}


NSTimer *timer;
int seconds;
double timeMod = 200.0;
int pomodoroMinutes = 25;
int breakMinutes = 5;
int longBreakMinutes = 15;
enum PomodoroState mode = WORK;
int pomodoros = 3;
int pomodorosForLongBreak = 4;

NSString *buttonStrStart = @"Начать";
NSString *buttonStrStop = @"Стоп";
NSString *buttonStrPause = @"Пауза";
NSString *buttonStrProceed = @"Продолжить";
NSString *buttonStrInterrupt = @"Прервать";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initProceedAndStopButtons];
    [self initStartButton];
    [self initPauseButton];
    [self initInterruptButton];
    
    mode = WORK;
    [proceedAndStopButtons setAlpha:0];
    [proceedAndStopButtons close];
    [startButton setAlpha:1];
    [pauseButton setAlpha:0];
    [interruptButton setAlpha:0];
    
    [self setViewByState];
    [self setTimerWithSeconds: seconds];
}

-(void) initProceedAndStopButtons {
    proceedAndStopButtons = [[PairedRingButtons alloc] initWithButtonSide: 80 andGap:35];
    [self.view addSubview:proceedAndStopButtons];
    proceedAndStopButtons.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height - 50));

    [proceedAndStopButtons.leftButton addTarget:self action:@selector(proceedButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [proceedAndStopButtons.rightButton addTarget:self action:@selector(stopButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [proceedAndStopButtons.leftButton setTitle:[NSString stringWithString:buttonStrProceed] forState:UIControlStateNormal];
    [proceedAndStopButtons.rightButton setTitle:[NSString stringWithString:buttonStrStop] forState:UIControlStateNormal];
    proceedAndStopButtons.leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    proceedAndStopButtons.rightButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [proceedAndStopButtons setAlpha:0];
    [proceedAndStopButtons close];
}

-(RingButton*) createRingButtonWithString: (NSString*) str andTouchSelector: (SEL) selector
{
    RingButton *btn = [RingButton buttonWithType: UIButtonTypeCustom];
    [btn setTitle: [NSString stringWithString:str] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 80, 80)];
    [btn setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 50)];
    [btn setAlpha:0];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void) initStartButton {
    startButton = [self createRingButtonWithString:buttonStrStart andTouchSelector:@selector(startButtonTouch)];
    [self.view addSubview:startButton];
}

-(void) initPauseButton {
    pauseButton = [self createRingButtonWithString:buttonStrPause andTouchSelector:@selector(pauseButtonTouch)];
    [self.view addSubview:pauseButton];
}

-(void) initInterruptButton {
    interruptButton = [self createRingButtonWithString:buttonStrInterrupt andTouchSelector:@selector(interruptButtonTouch)];
    interruptButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:interruptButton];
}

-(void) setViewByState {
    seconds = [self secondsForMode:mode];
    [_statusLabel setText:[self statusStringForMode:mode]];
    [self.view setBackgroundColor: [self backgroundColorForMode:mode]];
}

-(int) secondsForMode: (enum PomodoroState) mode {
    int r = 0;
    switch (mode) {
        case WORK:
            r = pomodoroMinutes * 60;
            break;
            
        case BREAK:
            r =  breakMinutes * 60;
            break;
            
        case LONG_BREAK:
            r = longBreakMinutes * 60;
            break;
    }
    return r;
}

-(NSString*) statusStringForMode: (enum PomodoroState) mode {
    NSString *r;
    switch (mode) {
        case WORK:
            r = @"Концентрация!";
            break;
            
        case BREAK:
            r = @"Перерыв!";
            break;
            
        case LONG_BREAK:
            r = @"Длинный перерыв!";
            break;
    }
    return r;
}

-(UIColor*) backgroundColorForMode: (enum PomodoroState) mode {
    UIColor *r;
    switch (mode) {
        case WORK:
            r = [UIColor colorWithRed: 254.0 / 255.0 green: 61.0 / 255.0 blue: 62.0 / 255.0 alpha:1];
            break;
            
        case BREAK:
        case LONG_BREAK:
            r = [UIColor colorWithRed: 22.0 / 255.0 green: 162.0 / 255.0 blue: 184.0 / 255.0 alpha:1];
            break;
    }
    return r;
}


-(void) setTimerWithSeconds: (int) s {
    NSString *minutesStr = [NSString stringWithFormat:@"%02i", s / 60];
    NSString *secondsStr = [NSString stringWithFormat:@"%02i", s % 60];
    NSString *timerString = [minutesStr stringByAppendingString: [@":" stringByAppendingString:secondsStr]];
    [_timerLabel setText:timerString];
}

-(void) startButtonTouch
{
    [startButton setAlpha:0];
    if(mode == WORK)
        [pauseButton setAlpha:1];
    else
        [interruptButton setAlpha:1];
    [self startTimer];
}

-(void) pauseButtonTouch
{
    [UIView animateWithDuration:0.3 animations:^(void){
        [self->pauseButton setAlpha: 0.0f];
    }];
    [proceedAndStopButtons setAlpha:1];
    [proceedAndStopButtons open];
    [self pauseTimer];
}

-(void) proceedButtonTouch {
    [UIView animateWithDuration:0.3 animations:^(void){
        [self->pauseButton setAlpha: 1.0f];
    }];
    [proceedAndStopButtons close];
    [self proceedTimer];
}

-(void) stopButtonTouch {
    [self stopTimer];
}

-(void) interruptButtonTouch {
    pomodoros++;
    mode = WORK;
    [self stopTimer];
}

-(void) startTimer {
    [self setViewByState];
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 / timeMod target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void) stopTimer {
        [timer invalidate];
        timer = nil;
        
        [proceedAndStopButtons setAlpha:0];
        [proceedAndStopButtons close];
        [startButton setAlpha:1];
        [pauseButton setAlpha:0];
        [interruptButton setAlpha:0];
        
        [self setViewByState];
        [self setTimerWithSeconds: seconds];
}


-(void) pauseTimer {
        [timer invalidate];
        timer = nil;
}

-(void) proceedTimer {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / timeMod target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

-(void) updateTimer
{
    if(seconds <= 0 )
    {
        if(mode == WORK) {
            pomodoros++;
            if(pomodoros % 4 == 0)
                mode = LONG_BREAK;
            else
                mode = BREAK;
        }
        else
            mode = WORK;
        [self stopTimer];
        return;
    }
    
    seconds--;
    [self setTimerWithSeconds: seconds];
}

@end
