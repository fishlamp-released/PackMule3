//
//  FLDocumentFormatter.h
//  PackMule
//
//  Created by Mike Fullerton on 6/21/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLDocumentFormatter : NSObject
- (NSString*) prettyPrintString:(NSString*) string;

- (BOOL) canFormatCode:(NSString*) code;

@end
