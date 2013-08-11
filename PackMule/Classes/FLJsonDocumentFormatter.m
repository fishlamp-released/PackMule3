//
//  FLJsonDocumentFormatter.m
//  PackMule
//
//  Created by Mike Fullerton on 6/21/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLJsonDocumentFormatter.h"
#import "FLJsonParser.h"

@implementation FLJsonDocumentFormatter

+ (id) jsonDocumentFormatter {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) canFormatCode:(NSString*) code {
    return [FLJsonParser canParseData:[code dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
