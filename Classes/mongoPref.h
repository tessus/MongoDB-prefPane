//
//  mongoPref.h
//  mongodb.prefpane
//
//  Created by Iv�n Vald�s Castillo on 4/12/10.
//  Copyright (c) 2010 Iv�n Vald�s Castillo, released under the MIT license
//
//  Copyright 2015 Helmut K. C. Tessarek
//

#import <PreferencePanes/PreferencePanes.h>

@class FFYDaemonController;
@class MBSliderButton;

@interface mongoPref : NSPreferencePane {
	MBSliderButton *__weak theSlider;
	NSTextField *__weak launchPathTextField;
@private
	FFYDaemonController *daemonController;
}

@property (nonatomic, weak) IBOutlet MBSliderButton	*theSlider;
@property (nonatomic, weak) IBOutlet NSTextField *launchPathTextField;

- (IBAction)startStopDaemon:(id)sender;
- (IBAction)locateBinary:(id)sender;

@end