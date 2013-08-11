//
//  FLDocumentFormatter.m
//  PackMule
//
//  Created by Mike Fullerton on 6/21/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLDocumentFormatter.h"

@implementation FLDocumentFormatter
- (NSString*) prettyPrintString:(NSString*) string {
    return string;
}

- (BOOL) canFormatCode:(NSString*) code {
    return NO;
}
@end
