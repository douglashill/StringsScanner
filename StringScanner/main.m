//
//  main.m
//  StringScanner
//
//  Created by Douglas Hill on 22/06/2013.
//  Copyright (c) 2013 Douglas Hill. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSScanner (DHAdditions)

- (BOOL)scanPastString:(NSString *)stopString;
- (BOOL)scanPastString:(NSString *)stopString intoString:(NSString **)outString;
- (BOOL)scanBetweenString:(NSString *)startString andString:(NSString *)endString intoString:(NSString **)outString;

@end

@implementation NSScanner (DHAdditions)

- (BOOL)scanPastString:(NSString *)stopString
{
	return [self scanPastString:stopString intoString:NULL];
}

- (BOOL)scanPastString:(NSString *)stopString intoString:(NSString **)outString;
{
	[self scanUpToString:stopString intoString:outString];
	return [self scanString:stopString intoString:NULL];
}

- (BOOL)scanBetweenString:(NSString *)startString andString:(NSString *)endString intoString:(NSString **)outString
{
	[self scanPastString:startString];
	return [self scanPastString:endString intoString:outString];
}

@end



int main(int argc, const char * argv[])
{
	@autoreleasepool {
		
		NSString *file = [NSString stringWithContentsOfFile:@"/Users/Douglas/Desktop/Localizable.strings" usedEncoding:NULL error:NULL];
		NSScanner *scanner = [NSScanner scannerWithString:file];
		
		while ([scanner isAtEnd] == NO) {
			NSString *comment;
			NSString *key;
			NSString *value;
			
			[scanner scanBetweenString:@"/*" andString:@"*/" intoString:&comment];
			comment = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			[scanner scanBetweenString:@"\"" andString:@"\"" intoString:&key];
			BOOL equalsCorrect = [scanner scanString:@"=" intoString:NULL];
			[scanner scanBetweenString:@"\"" andString:@"\"" intoString:&value];
			BOOL terminatorCorrect = [scanner scanString:@";" intoString:NULL];
			
			if ([comment isEqualToString:key] || [comment isEqualToString:value])
				NSLog(@"%@ : %@ (%d, %d)", key, value, equalsCorrect, terminatorCorrect);	
			else
				NSLog(@"%@ : %@ (%@, %d, %d)", key, value, comment, equalsCorrect, terminatorCorrect);
		}
		
	}
    return 0;
}

