//
//  FLCodeViewController.h
//  PackMule
//
//  Created by Mike Fullerton on 6/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FLTextViewController.h"

@interface FLCodeViewController : FLTextViewController {
@private
    id _documentFormatter;
}

@property (readwrite, strong, nonatomic) NSString* code;

- (void) setDefaultCode;

- (IBAction) prettyPrintText:(id) sender;

- (IBAction) insertObject:(id) sender;

@end
