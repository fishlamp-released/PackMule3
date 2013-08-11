//
//	FLWsdlDocument.m
//	PackMule
//
//	Created by Mike Fullerton on 8/23/09.
//	Copyright 2009 Greentongue Software. All rights reserved.
//

#import "FLWsdlDocument.h"
#import "AppDelegate.h"

@implementation FLWsdlDocument

- (NSString *)windowNibName {
	// Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
	return @"FLWsdlDocument";
}



- (void) openUrl:(NSString*) url {
	m_url = url;
/*
	NSXMLDocument* xml = [[FLCodeGeneratorProjectManager instance] parseWsdlFromURL:m_url];
	[_textView setString:[xml XMLStringWithOptions:0]];
	[self prettyPrintText:nil];
 */
	
}

- (void) updateCodeSchema:(id) sender {
//	NSData* data = nil;
//	if([self getXmlDocumentData:&data error:nil])
//	{
//	/*
//		FLCodeGeneratorWsdlCodeGenerator* generator = [[FLCodeGeneratorWsdlCodeGenerator alloc] init];
//		
//		FLCodeGeneratorWsdlDefinitions* definitions = [generator parseData:data];
//		
//		definitions = definitions;
//		
//		[data release];
//		[generator release];
//	*/
//	}
}

- (void) onGenerateCode:(NSData*) xmlData  filePath:(NSString*) path {
//	@try
//	{
//		NSData* data = nil;
//		if([self getXmlDocumentData:&data error:nil])
//		{
//		 /*
//			   FLCodeGeneratorWsdlCodeGenerator* generator = [[FLCodeGeneratorWsdlCodeGenerator alloc] init];
//			
//			FLCodeGeneratorWsdlDefinitions* definitions = [generator parseData:data];
//			
//			definitions = definitions;
//			
//			[data release];
//			[generator release];
//			*/
//		}
//	
//	/*
//		FLCodeGeneratorProject* code = [[FLCodeGeneratorProject alloc] initWithXml:xmlData];
//		
//		FLObjectiveCCodeGenerator* generator = [[[FLObjectiveCCodeGenerator alloc] init] autorelease];
//		[generator generateFiles:code file:path];
//		
//		[generator.output appendLine];
//		[generator.output appendLine:[generator.diffs toString]];
//	*/
//		
//	//	[[AppDelegate instance] finishedGenerating:nil output:generator.output];
//	}
//	@catch(NSException* ex)
//	{
////		[[AppDelegate instance] finishedGenerating:ex output:nil];
//	}
}

- (void) updateWsdl:(id) sender {
}

- (void) parseWsdl:(id) sender {
}

- (IBAction) createCodeSchema:(id) sender {
}

- (NSString*) onGetNewTitle:(NSString*) oldName {
	return [NSString stringWithFormat:@"Wsdl: %@", oldName];
}

@end
