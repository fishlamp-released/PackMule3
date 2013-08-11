//
//  FLCodeViewController.h
//  PackMule
//
//  Created by Mike Fullerton on 6/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLTextViewController.h"

@class FLDocumentFormatter;

@interface FLCodeViewController : FLTextViewController {
@private
    FLDocumentFormatter* _documentFormatter;
    NSMutableArray* _formatters;
}

@property (readwrite, strong, nonatomic) NSString* code;

- (void) setDefaultCode;

- (IBAction) prettyPrintText:(id) sender;

- (IBAction) insertObject:(id) sender;

@end
