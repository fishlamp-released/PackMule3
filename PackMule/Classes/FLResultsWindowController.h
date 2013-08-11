//
//  FLResultsWindowController.h
//  PackMule
//
//  Created by Mike Fullerton on 1/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FLResultsWindowController : NSWindowController {
@private
    IBOutlet NSTextView* _textView;
    IBOutlet NSTextField* _label;
    IBOutlet NSButton* _button;
    
    NSString* _labelString;
    NSString* _resultString;
}

+ (id) resultWindowController:(NSString*) label results:(NSString*) result;

@end
