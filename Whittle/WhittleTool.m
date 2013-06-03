//
//  FLPackMuleTool.m
//  PackMuleTool
//
//  Created by Mike Fullerton on 5/5/12.
//  Copyright (c) 2012 GreenTongue Software. All rights reserved.
//

#import "WhittleTool.h"
#import "WLProject.h"
#import "FLXmlParser.h"
#import "FLInputHandler.h"
#import "NSFileManager+FLExtras.h"

#import "WLCodeGeneratorResult.h"
#import "WLCodeGenerator.h"

@interface WhittleTool ()
@property (readwrite, strong, nonatomic) NSString* filePath;
- (void) _generateFromFile:(NSString*) path ignoreWrongType:(BOOL) ignoreWrongType;
- (void) _generateInDirectory:(NSString*) fromPath recursive:(BOOL) recursive;
@end

@implementation WhittleTool

@synthesize filePath = _filePath;

- (id) init {
    self = [super init];
    if(self) {
        FLLoggerSetLevel(FLLoggerDefault(), FLLoggerLevelHigh);
        _optionalPath = [[[NSFileManager defaultManager] currentDirectoryPath] retain];
    }
    
    return self;
}

- (void) dealloc {
    FLRelease(_filePath);
    FLSuperDealloc();
}

- (void) _outputResults:(WLCodeGeneratorResult*) result {
    for(NSString* file in result.addedFiles){
        FLLog (@"New: %@", file);
    }
    for(NSString* file in result.changedFiles) {
        FLLog (@"Updated: %@", file);
    }
}

- (void) _generateFromFile:(NSString*) path 
           ignoreWrongType:(BOOL) ignoreWrongType { 
           
    FLAssertNotNil(path);
    FLAssertIsValidString(path);

// ug - not efficent.
// TODO: don't make a new generator for every file??

    WLCodeGenerator* generator = [WLCodeGenerator codeGenerator];
    [generator loadPlugins];


    FLResourceDescriptor* desc = [FLResourceDescriptor resourceDescriptor:[NSURL fileURLWithPath:path] resourceType:FLResourceDescriptorTypeFile];
    if([generator canGenerateFromResource:desc]) {
        
        FLLog(path);
        
        self.filePath = path;
        FLAssertNotNil(path);


        FLAsyncEventHandler* handler = [FLAsyncEventHandler asyncEventHandler];
        handler.onEvent = ^(FLAsyncEventHandler* theHandler, BOOL success, id result, FLAsyncEventHint hint) {
            
            if(success) {
                [self _outputResults:result];
            }
            else {
                [self onHandleError:result];
            }
        };

        handler.onFinished = ^(FLAsyncEventHandler* theHandler) {
            self.filePath = nil;
        };

        [generator generateCodeFromResource:desc eventHandler:handler];
        
    } 
    else if(!ignoreWrongType) {
        FLLog(@"unknown file type for file:%@", path);
    } 
    else {
        FLLogMedium(@"#   Ignoring file: %@", path);
    }
}

- (void) _generateInDirectory:(NSString*) fromPath recursive:(BOOL) recursive{
    FLLogMedium(@"### Looking for whittle files in: %@", fromPath);

    [[NSFileManager defaultManager] visitEachItemAtPath:fromPath
        recursively:recursive
        visibleItemsOnly:YES 
        visitor:^(NSString* filePath, BOOL* stop) {
            [self _generateFromFile:filePath ignoreWrongType:YES];
        }];
}

- (void) onHandleError:(NSError*) error {
//    FLLog(@"FAILED: \"%@\"", self.filePath); 
//    FLLog(@"Error: \"%@\"", [error localizedDescription]); 
    
    fprintf(stderr, "%s:1:1: fatal error: '%s'\n", 
        [self.filePath cStringUsingEncoding:NSASCIIStringEncoding],
        [[error localizedDescription] cStringUsingEncoding:NSASCIIStringEncoding]);
    
    if(_openFailedFiles) {
        [self openFileInDefaultEditor:self.filePath];
    }
}

- (void) _generateAtPath:(NSString*) startPath  {

    BOOL isDirectory = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:startPath isDirectory:&isDirectory]) {
    
        if(isDirectory) {
            [self _generateInDirectory:startPath recursive:_recursive];
        }
        else {
            [self _generateFromFile:startPath ignoreWrongType:NO];
        }
    }
    else {
        FLThrowErrorCode(FLToolApplicationErrorDomain, FLToolApplicationErrorFileNotFound, @"Path not found: %@", startPath);
    }
}

- (void) _printAtPath:(NSString*) startPath {

    BOOL isDirectory = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:startPath isDirectory:&isDirectory]) {
    
        if(isDirectory) {
            [[NSFileManager defaultManager] visitEachItemAtPath:startPath
                recursively:_recursive
                visibleItemsOnly:YES 
                visitor:^(NSString* filePath, BOOL* stop) {

                    // ug - not efficent.
                    // TODO: don't make a new generator for every file??

                    WLCodeGenerator* generator = [WLCodeGenerator codeGenerator];
                    [generator loadPlugins];

                    if([generator canGenerateFromResource:
                        [FLResourceDescriptor resourceDescriptor:[NSURL fileURLWithPath:filePath] resourceType:FLResourceDescriptorTypeFile]]) {
                        FLLog(filePath);
                    }
                }]; 
        }
        else {
            FLLog(startPath);
        }
    }
    else {
        FLThrowErrorCode(FLToolApplicationErrorDomain, FLToolApplicationErrorFileNotFound, @"Path not found: %@", startPath);
    }
}

- (void) addInputHandlers {

    [self addInputHandler:FLReturnObject(^{
        FLInputHandler* inputHandler = [FLInputHandler inputHandler];
        [inputHandler addInputParameter:@"-i"];
        [inputHandler addInputParameter:@"--input"];
        [inputHandler addCompatibleParameter:@"-r"];
        [inputHandler addCompatibleParameter:@"-g"];
        [inputHandler addCompatibleParameter:@"-o"];

        inputHandler.expectsData = YES;
        inputHandler.helpDescription = @"Path to a directory or a file to whittle. Whittle will find all Whittle files in a dir.";
        inputHandler.onInput = ^(FLInputHandler* handler, id data) {
            if(!FLStringsAreEqual(data, @".")) {    
                FLAssignObject(_optionalPath, data);
            }
        };        
        return inputHandler;
    })];

    [self addInputHandler:FLReturnObject(^{
        FLInputHandler* inputHandler = [FLInputHandler inputHandler];
        [inputHandler addInputParameter:@"-a"];
        [inputHandler addInputParameter:@"--all"];

        [inputHandler addCompatibleParameter:@"-r"];
        [inputHandler addCompatibleParameter:@"-p"];

        inputHandler.helpDescription = @"Generate all whittle files in directory (same as -i . -a).";
        inputHandler.onInput = ^(FLInputHandler* handler, id data) {
        };
        return inputHandler;
    })];


    [self addInputHandler:FLReturnObject(^{
        FLInputHandler* inputHandler = [FLInputHandler inputHandler];
        [inputHandler addInputParameter:@"-p"];
        [inputHandler addInputParameter:@"--print"];
        
        [inputHandler addCompatibleParameter:@"-r"];
        [inputHandler addCompatibleParameter:@"-i"];
        [inputHandler addCompatibleParameter:@"-a"];
        
        inputHandler.helpDescription = @"Print Whittle files to StdOut specified by -i.";
        inputHandler.onInvoke = ^(FLInputHandler* handler, id data) {
            _output = YES;
            [self _printAtPath:_optionalPath];
        };
        return inputHandler;
    })];

    [self addInputHandler:FLReturnObject(^{
        FLInputHandler* inputHandler = [FLInputHandler inputHandler];
        [inputHandler addInputParameter:@"-r"];
        [inputHandler addInputParameter:@"--recursive"];

        [inputHandler addRequiredParameter:@"-i"];

        inputHandler.helpDescription = @"Recursively traverse directories to be whittled (if -i is a dir).";
        inputHandler.onInput = ^(FLInputHandler* handler, id data){
            _recursive = YES;
        };
        return inputHandler;
    })];

    [self addInputHandler:FLReturnObject(^{
        FLInputHandler* inputHandler = [FLInputHandler inputHandler];
        [inputHandler addInputParameter:@"-c"];
        [inputHandler addInputParameter:@"--continue"];

        [inputHandler addCompatibleParameter:@"*"];

        inputHandler.helpDescription = @"Continue whittling if an error is encountered.";
        inputHandler.onInput = ^(FLInputHandler* handler, id data){
            _continue = YES;
        };
        return inputHandler;
    })];

    [self addInputHandler:FLReturnObject(^{
        FLInputHandler* inputHandler = [FLInputHandler inputHandler];
        [inputHandler addInputParameter:@"-o"];
        [inputHandler addInputParameter:@"--open-failed-file"];

        [inputHandler addCompatibleParameter:@"*"];

        inputHandler.helpDescription = @"Open input file in default editor on failure.";
        inputHandler.onInput = ^(FLInputHandler* handler, id data){
            _openFailedFiles = YES;
        };
        return inputHandler;
    })];

    [self addInputHandler:FLReturnObject(^{
        FLInputHandler* inputHandler = [FLInputHandler inputHandler];
        [inputHandler addInputParameter:@"-s"];
        [inputHandler addInputParameter:@"--samples"];

        [inputHandler addCompatibleParameter:@"-r"];
        [inputHandler addCompatibleParameter:@"-i"];
        [inputHandler addCompatibleParameter:@"-a"];

        inputHandler.helpDescription = @"Generate samples";
        inputHandler.onInput = ^(FLInputHandler* handler, id data){
            _samples = YES;
        };
        return inputHandler;
    })];

    [self addInputHandler:FLReturnObject(^{
        FLInputHandler* inputHandler = [FLInputHandler inputHandler];
        [inputHandler addInputParameter:@"-v"];
        [inputHandler addInputParameter:@"--verbose"];
        [inputHandler addCompatibleParameter:FLInputHandlerCompatableWithAll];
        inputHandler.helpDescription = @"Verbose output.";
        inputHandler.onInput = ^(FLInputHandler* handler, id data){
            FLLoggerSetLevel(FLLoggerDefault(), FLLoggerLevelMedium);
        };
        return inputHandler;
    })];

    [self addInputHandler:FLReturnObject(^{
        FLInputHandler* inputHandler = [FLInputHandler inputHandler];
        [inputHandler addInputParameter:@"--whittle-web"];
        inputHandler.helpDescription = @"Opens http://whittle.greentongue.com for more information about Whittle.";
        inputHandler.onInvoke = ^(FLInputHandler* handler, id data) {
            [self openURL:@"http://whittle.greentongue.com" inBackground:NO];
        };
        return inputHandler;
    })];

    [self addInputHandler:FLReturnObject(^{
        FLInputHandler* inputHandler = [FLInputHandler inputHandler];
        [inputHandler addInputParameter:@"--gts-web"];
        inputHandler.helpDescription = @"Opens http://www.greentongue.com for more information about GreenTongue Software.";
        inputHandler.onInvoke = ^(FLInputHandler* handler, id data) {
            [self openURL:@"http://greentongue.com" inBackground:NO];
        };
        return inputHandler;
    })];
  
    [super addInputHandlers];
}

- (void) willInvokeHandlers:(NSDictionary*) handlers {
    [super willInvokeHandlers:handlers];
    if(!_output) {
        [self _generateAtPath:_optionalPath];
    }
}


@end
