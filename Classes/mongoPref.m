//
//  mongoPref.m
//  mongodb.prefpane
//
//  Created by Iván Valdés Castillo on 4/12/10.
//  Copyright (c) 2010 Iván Valdés Castillo, released under the MIT license
//
//  Copyright (c) Helmut K. C. Tessarek, 2015
//

#import "mongoPref.h"
#import "MBSliderButton.h"
#import "DaemonController.h"
#import "Preferences.h"

@interface mongoPref(/* Hidden Methods */)
- (void)binaryLocationChanged:(NSNotification *)notification;

@property (nonatomic, strong) MDBDaemonController *daemonController;
@end

@implementation mongoPref
@synthesize theSlider;
@synthesize daemonController;
@synthesize launchPathTextField;
@synthesize pidtext;

- (instancetype)initWithBundle:(NSBundle *)bundle {
	if ((self = [super initWithBundle:bundle])) {
		[[MDBPreferences sharedPreferences] setBundle:bundle];
	}

	numClicked = 0;
	NSDictionary* infoDict = [[NSBundle bundleForClass:[self class]] infoDictionary];
	version = [[NSString alloc] initWithFormat:@"%@ (%@)", infoDict[@"CFBundleShortVersionString"], infoDict[@"CFBundleVersion"]];
	githash = [[NSString alloc] initWithFormat:@"%@", infoDict[@"GitHash"]];
	[versionText setTitle:version];
	
	return self;
}

- (void)mainViewDidLoad {
	MDBDaemonController *dC = [[MDBDaemonController alloc] init];
	self.daemonController = dC;
	
	NSMutableArray *arguments = (NSMutableArray *)[[MDBPreferences sharedPreferences] argumentsWithParameters];
	
	daemonController.launchPath     = [[MDBPreferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"];
	daemonController.startArguments = arguments;

	[versionText setTitle:version];
	[versionText sizeToFit];

	__weak typeof(theSlider) weakSlider = theSlider;
	__weak typeof(pidtext) weakPidtext = pidtext;
	
	daemonController.daemonStartedCallback = ^(NSNumber *pid) {
		[weakPidtext setStringValue:[[NSString alloc] initWithFormat:@"PID: %@", pid ]];
		[weakSlider setState:NSControlStateValueOn animate:YES];
	};
	
	daemonController.daemonFailedToStartCallback = ^(NSString *reason) {
		[weakPidtext setStringValue:@""];
		[weakSlider setState:NSControlStateValueOff animate:YES];
	};

	daemonController.daemonStoppedCallback = ^(void) {
		[weakPidtext setStringValue:@""];
		[weakSlider setState:NSControlStateValueOff animate:YES];
	};

	daemonController.daemonFailedToStopCallback = ^(NSString *reason) {
		[weakSlider setState:NSControlStateValueOn animate:YES];
	};

	[theSlider setState:daemonController.isRunning ? NSControlStateValueOn : NSControlStateValueOff];
	[launchPathTextField setStringValue:daemonController.launchPath];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(binaryLocationChanged:) name:NSControlTextDidChangeNotification object:launchPathTextField];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)clickVersion:(id)sender {
	numClicked++;

	if ((numClicked % 2) == 1) {
		[versionText setTitle:githash];
	}
	else
	{
		[versionText setTitle:version];
		numClicked = 0;
	}
}

- (IBAction)openWebsite:(id)sender {
	[[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://tessus.github.io/MongoDB-prefPane"]];
}

- (IBAction)startStopDaemon:(id)sender {
	NSMutableArray *arguments = (NSMutableArray *)[[MDBPreferences sharedPreferences] argumentsWithParameters];
	
	daemonController.launchPath     = [[[MDBPreferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"] stringByExpandingTildeInPath];
	daemonController.startArguments = arguments;

	if (theSlider.state == NSControlStateValueOff)
	{
		[daemonController stop];
		[pidtext setStringValue:@""];
	}
	else
		[daemonController start];
}

- (IBAction)clickOnOff:(id)sender {
	NSMutableArray *arguments = (NSMutableArray *)[[MDBPreferences sharedPreferences] argumentsWithParameters];

	daemonController.launchPath     = [[[MDBPreferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"] stringByExpandingTildeInPath];
	daemonController.startArguments = arguments;

	int tag = (int)[sender tag];

	if (tag == 0 && daemonController.isRunning)
	{
		[daemonController stop];
		[pidtext setStringValue:@""];
		[theSlider setState:NSControlStateValueOff animate:YES];
	}
	if (tag == 1 && !daemonController.isRunning)
	{
		[daemonController start];
	}
}

- (IBAction)locateBinary:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:YES];
	[openPanel setShowsHiddenFiles:YES];
	[openPanel setResolvesAliases:NO];
	
	if (![[launchPathTextField stringValue] isEqualToString:@""])
		[openPanel setDirectoryURL:[NSURL fileURLWithPath:[[launchPathTextField stringValue] stringByDeletingLastPathComponent]]];
	
	if ([openPanel runModal] == NSModalResponseOK) {
		[launchPathTextField setStringValue:[openPanel.URL path]];
		[[MDBPreferences sharedPreferences] setObject:[launchPathTextField stringValue] forUserDefaultsKey:@"launchPath"];
		daemonController.launchPath = [[MDBPreferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"];
	}
}

- (void)binaryLocationChanged:(NSNotification *)notification {
	[[MDBPreferences sharedPreferences] setObject:[launchPathTextField stringValue] forUserDefaultsKey:@"launchPath"];
	daemonController.launchPath = [[MDBPreferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"];
}

@end
