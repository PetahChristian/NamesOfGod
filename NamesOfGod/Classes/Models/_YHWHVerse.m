// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YHWHVerse.m instead.

#import "_YHWHVerse.h"

const struct YHWHVerseAttributes YHWHVerseAttributes = {
	.bcv = @"bcv",
	.reference = @"reference",
	.textESV = @"textESV",
	.textKJV = @"textKJV",
	.textNASB = @"textNASB",
	.textNIV = @"textNIV",
	.textNKJV = @"textNKJV",
	.textNLT = @"textNLT",
};

const struct YHWHVerseRelationships YHWHVerseRelationships = {
	.namesWithinVerse = @"namesWithinVerse",
};

@implementation YHWHVerseID
@end

@implementation _YHWHVerse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"YHWHVerse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"YHWHVerse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"YHWHVerse" inManagedObjectContext:moc_];
}

- (YHWHVerseID*)objectID {
	return (YHWHVerseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"bcvValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"bcv"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic bcv;

- (int32_t)bcvValue {
	NSNumber *result = [self bcv];
	return [result intValue];
}

- (void)setBcvValue:(int32_t)value_ {
	[self setBcv:@(value_)];
}

- (int32_t)primitiveBcvValue {
	NSNumber *result = [self primitiveBcv];
	return [result intValue];
}

- (void)setPrimitiveBcvValue:(int32_t)value_ {
	[self setPrimitiveBcv:@(value_)];
}

@dynamic reference;

@dynamic textESV;

@dynamic textKJV;

@dynamic textNASB;

@dynamic textNIV;

@dynamic textNKJV;

@dynamic textNLT;

@dynamic namesWithinVerse;

- (NSMutableSet*)namesWithinVerseSet {
	[self willAccessValueForKey:@"namesWithinVerse"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"namesWithinVerse"];

	[self didAccessValueForKey:@"namesWithinVerse"];
	return result;
}

@end

