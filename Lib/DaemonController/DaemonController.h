//
//  DaemonController.h
//  mongodb.prefpane
//
//  Based on DaemonController by Max Howell. Released under GNU GPL v3.
//  Created by Ivan Valdes on 4/14/2010.
//
//  Copyright (c) Helmut K. C. Tessarek, 2015
//

#import <Cocoa/Cocoa.h>

typedef void (^DaemonStarted)(NSNumber *);
typedef void (^DaemonStopped)(void);
typedef void (^DaemonIsStarting)(void);
typedef void (^DaemonIsStopping)(void);
typedef void (^DaemonFailedToStart)(NSString *);
typedef void (^DaemonFailedToStop)(NSString *);

@interface MDBDaemonController : NSObject {
	NSArray  *startArguments;
	NSArray  *stopArguments;
	NSString *launchPath;
	
	DaemonStarted daemonStartedCallback;
	DaemonStopped daemonStoppedCallback;
	DaemonIsStarting daemonIsStartingCallback;
	DaemonIsStopping daemonIsStoppingCallback;
	DaemonFailedToStart daemonFailedToStartCallback;
	DaemonFailedToStop daemonFailedToStopCallback;
	
@private
	NSString *binaryName;
	NSTask	 *daemonTask;
	NSTimer  *pollTimer;
	NSTimer  *checkStartupStatusTimer;
	pid_t	    pid;
	CFFileDescriptorRef fdref;
}

@property (nonatomic, strong) NSArray *startArguments;
@property (nonatomic, strong) NSArray *stopArguments;
@property (nonatomic, strong) NSString *launchPath;

@property (weak, readonly, getter = pid) NSNumber *pid;
@property (readonly, getter = running) BOOL isRunning;

@property (readwrite, copy) DaemonStarted daemonStartedCallback;
@property (readwrite, copy) DaemonStopped daemonStoppedCallback;
@property (readwrite, copy) DaemonIsStarting daemonIsStartingCallback;
@property (readwrite, copy) DaemonIsStopping daemonIsStoppingCallback;
@property (readwrite, copy) DaemonFailedToStart daemonFailedToStartCallback;
@property (readwrite, copy) DaemonFailedToStop daemonFailedToStopCallback;

- (void)start;
- (void)stop;

- (BOOL)running;
- (NSNumber *)pid;

@end
