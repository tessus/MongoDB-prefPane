//
//  ArgumentsViewController.m
//  mongodb.prefpane
//
//  Created by Ivan on 5/18/11.
//  Copyright 2011 Iván Valdés Castillo. All rights reserved.
//
//  Copyright (c) Helmut K. C. Tessarek, 2015
//

#import "ArgumentsViewController.h"
#import "Preferences.h"

@interface MDBArgumentsViewController(/* Hidden Methods*/)
@property (nonatomic, strong) NSMutableArray *arguments;
@property (nonatomic, strong) NSMutableArray *parameters;
- (void)removeArgument:(id)sender;
- (void)updatePreferences;
@end

@implementation MDBArgumentsViewController
@synthesize tableView;
@synthesize arguments;
@synthesize parameters;

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.arguments  = [NSMutableArray arrayWithArray:[[MDBPreferences sharedPreferences] objectForUserDefaultsKey:@"arguments"]];
		self.parameters = [NSMutableArray arrayWithArray:[[MDBPreferences sharedPreferences] objectForUserDefaultsKey:@"parameters"]];
	}
	
	return self;
}

#pragma mark - Preferences management

- (void)updatePreferences {
	[[MDBPreferences sharedPreferences] setObject:[NSArray arrayWithArray:self.arguments]
							forUserDefaultsKey:@"arguments"];
	[[MDBPreferences sharedPreferences] setObject:[NSArray arrayWithArray:self.parameters]
							forUserDefaultsKey:@"parameters"];
}

#pragma mark - Table View Tasks

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [self.arguments count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if ([[tableColumn identifier] isEqualToString:@"argumentColumn"])
		return (self.arguments)[row];
	if ([[tableColumn identifier] isEqualToString:@"parametersColumn"])
		return (self.parameters)[row];
	
	return nil;
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if ([[tableColumn identifier] isEqualToString:@"argumentColumn"])
		(self.arguments)[row] = (NSString *)object;
	if ([[tableColumn identifier] isEqualToString:@"parametersColumn"])
		(self.parameters)[row] = (NSString *)object;
	
	[self updatePreferences];
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	return [[tableColumn identifier] isEqualToString:@"argumentColumn"] || [[tableColumn identifier] isEqualToString:@"parametersColumn"];
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	NSCell *cell = [tableColumn dataCell];
	if ([[tableColumn identifier] isEqualToString:@"deleteColumn"]) {
		NSButtonCell *buttonCell = [[NSButtonCell alloc] init];
		[buttonCell setButtonType:NSButtonTypeMomentaryPushIn];
		[buttonCell setBezeled:YES];
		[buttonCell setBezelStyle:NSBezelStyleSmallSquare];
		[buttonCell setTitle:@"-"];
		[buttonCell setTarget:self];
		[buttonCell setAction:@selector(removeArgument:)];
		return buttonCell;
	}
	return cell;
}

#pragma mark - Interface Builder Actions

- (void)removeArgument:(id)sender {
	[self.arguments removeObjectAtIndex:[tableView selectedRow]];
	[self.parameters removeObjectAtIndex:[tableView selectedRow]];
	
	[self updatePreferences];
	[self.tableView reloadData];
}

- (IBAction)addRow:(id)sender {
	[self.arguments addObject:[NSString stringWithFormat:@"--option%lu",
							   (unsigned long)[self.arguments count]]];
	[self.parameters addObject:[NSString stringWithFormat:@"value%lu",
								(unsigned long)[self.parameters count]]];
	
	[self.tableView reloadData];
}

@end
