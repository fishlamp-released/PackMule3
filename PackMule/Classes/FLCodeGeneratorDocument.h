//
//	FLCodeGeneratorDocument.h
//	PackMule
//
//	Created by Mike Fullerton on 8/16/09.
//	Copyright Greentongue Software 2009 . All rights reserved.
//


#import "FishLamp.h"
@class FLCodeViewController;
@class FLResultsViewController;

@interface FLCodeGeneratorDocument : NSDocument {
@private
    IBOutlet FLResultsViewController* _resultsViewController;
    IBOutlet FLCodeViewController* _codeViewController;
    NSString* _stringLoadedFromFile;
}

- (NSWindowController*) windowController;

- (void) displayResult:(NSString*) title results:(NSString*) result;

- (void) generateNow;
- (void) setDefaultCode;

- (IBAction) revealInFinder:(id) sender;
- (IBAction) generateCode:(id) sender;
- (IBAction) prettyPrintText:(id) sender;

@end
