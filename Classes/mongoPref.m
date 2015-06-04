//
//  mongoPref.m
//  mongodb.prefpane
//
//  Created by Iván Valdés Castillo on 4/12/10.
//  Copyright (c) 2010 Iván Valdés Castillo, released under the MIT license
//
//  Copyright 2015 Helmut K. C. Tessarek
//

#import "mongoPref.h"
#import "MBSliderButton.h"
#import "FFYDaemonController.h"
#import "Preferences.h"

@interface mongoPref(/* Hidden Methods */)
- (void)binaryLocationChanged:(NSNotification *)notification;

@property (nonatomic, strong) FFYDaemonController *daemonController;
@end

@implementation mongoPref
@synthesize theSlider;
@synthesize daemonController;
@synthesize launchPathTextField;

- (id)initWithBundle:(NSBundle *)bundle {
	if ((self = [super initWithBundle:bundle])) {
		[[Preferences sharedPreferences] setBundle:bundle];
	}
	
	return self;
}

- (void)mainViewDidLoad {
	FFYDaemonController *dC = [[FFYDaemonController alloc] init];
	self.daemonController = dC;
	
	NSMutableArray *arguments = (NSMutableArray *)[[Preferences sharedPreferences] argumentsWithParameters];
	
	daemonController.launchPath     = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"];
	daemonController.startArguments = arguments;
	
	__weak typeof(theSlider) weakSlider = theSlider;
	
	daemonController.daemonStartedCallback = ^(NSNumber *pid) {
		[weakSlider setState:NSOnState animate:YES];
	};
	
	daemonController.daemonFailedToStartCallback = ^(NSString *reason) {
		[weakSlider setState:NSOffState animate:YES];
	};
	
	daemonController.daemonStoppedCallback = ^(void) {
		[weakSlider setState:NSOffState animate:YES];
	};
	
	daemonController.daemonFailedToStopCallback = ^(NSString *reason) {
		[weakSlider setState:NSOnState animate:YES];
	};
	
	[theSlider setState:daemonController.isRunning ? NSOnState : NSOffState];
	[launchPathTextField setStringValue:daemonController.launchPath];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(binaryLocationChanged:) name:NSControlTextDidChangeNotification object:launchPathTextField];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)startStopDaemon:(id)sender {
	NSMutableArray *arguments = (NSMutableArray *)[[Preferences sharedPreferences] argumentsWithParameters];
	
	daemonController.launchPath     = [[[Preferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"] stringByExpandingTildeInPath];
	daemonController.startArguments = arguments;
	
	if (theSlider.state == NSOffState)
		[daemonController stop];
	else
		[daemonController start];
}

- (IBAction)locateBinary:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:YES];
	[openPanel setShowsHiddenFiles:YES];
	[openPanel setResolvesAliases:NO];
	
	if (![[launchPathTextField stringValue] isEqualToString:@""])
		[openPanel setDirectoryURL:[NSURL fileURLWithPath:[[launchPathTextField stringValue] stringByDeletingLastPathComponent]]];
	
	if ([openPanel runModal] == NSOKButton) {
		[launchPathTextField setStringValue:[openPanel.URL path]];
		[[Preferences sharedPreferences] setObject:[launchPathTextField stringValue] forUserDefaultsKey:@"launchPath"];
		daemonController.launchPath = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"];
	}
}

- (void)binaryLocationChanged:(NSNotification *)notification {
	[[Preferences sharedPreferences] setObject:[launchPathTextField stringValue] forUserDefaultsKey:@"launchPath"];
	daemonController.launchPath = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"];
}

@end
