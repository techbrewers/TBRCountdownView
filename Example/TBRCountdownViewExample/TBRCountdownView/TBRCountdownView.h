//
//  TBRCountdownView.h
//  TBRCountdownView
//
//  Created by Luciano Marisi on 08/07/2014.
//  Copyright (c) 2014 TechBrewers LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBRCountdownView : UIView

@property (nonatomic) CGFloat strokeWidth;

/**
 *  Countdown time in seconds
 */
@property (nonatomic) NSTimeInterval countdownTime;

/**
 *  Set the progress fraction
 */
@property (nonatomic) CGFloat progressFraction;

@property (nonatomic, readonly) NSTimeInterval currentTime;


/**
 *  Start the countdown view
 */
- (void)startAnimating;

/**
 *  Stops the countdown view
 */
- (void)stopAnimating;


/**
 *  Reset the countdown view to zero time
 */
- (void)reset;

@end
