//
//  TBRCountdownView.m
//  TBRCountdownView
//
//  Created by Luciano Marisi on 08/07/2014.
//  Copyright (c) 2014 TechBrewers LTD. All rights reserved.
//

#import "TBRCountdownView.h"

@interface TBRCountdownView ()

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat endAngle;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSTimeInterval currentTime;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *previousDate;

@end

@implementation TBRCountdownView

#pragma mark - Initialization methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib
{
    [self commonInit];
}

- (void)commonInit
{
    // Default values
    self.backgroundColor = [UIColor clearColor];
    self.startAngle = M_PI * 1.5;
    self.endAngle = self.startAngle + (M_PI * 2);
    self.countdownTime = 5;
    self.strokeWidth = 49.9;
    self.previousDate = [NSDate date];

    self.currentTime = [self timeLeftInSecondsWithDate:[NSDate date]];

    [self startAnimating];
}


#pragma mark - Public methods

- (void)startAnimating
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 60.0
                                                  target:self
                                                selector:@selector(updateProgressView)
                                                userInfo:nil
                                                 repeats:YES];
}


- (void)stopAnimating
{
    [self.timer invalidate];
}

- (void)reset
{
    self.currentTime = self.countdownTime;
}


- (void)setProgressFraction:(CGFloat)progressFraction
{
    _progressFraction = progressFraction;
    [self setNeedsDisplay];
}

#pragma mark - Private methods

- (void)updateProgressView
{
    NSTimeInterval timeInterval = -[self.previousDate timeIntervalSinceNow];
    self.currentTime -= timeInterval;
    
    if (self.currentTime < 0) {
        self.currentTime = self.currentTime + self.countdownTime;
    }
    
    CGFloat progressFraction = 1 - self.currentTime / self.countdownTime;
    
    self.progressFraction = progressFraction;
    [self setNeedsDisplay];
    
    self.previousDate = [NSDate date];
}

- (NSTimeInterval)timeLeftInSecondsWithDate:(NSDate *)date
{
    NSString *fullDateString = [self.dateFormatter stringFromDate:date];
    
    NSArray *timeComponentsArray = [fullDateString componentsSeparatedByString:@":"];
    
    NSInteger currentSeconds = [timeComponentsArray[0] integerValue];
    NSInteger miliSecondsLeft = [timeComponentsArray[1] integerValue];
    
    NSInteger timeForCircle = self.countdownTime;
    NSInteger remainder = currentSeconds % timeForCircle;
    
    NSTimeInterval timeLeftInSeconds = timeForCircle - remainder - miliSecondsLeft / 1000.0;
    return timeLeftInSeconds;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGFloat minimumLength = MIN(rect.size.width, rect.size.height);
    
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:(minimumLength - self.strokeWidth) * 0.5
                      startAngle:self.startAngle
                        endAngle:(self.endAngle - self.startAngle) * self.progressFraction + self.startAngle
                       clockwise:NO];
    
    if (self.progressFraction == 0 || self.progressFraction == 1) {
        bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect,
                                                                        self.strokeWidth * 0.5,
                                                                        self.strokeWidth * 0.5)];
    }
    
    bezierPath.lineWidth = self.strokeWidth;
    [[UIColor whiteColor] setStroke];
    [bezierPath stroke];
    
    
}

#pragma mark - Lazy allocate formatters

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"ss:SSS";
    }
    return _dateFormatter;
}

@end