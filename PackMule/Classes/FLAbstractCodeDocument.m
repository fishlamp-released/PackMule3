//
//	FLAbstractCodeDocument.m
//	PackMule
//
//	Created by Mike Fullerton on 3/25/10.
//	Copyright 2010 GreenTongue Software. All rights reserved.
//

#import "FLAbstractCodeDocument.h"
#import "NSWindowController+FLModalAdditions.h"
#import "FLErrorWindowController.h"

@interface NSTextView (Wrapping)
- (void) setWrapsText:(BOOL)wraps;
@end

@implementation NSTextView (Wrapping)
- (void) setWrapsText:(BOOL)wraps {
	if(wraps) {
		// implement later
	} else {
		NSSize bigSize = NSMakeSize(FLT_MAX, FLT_MAX);
		
		[[self enclosingScrollView] setHasHorizontalScroller:YES];
		[self setHorizontallyResizable:YES];
		[self setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		
		[[self textContainer] setContainerSize:bigSize];
		[[self textContainer] setWidthTracksTextView:NO];
	}
}
@end

@interface FLAbstractCodeDocument ()
@property (readwrite, strong, nonatomic) id documentFormatter;
//@property (readwrite, retain, nonatomic) NSString* string;
@end

@implementation FLAbstractCodeDocument

@synthesize textView = _textView;
@synthesize documentFormatter = _documentFormatter;

- (id) init {
    self = [super init];
    if(self) {
    }
    return self;
}

#if FL_MRC
- (void) dealloc {
    [_stringLoadedFromFile release];
    [_documentFormatter release];
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
        _textView.string = [self.documentFormatter prettyPrintString:_textView.string];
    }
    @catch(NSException* ex) {
        [self.windowController showErrorAlert:@"Pretty print, Pretty Schmint." caption:nil error:ex.error];
    }
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController {
	[super windowControllerDidLoadNib:aController];
    FLAssertNotNil(_textView);
    [_textView setWrapsText:NO];
    [_textView setFont:[NSFont fontWithName:@"Menlo Regular" size:10]];
    self.documentFormatter = FLAutorelease([[FLXmlDocumentFormatter alloc] init]);
    if(FLStringIsNotEmpty(_stringLoadedFromFile)) {
        _textView.string = _stringLoadedFromFile;
        
    }
    else {
        [self setDefaultCode];
    }

    FLReleaseWithNil(_stringLoadedFromFile);
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
	return [_textView.string dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    _stringLoadedFromFile = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return YES;
}

- (IBAction) revealInFinder:(id) sender {
    NSURL* fileURL = [self fileURL];
    if(fileURL) {
        [[NSWorkspace sharedWorkspace] selectFile:nil inFileViewerRootedAtPath:[fileURL.path stringByDeletingLastPathComponent]];
    }
}

- (void) setDefaultCode {
}

- (void) generateNow {
//	NSData* data = nil;
//	if([self getXmlDocumentData:&data error:nil])
//	{
//		[self onGenerateCode:data filePath:[[self fileURL] path]];
//		
//		[data release];
//	}
}

- (void)document:(NSDocument *)document 
         didSave:(BOOL)didSaveSuccessfully 
     contextInfo:(void *)contextInfo {

	if(didSaveSuccessfully) {
		[self generateNow];
	}
    else {
        // Error
    }
}

- (IBAction) generateCode:(id) sender {
	[self saveDocumentWithDelegate:self didSaveSelector:@selector(document:didSave:contextInfo:) contextInfo:nil];
}

- (void) displayResult:(NSString*) title results:(NSString*) result {
    FLSheetHandler* handler = [FLSheetHandler sheetHandler];
    handler.modalWindowController = [FLResultsWindowController resultWindowController:title results:result];
    handler.hostWindow = self.window;
    [handler beginSheet];
}



//
//- (void)sheetDidEnd:(NSAlert*)alert 
//         returnCode:(NSInteger)returnCode 
//        contextInfo:(void*)contextInfo {
//    [NSApp endModalSession:_modalSession];
//    self.resultsWindow = nil;
//}






@end
