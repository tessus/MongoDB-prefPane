//
//  Preferences.m
//  mongodb.prefpane
//
//  Created by Ivan on 5/23/11.
//  Copyright 2011 Iván Valdés Castillo. All rights reserved.
//
//  Copyright (c) Helmut K. C. Tessarek, 2015
//

#import "Preferences.h"

@implementation MDBPreferences
@synthesize bundle;

+ (MDBPreferences *)sharedPreferences {
	static MDBPreferences *sharedPreferences = nil;

	@synchronized(self) {
		if (!sharedPreferences)
			sharedPreferences = [[self alloc] init];
	}

	return sharedPreferences;
}

- (id)objectForUserDefaultsKey:(NSString *)key {
	CFPropertyListRef obj = CFPreferencesCopyAppValue((CFStringRef)key, (CFStringRef)[bundle bundleIdentifier]);
	return (__bridge id)obj;
}

- (void)setObject:(id)value forUserDefaultsKey:(NSString *)key {
	CFPreferencesSetValue((CFStringRef)key, (__bridge CFPropertyListRef)(value), (CFStringRef)[bundle bundleIdentifier], kCFPreferencesCurrentUser,  kCFPreferencesAnyHost);
	CFPreferencesSynchronize((CFStringRef)[bundle bundleIdentifier], kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
}

- (NSArray *)argumentsWithParameters {
	NSMutableArray *theArgumentsWithParameters = [NSMutableArray array];
	NSArray *parameters = [self objectForUserDefaultsKey:@"parameters"];
	
	[[self objectForUserDefaultsKey:@"arguments"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *argument  = obj;
		NSString *parameter = [parameters[idx] stringByExpandingTildeInPath];
		
		if ([argument length] && [argument characterAtIndex:0] == '-') {
			[theArgumentsWithParameters addObject:argument];
			if ([parameter length])
				[theArgumentsWithParameters addObject:parameter];
		}
	}];
	
	return (NSArray *)theArgumentsWithParameters;
}

- (void)setBundle:(NSBundle *)aBundle
{
	if (bundle != aBundle)
	{
		bundle = aBundle;

		if (bundle)
		{
			if (![self objectForUserDefaultsKey:@"arguments"])
				[self setObject:@[] forUserDefaultsKey:@"arguments"];
			if (![self objectForUserDefaultsKey:@"parameters"])
				[self setObject:@[] forUserDefaultsKey:@"parameters"];
			if (![self objectForUserDefaultsKey:@"launchPath"] || [[self objectForUserDefaultsKey:@"launchPath"] isEqualToString:@""])
			{
				NSFileManager *fileManager = [NSFileManager defaultManager];
				NSString *location = @"";
				
				if([fileManager fileExistsAtPath:@"/usr/local/bin/mongod"])
					location = @"/usr/local/bin/mongod";
				else if ([fileManager fileExistsAtPath:@"/usr/bin/mongod"])
					location = @"/usr/bin/mongod";
				else if ([fileManager fileExistsAtPath:@"/bin/mongod"])
					location = @"/bin/mongod";
				else if ([fileManager fileExistsAtPath:@"/sbin/mongod"])
					location = @"/sbin/mongod";
				else if ([fileManager fileExistsAtPath:@"/opt/bin/mongod"])
					location = @"/opt/bin/mongod";
				else if ([fileManager fileExistsAtPath:@"/opt/local/bin/mongod"])
					location = @"/opt/local/bin/mongod";
				
				[self setObject:location forUserDefaultsKey:@"launchPath"];
			}
		}
	}
}

@end
