//
//  ArgumentsViewController.h
//  mongodb.prefpane
//
//  Created by Ivan on 5/18/11.
//  Copyright 2011 Iván Valdés Castillo. All rights reserved.
//
//  Copyright (c) Helmut K. C. Tessarek, 2015
//

#import <Cocoa/Cocoa.h>

@interface MDBArgumentsViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource> {
	NSTableView *tableView;
@private
	NSMutableArray *arguments;
	NSMutableArray *parameters;
}

@property (nonatomic, strong) IBOutlet NSTableView *tableView;

- (IBAction)addRow:(id)sender;

@end
