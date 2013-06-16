//
//	FLCodeGeneratorDocument.m
//	PackMule
//
//	Created by Mike Fullerton on 8/16/09.
//	Copyright Greentongue Software 2009 . All rights reserved.
//

#import "AppDelegate.h"
#import "FLCodeViewController.h"
#import "NSWindowController+FLModalAdditions.h"
#import "FLErrorWindowController.h"
#import "FLCodeGeneratorDocument.h"
#import "FLCodeGenerator.h"
#import "FLResultsWindowController.h"
#import "FLObjCCodeGenerator.h"
#import "FLXmlCodeProjectReader.h"
#import "FLWsdlCodeProjectReader.h"
#import "FLErrorWindowController.h"
#import "FLCodeProjectLocation.h"
#import "FLXmlDocumentFormatter.h"
#import "FLResultsWindowController.h"
#import "NSTextView+FLTextWrapping.h"

#import "FLResultsViewController.h"


@implementation FLCodeGeneratorDocument

- (NSString *)windowNibName {
	return @"FLCodeGeneratorDocument";
}

#if FL_MRC
- (void) dealloc {
    [_stringLoadedFromFile release];
    [super dealloc];
}
#endif

- (NSWindowController*) windowController {
    return [self.windowControllers objectAtIndex:0];
}

- (NSWindow*) window {
    return [[self.windowControllers objectAtIndex:0] window];
}

- (IBAction) prettyPrintText:(id) sender {
    @try {
        [_codeViewController prettyPrintText:sender];
    }
    @catch(NSException* ex) {
        [self.windowController showErrorAlert:@"Pretty print, Pretty Schmint." caption:nil error:ex.error];
    }
}

- (void) setDefaultCode {
    [_codeViewController setDefaultCode];
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController {
	[super windowControllerDidLoadNib:aController];

    if(FLStringIsNotEmpty(_stringLoadedFromFile)) {
        [_codeViewController setCode:_stringLoadedFromFile];
    }
    else {
        [_codeViewController setDefaultCode];
    }

    FLReleaseWithNil(_stringLoadedFromFile);
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
	return [_codeViewController.code dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {

    NSString* code = FLAutorelease([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    if(_codeViewController) {
        [_codeViewController setCode:code];
    }
    else {
        FLSetObjectWithRetain(_stringLoadedFromFile, code);
    }

	return YES;
}

- (IBAction) revealInFinder:(id) sender {
    NSURL* fileURL = [self fileURL];
    if(fileURL) {
        [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:[fileURL.path stringByDeletingLastPathComponent]];
    }
}

- (void) didGenerateCodeWithResult:(FLPromisedResult) result {

    FLAssert([NSThread isMainThread]);

    FLPrettyString* builder = [FLPrettyString prettyString];

    FLCodeGeneratorResult* codeGeneratorResult = result;
    
    for(NSString* file in codeGeneratorResult.addedFiles){
        [builder appendLineWithFormat:@"New: %@", file];
    }
    for(NSString* file in codeGeneratorResult.changedFiles) {
        [builder appendLineWithFormat:@"Updated: %@", file];
    }
    for(NSString* file in codeGeneratorResult.unchangedFiles) {
        [builder appendLineWithFormat:@"Unchanged: %@", file];
    }
    
    [self displayResult:@"generated ok" results:builder.string];
}

- (void) generateNow {
  
    @try {
        FLCodeProjectLocation* resourceDescriptor = [FLCodeProjectLocation resourceDescriptor:[self fileURL] resourceType:FLCodeProjectLocationTypeFile];
        
        FLCodeProjectReader* reader = [FLCodeProjectReader codeProjectReader];
        [reader addFileReader:[FLXmlCodeProjectReader xmlCodeProjectReader]];
        [reader addFileReader:[FLWsdlCodeProjectReader wsdlCodeReader]];
        
        FLObjcCodeGenerator* generator = [FLObjcCodeGenerator  objcCodeGenerator];

        FLCodeProject* project = [reader readProjectFromLocation:resourceDescriptor ];

        FLCodeGeneratorResult* result = [generator generateCodeWithCodeProject:project fromLocation:resourceDescriptor];

        [self didGenerateCodeWithResult:result];
        
    }
    @catch(NSException* ex) {
        [self.windowController showErrorAlert:@"Code Generation Failed" caption:nil error:ex.error];
    }
}

- (void)document:(NSDocument *)document
didSaveBeforeGenerating:(BOOL)didSaveSuccessfully
     contextInfo:(void *)contextInfo {

	if(didSaveSuccessfully) {
		[self generateNow];
	}
    else {
        // Error
    }
}

- (IBAction) generateCode:(id) sender {
	[self saveDocumentWithDelegate:self didSaveSelector:@selector(document:didSaveBeforeGenerating:contextInfo:) contextInfo:nil];
}

- (void) displayResult:(NSString*) title results:(NSString*) result {
//    NSAttributedString* attrString = FLAutorelease([[NSAttributedString alloc] initWithString:result]);
//    [[_resultsTextView textStorage] appendAttributedString:attrString];

    [_resultsViewController.textView setString:result];

//    FLSheetHandler* handler = [FLSheetHandler sheetHandler];
//    handler.modalWindowController = [FLResultsWindowController resultWindowController:title results:result];
//    handler.hostWindow = self.window;
//    [handler beginSheet];
}




//
//- (void)sheetDidEnd:(NSAlert*)alert 
//         returnCode:(NSInteger)returnCode 
//        contextInfo:(void*)contextInfo {
//    [NSApp endModalSession:_modalSession];
//    self.resultsWindow = nil;
//}







@end
