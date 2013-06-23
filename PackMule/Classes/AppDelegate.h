//
//  AppDelegate.h
//  PackMule
//
//  Created by Mike Fullerton on 9/25/12.
//  Copyright (c) 2012 Mike Fullerton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FishLamp.h"

#import "FLDocumentSection.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
}

+ (AppDelegate*) instance;

- (IBAction) generateCodeFromFile:(id) sender;
- (IBAction) downloadWsdl:(id) sender;
- (IBAction) ok:(id) sender;
- (IBAction) cancel:(id) cancel;

- (IBAction) parseFile:(id) sender;
- (IBAction) newCodeDocument:(id) sender;
- (IBAction) newWsdlDocument:(id) sender;

- (IBAction) runUnitTests:(id) sender;

- (void) showAlertForError:(NSError*) error;

@end
