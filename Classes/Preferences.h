//
//  Preferences.h
//  mongodb.prefpane
//
//  Created by Ivan on 5/23/11.
//  Copyright 2011 Iván Valdés Castillo. All rights reserved.
//
//  Copyright (c) Helmut K. C. Tessarek, 2015
//

@interface MDBPreferences : NSObject {
	NSBundle *bundle;
}

@property (nonatomic, strong) NSBundle *bundle;

+ (MDBPreferences *)sharedPreferences;

- (id)objectForUserDefaultsKey:(NSString *)key;
- (void)setObject:(id)value forUserDefaultsKey:(NSString *)key;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *argumentsWithParameters;

@end
