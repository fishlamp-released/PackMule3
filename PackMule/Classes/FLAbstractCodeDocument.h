//
//	FLAbstractCodeDocument.h
//	PackMule
//
//	Created by Mike Fullerton on 3/25/10.
//	Copyright 2010 GreenTongue Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FLXmlDocumentFormatter.h"
#import "FLResultsWindowController.h"

@interface FLAbstractCodeDocument : NSDocument {
@private
	IBOutlet NSTextView* _textView;
    NSString* _stringLoadedFromFile;
    id _documentFormatter;
}

- (NSWindowController*) windowController;

@property (readonly, strong, nonatomic) NSTextView* textView;
@property (readonly, strong, nonatomic) id documentFormatter;

- (void) displayResult:(NSString*) title results:(NSString*) result;

- (void) generateNow;
- (void) setDefaultCode;

- (IBAction) revealInFinder:(id) sender;
- (IBAction) generateCode:(id) sender;
- (IBAction) prettyPrintText:(id) sender;

@end
