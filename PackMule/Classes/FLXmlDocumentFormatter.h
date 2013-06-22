//
//  FLXmlDocumentFormatter.h
//  PackMule
//
//  Created by Mike Fullerton on 1/31/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLDocumentFormatter.h"

@interface FLXmlDocumentFormatter : FLDocumentFormatter

+ (id) xmlDocumentFormatter;

- (NSData*) xmlDataWithXMLString:(NSString*) string;
- (NSXMLDocument*) xmlDocumentWithXmlString:(NSString*) string;
- (NSString*) prettyPrintString:(NSString*) string;

@end
