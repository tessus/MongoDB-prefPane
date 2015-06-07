//
//  mongoPref.h
//  mongodb.prefpane
//
//  Created by Iván Valdés Castillo on 4/12/10.
//  Copyright (c) 2010 Iván Valdés Castillo, released under the MIT license
//
//  Copyright (c) Helmut K. C. Tessarek, 2015
//

#import <PreferencePanes/PreferencePanes.h>

@class FFYDaemonController;
@class MBSliderButton;

@interface mongoPref : NSPreferencePane {
	MBSliderButton *__weak theSlider;
	NSTextField *__weak launchPathTextField;
	NSTextField *__weak pidtext;
@private
	FFYDaemonController *daemonController;
}

@property (nonatomic, weak) IBOutlet MBSliderButton	*theSlider;
@property (nonatomic, weak) IBOutlet NSTextField *launchPathTextField;
@property (nonatomic, weak) IBOutlet NSTextField *pidtext;

- (IBAction)startStopDaemon:(id)sender;
- (IBAction)locateBinary:(id)sender;

@end
