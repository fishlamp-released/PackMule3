//
//  FLXmlDocumentFormatter.m
//  PackMule
//
//  Created by Mike Fullerton on 1/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLXmlDocumentFormatter.h"
#import "FLXmlParser.h"

#define XMLOPTIONS NSXMLNodePreserveCDATA | NSXMLNodeCompactEmptyElement | NSXMLDocumentTidyXML

@implementation FLXmlDocumentFormatter

+ (id) xmlDocumentFormatter {
    return FLAutorelease([[[self class] alloc] init]);
}

- (NSData*) xmlDataWithXMLString:(NSString*) string {
	NSXMLDocument* document = [self xmlDocumentWithXmlString:string];
	return [document XMLDataWithOptions:XMLOPTIONS];
}

- (NSXMLDocument*) xmlDocumentWithXmlString:(NSString*) string {

// weird code alert	
    
    NSError* err = nil;
	NSXMLDocument* document = FLAutorelease([[NSXMLDocument alloc] initWithXMLString:string options:XMLOPTIONS error:&err]);
	FLThrowIfError(FLAutorelease(err));
        
    return document;
    
//	NSAlert* alert = [NSAlert alertWithMessageText:@"Xml is malformed"
//			defaultButton:@"OK"
//			alternateButton:nil
//			otherButton:nil
//			informativeTextWithFormat:@"%@", [err localizedDescription]
//			];
//
//	[alert runModal];
//	
//	if(outError) {
//		*outError = err;
//	}
//
//	return NO;
}

- (NSString*) prettyPrintString:(NSString*) string {

	NSError* error = nil;
	NSXMLDocument* document = FLAutorelease([[NSXMLDocument alloc] initWithXMLString:string options:XMLOPTIONS error:&error]);
	FLThrowIfError(error);


    NSString* pretabbed = [document XMLStringWithOptions:NSXMLNodePrettyPrint|XMLOPTIONS];
    return [pretabbed stringByReplacingOccurrencesOfString:@"\t" withString:@"    "];

//	else {
//		NSAlert* alert = [NSAlert alertWithMessageText:@"Unable to pretty print"
//					defaultButton:@"OK"
//					alternateButton:nil
//					otherButton:nil
//					informativeTextWithFormat:@"Xml is malformed:\n%@", [error localizedDescription]
//					];
//
//	
//	 //	  NSAlert* alert = [NSAlert alertWithError:error];
//		[alert runModal];
//	}
//    
//    return string;
}

- (BOOL) canFormatCode:(NSString*) code {
    return [FLXmlParser canParseData:[code dataUsingEncoding:NSUTF8StringEncoding]];
}




@end
