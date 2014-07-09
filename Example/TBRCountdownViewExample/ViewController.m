//
//  ViewController.m
//  TBRCountdownViewExample
//
//  Created by Luciano Marisi on 08/07/2014.
//  Copyright (c) 2014 TechBrewers LTD. All rights reserved.
//

#import "ViewController.h"
#import "TBRCountdownView.h"

@interface ViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet TBRCountdownView *countdownView;
@property (weak, nonatomic) IBOutlet UITextField *progressTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateCountdownLabel];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(updateCountdownLabel)
                                                userInfo:nil
                                                 repeats:YES];
    self.countdownView.strokeWidth = 5.0;
}


- (IBAction)resetButtonPressed:(UIButton *)sender
{
    [self.countdownView reset];
}

- (IBAction)setProgressButtonPressed:(UIButton *)sender
{
    [self.countdownView stopAnimating];
    self.countdownView.progressFraction = [self.progressTextField.text floatValue];
}


- (void)updateCountdownLabel
{
    NSTimeInterval timeLeft = [self timeLeftInSecondsWithDate:[NSDate date]];
    self.countDownLabel.text = [NSString stringWithFormat:@"%.00f", self.countdownView.currentTime];
//    NSLog(@"timeLeft:%f", timeLeft);
}

- (NSTimeInterval)timeLeftInSecondsWithDate:(NSDate *)date
{
    NSString *fullDateString = [self.dateFormatter stringFromDate:date];
    
    NSArray *timeComponentsArray = [fullDateString componentsSeparatedByString:@":"];
    
    NSInteger currentSeconds = [timeComponentsArray[0] integerValue];
//    NSInteger miliSecondsLeft = [timeComponentsArray[1] integerValue];
    
    NSInteger timeForCircle = 10;
    NSInteger remainder = currentSeconds % timeForCircle;
    
    NSTimeInterval timeLeftInSeconds = timeForCircle - remainder;
    return timeLeftInSeconds;
}

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"ss:SSS";
    }
    return _dateFormatter;
}

@end
