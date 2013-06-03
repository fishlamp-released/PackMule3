//
//	FLCodeGeneratorDocument.m
//	PackMule
//
//	Created by Mike Fullerton on 8/16/09.
//	Copyright Greentongue Software 2009 . All rights reserved.
//

#import "AppDelegate.h"
#import "FLCodeGeneratorDocument.h"
#import "FLCodeGenerator.h"
#import "FLResultsWindowController.h"
#import "FLObjCCodeGenerator.h"
#import "FLXmlCodeProjectReader.h"
#import "FLWsdlCodeProjectReader.h"
#import "FLErrorWindowController.h"

@implementation FLCodeGeneratorDocument

- (NSString *)windowNibName {
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"FLCodeGeneratorDocument";
}

- (void) didGeneratorCodeWithResult:(FLPromisedResult) result {

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

        [self didGeneratorCodeWithResult:result];
        
    }
    @catch(NSException* ex) {
        [self.windowController showErrorAlert:@"Code Generation Failed" caption:nil error:ex.error];
    }
}

- (void) setDefaultCode {
	NSURL* defaultXmlPath = [[NSBundle mainBundle] URLForResource:@"DefaultXmlFile" withExtension:@"xml"];
    NSString* defaultXml = [NSString stringWithContentsOfURL:defaultXmlPath encoding:NSUTF8StringEncoding  error:nil];
    if(FLStringIsNotEmpty(defaultXml)) {
        self.textView.string = defaultXml;
    }
}



@end
