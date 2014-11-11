// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YHWHName.h instead.

@import CoreData;

extern const struct YHWHNameAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *normalizedName;
	__unsafe_unretained NSString *romanizedName;
	__unsafe_unretained NSString *smallCaps;
} YHWHNameAttributes;

extern const struct YHWHNameRelationships {
	__unsafe_unretained NSString *nextRelatedName;
	__unsafe_unretained NSString *prevRelatedName;
	__unsafe_unretained NSString *versesWithName;
} YHWHNameRelationships;

@class YHWHName;
@class YHWHName;
@class YHWHVerse;

@interface YHWHNameID : NSManagedObjectID {}
@end

@interface _YHWHName : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) YHWHNameID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* normalizedName;

//- (BOOL)validateNormalizedName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* romanizedName;

//- (BOOL)validateRomanizedName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* smallCaps;

@property (atomic) BOOL smallCapsValue;
- (BOOL)smallCapsValue;
- (void)setSmallCapsValue:(BOOL)value_;

//- (BOOL)validateSmallCaps:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) YHWHName *nextRelatedName;

//- (BOOL)validateNextRelatedName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) YHWHName *prevRelatedName;

//- (BOOL)validatePrevRelatedName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *versesWithName;

- (NSMutableOrderedSet*)versesWithNameSet;

@end

@interface _YHWHName (VersesWithNameCoreDataGeneratedAccessors)
- (void)addVersesWithName:(NSOrderedSet*)value_;
- (void)removeVersesWithName:(NSOrderedSet*)value_;
- (void)addVersesWithNameObject:(YHWHVerse*)value_;
- (void)removeVersesWithNameObject:(YHWHVerse*)value_;

- (void)insertObject:(YHWHVerse*)value inVersesWithNameAtIndex:(NSUInteger)idx;
- (void)removeObjectFromVersesWithNameAtIndex:(NSUInteger)idx;
- (void)insertVersesWithName:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeVersesWithNameAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInVersesWithNameAtIndex:(NSUInteger)idx withObject:(YHWHVerse*)value;
- (void)replaceVersesWithNameAtIndexes:(NSIndexSet *)indexes withVersesWithName:(NSArray *)values;

@end

@interface _YHWHName (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveNormalizedName;
- (void)setPrimitiveNormalizedName:(NSString*)value;

- (NSString*)primitiveRomanizedName;
- (void)setPrimitiveRomanizedName:(NSString*)value;

- (NSNumber*)primitiveSmallCaps;
- (void)setPrimitiveSmallCaps:(NSNumber*)value;

- (BOOL)primitiveSmallCapsValue;
- (void)setPrimitiveSmallCapsValue:(BOOL)value_;

- (YHWHName*)primitiveNextRelatedName;
- (void)setPrimitiveNextRelatedName:(YHWHName*)value;

- (YHWHName*)primitivePrevRelatedName;
- (void)setPrimitivePrevRelatedName:(YHWHName*)value;

- (NSMutableOrderedSet*)primitiveVersesWithName;
- (void)setPrimitiveVersesWithName:(NSMutableOrderedSet*)value;

@end
