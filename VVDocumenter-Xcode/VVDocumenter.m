//
//  VVDocumenter.m
//  VVDocumenter-Xcode
//
//  Created by 王 巍 on 13-7-17.
//  Copyright (c) 2013年 OneV's Den. All rights reserved.
//

#import "VVDocumenter.h"
#import "NSString+VVSyntax.h"
#import "VVCommenter.h"

@interface VVDocumenter()

@property (nonatomic, copy) NSString *code;

@end

@implementation VVDocumenter

-(id) initWithCode:(NSString *)code
{
    self = [super init];
    if (self) {
        //Trim the space around the braces
        //Then trim the new line character
        self.code = [[code stringByReplacingRegexPattern:@"\\s*(\\(.*\?\\))\\s*" withString:@"$1"]
                           stringByReplacingRegexPattern:@"\\s*\n\\s*"           withString:@" "];
        
    }
    return self;
}

-(NSString *) baseIndentation
{
    NSArray *matchedSpaces = [self.code stringsByExtractingGroupsUsingRegexPattern:@"^(\\s*)"];
    if (matchedSpaces.count > 0) {
        return matchedSpaces[0];
    } else {
        return @"";
    }
}

-(NSString *) document
{
    NSString *trimCode = [self.code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *baseIndent = [self baseIndentation];
    
    VVBaseCommenter *commenter = nil;
    if ([trimCode isObjCMethod]) {
        commenter = [[VVMethodCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isProperty]) {
        commenter = [[VVPropertyCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isCFunction]) {
        commenter = [[VVFunctionCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isMacro]) {
        commenter = [[VVMacroCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isStruct]) {
        commenter = [[VVStructCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isUnion]) {
        commenter = [[VVStructCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else if ([trimCode isEnum]) {
        commenter = [[VVEnumCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    } else {
        commenter = [[VVVariableCommenter alloc] initWithIndentString:baseIndent codeString:trimCode];
    }

    return [commenter document];
}



@end
