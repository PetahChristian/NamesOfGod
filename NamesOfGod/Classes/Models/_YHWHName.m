// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YHWHName.m instead.

#import "_YHWHName.h"

const struct YHWHNameAttributes YHWHNameAttributes = {
	.name = @"name",
	.normalizedName = @"normalizedName",
	.romanizedName = @"romanizedName",
	.smallCaps = @"smallCaps",
};

const struct YHWHNameRelationships YHWHNameRelationships = {
	.nextRelatedName = @"nextRelatedName",
	.prevRelatedName = @"prevRelatedName",
	.versesWithName = @"versesWithName",
};

@implementation YHWHNameID
@end

@implementation _YHWHName

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"YHWHName" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"YHWHName";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"YHWHName" inManagedObjectContext:moc_];
}

- (YHWHNameID*)objectID {
	return (YHWHNameID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"smallCapsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"smallCaps"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic name;

@dynamic normalizedName;

@dynamic romanizedName;

@dynamic smallCaps;

- (BOOL)smallCapsValue {
	NSNumber *result = [self smallCaps];
	return [result boolValue];
}

- (void)setSmallCapsValue:(BOOL)value_ {
	[self setSmallCaps:@(value_)];
}

- (BOOL)primitiveSmallCapsValue {
	NSNumber *result = [self primitiveSmallCaps];
	return [result boolValue];
}

- (void)setPrimitiveSmallCapsValue:(BOOL)value_ {
	[self setPrimitiveSmallCaps:@(value_)];
}

@dynamic nextRelatedName;

@dynamic prevRelatedName;

@dynamic versesWithName;

- (NSMutableOrderedSet*)versesWithNameSet {
	[self willAccessValueForKey:@"versesWithName"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"versesWithName"];

	[self didAccessValueForKey:@"versesWithName"];
	return result;
}

@end

@implementation _YHWHName (VersesWithNameCoreDataGeneratedAccessors)
- (void)addVersesWithName:(NSOrderedSet*)value_ {
	[self.versesWithNameSet unionOrderedSet:value_];
}
- (void)removeVersesWithName:(NSOrderedSet*)value_ {
	[self.versesWithNameSet minusOrderedSet:value_];
}
- (void)addVersesWithNameObject:(YHWHVerse*)value_ {
	[self.versesWithNameSet addObject:value_];
}
- (void)removeVersesWithNameObject:(YHWHVerse*)value_ {
	[self.versesWithNameSet removeObject:value_];
}
- (void)insertObject:(YHWHVerse*)value inVersesWithNameAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"versesWithName"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self versesWithName]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"versesWithName"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"versesWithName"];
}
- (void)removeObjectFromVersesWithNameAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"versesWithName"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self versesWithName]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"versesWithName"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"versesWithName"];
}
- (void)insertVersesWithName:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"versesWithName"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self versesWithName]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"versesWithName"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"versesWithName"];
}
- (void)removeVersesWithNameAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"versesWithName"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self versesWithName]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"versesWithName"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"versesWithName"];
}
- (void)replaceObjectInVersesWithNameAtIndex:(NSUInteger)idx withObject:(YHWHVerse*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"versesWithName"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self versesWithName]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"versesWithName"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"versesWithName"];
}
- (void)replaceVersesWithNameAtIndexes:(NSIndexSet *)indexes withVersesWithName:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"versesWithName"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self versesWithName]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"versesWithName"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"versesWithName"];
}
@end

