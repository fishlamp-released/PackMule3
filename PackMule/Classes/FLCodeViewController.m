//
//  FLCodeViewController.m
//  PackMule
//
//  Created by Mike Fullerton on 6/16/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeViewController.h"
#import "FLXmlDocumentFormatter.h"
#import "NSTextView+FLTextWrapping.h"

@interface FLCodeViewController ()
@property (readwrite, strong, nonatomic) id documentFormatter;
@end

@implementation FLCodeViewController

@synthesize documentFormatter = _documentFormatter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) setDefaultCode {
	NSURL* defaultXmlPath = [[NSBundle mainBundle] URLForResource:@"DefaultXmlFile" withExtension:@"xml"];
    NSString* defaultXml = [NSString stringWithContentsOfURL:defaultXmlPath encoding:NSUTF8StringEncoding  error:nil];
    if(FLStringIsNotEmpty(defaultXml)) {
        self.textView.string = defaultXml;
    }
}

#if FL_MRC
- (void) dealloc {
    [_documentFormatter release];
    [super dealloc];
}
#endif

- (NSString*) code {
    return self.textView.string;
}

- (void) setCode:(NSString*) code {
    self.textView.string = code;
}

- (IBAction) prettyPrintText:(id) sender {
    self.textView.string = [self.documentFormatter prettyPrintString:self.textView.string];
}

- (void) awakeFromNib {
	[super awakeFromNib];

    [self.textView setWrappingDisabled];

//    NSMutableParagraphStyle *style = FLAutorelease([[NSMutableParagraphStyle alloc] init]);
//    [style setDefaultTabInterval:100.0];
//    [style setTabStops:[NSArray array]];
//    [_textView setDefaultParagraphStyle:style];
//    [_textView setTypingAttributes:[NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName]];

    self.documentFormatter = FLAutorelease([[FLXmlDocumentFormatter alloc] init]);
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {

    return YES;
}

@end
