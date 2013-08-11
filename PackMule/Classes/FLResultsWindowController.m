//
//  FLResultsWindowController.m
//  PackMule
//
//  Created by Mike Fullerton on 1/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLResultsWindowController.h"

@interface FLResultsWindowController ()
@end

@implementation FLResultsWindowController

- (id) initWithLabelString:(NSString*) label results:(NSString*) result {
    self = [super initWithWindowNibName:@"FLResultsWindowController"];
    if(self) {
        _labelString = FLRetain(label);
        _resultString = FLRetain(result);
    }
    return self;
}

+ (id) resultWindowController:(NSString*) label results:(NSString*) result {
    return FLAutorelease([[[self class] alloc] initWithLabelString:label results:result]);
}

#if FL_MRC
- (void) dealloc {
    [_labelString release];
    [_resultString release];
    [super dealloc];
}
#endif

- (NSButton*) closeModalWindowButton {
    return _button;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [_label setStringValue:_labelString];
    
    if(FLStringIsEmpty(_resultString)) {
        _textView.string = @"nothing to report.";
    }
    else {
        _textView.string = _resultString;
    }
    
}

//- (IBAction) closeResultsWindow:(id) sender {
//    [[NSApplication sharedApplication] endSheet:self.window];
//}

//- (void) showModallyInWindow:(NSWindow*) window {
//    [[NSApplication sharedApplication] beginSheet:self.window  
//                                   modalForWindow:window
//                                   modalDelegate:self 
//                                   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
//                                      contextInfo:nil];
//                                      
//    _modalSession = [NSApp beginModalSessionForWindow:self.window];
//    [NSApp runModalSession:_modalSession];
//    [self.window makeFirstResponder:self.window];
//    [self.window setDefaultButtonCell:[_button cell]];
//}
//
//- (void)sheetDidEnd:(NSAlert*)alert 
//         returnCode:(NSInteger)returnCode 
//        contextInfo:(void*)contextInfo {
//
//    [NSApp endModalSession:_modalSession];
//    [self.window orderOut:self.window];
//    _modalSession = nil;
//}


@end
