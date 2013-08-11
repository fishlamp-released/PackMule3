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

#import "FLXmlDocumentBuilder.h"
#import "FLJsonDocumentFormatter.h"

#import "FLCodeObject.h"

@interface FLCodeViewController ()
@property (readwrite, strong, nonatomic) FLDocumentFormatter* documentFormatter;
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

- (void) updateFormatterForString:(NSString*) string {
    
    self.documentFormatter = nil;

    for(FLDocumentFormatter* formatter in _formatters) {
    
        if([formatter canFormatCode:string]) {
            self.documentFormatter = formatter;
            break;
        }
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
    [self updateFormatterForString:code];
}

- (IBAction) prettyPrintText:(id) sender {
    self.textView.string = [self.documentFormatter prettyPrintString:self.textView.string];
}

- (void) awakeFromNib {
	[super awakeFromNib];

    _formatters = [[NSMutableArray alloc] init];
    [_formatters addObject:[FLXmlDocumentFormatter xmlDocumentFormatter]];
    [_formatters addObject:[FLJsonDocumentFormatter jsonDocumentFormatter]];

    [self.textView setWrappingDisabled];

//    NSMutableParagraphStyle *style = FLAutorelease([[NSMutableParagraphStyle alloc] init]);
//    [style setDefaultTabInterval:100.0];
//    [style setTabStops:[NSArray array]];
//    [_textView setDefaultParagraphStyle:style];
//    [_textView setTypingAttributes:[NSDictionary dictionaryWithObject:style forKey:NSParagraphStyleAttributeName]];

//    self.documentFormatter = FLAutorelease([[FLXmlDocumentFormatter alloc] init]);
}

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {

    return YES;
}

- (void) insertCode:(NSString*) code {
//   NSRange insertion = [self.textView selectedRange];

   [self.textView insertText:code];
}

- (void) insertObjectOfClass:(Class) class name:(NSString*) name {
    FLXmlDocumentBuilder* xml = [FLXmlDocumentBuilder xmlStringBuilder];
    [xml openElement:[FLXmlElement xmlElement:name]];
    FLObjectDescriber* describer = [class objectDescriber];

    for(FLPropertyDescriber* property in describer.propertyEnumerator) {
        [xml addElement:[FLXmlElement xmlElement:property.propertyName]];
    }
    [xml closeElement];

    [self insertCode:[xml buildString]];

}

- (IBAction) insertObject:(id) sender {
    [self insertObjectOfClass:[FLCodeObject class] name:@"object"];
}

@end
