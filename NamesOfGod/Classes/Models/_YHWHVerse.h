// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YHWHVerse.h instead.

@import CoreData;

extern const struct YHWHVerseAttributes {
	__unsafe_unretained NSString *bcv;
	__unsafe_unretained NSString *reference;
	__unsafe_unretained NSString *textESV;
	__unsafe_unretained NSString *textKJV;
	__unsafe_unretained NSString *textNASB;
	__unsafe_unretained NSString *textNIV;
	__unsafe_unretained NSString *textNKJV;
	__unsafe_unretained NSString *textNLT;
} YHWHVerseAttributes;

extern const struct YHWHVerseRelationships {
	__unsafe_unretained NSString *namesWithinVerse;
} YHWHVerseRelationships;

@class YHWHName;

@interface YHWHVerseID : NSManagedObjectID {}
@end

@interface _YHWHVerse : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) YHWHVerseID* objectID;

@property (nonatomic, strong) NSNumber* bcv;

@property (atomic) int32_t bcvValue;
- (int32_t)bcvValue;
- (void)setBcvValue:(int32_t)value_;

//- (BOOL)validateBcv:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* reference;

//- (BOOL)validateReference:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* textESV;

//- (BOOL)validateTextESV:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* textKJV;

//- (BOOL)validateTextKJV:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* textNASB;

//- (BOOL)validateTextNASB:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* textNIV;

//- (BOOL)validateTextNIV:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* textNKJV;

//- (BOOL)validateTextNKJV:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* textNLT;

//- (BOOL)validateTextNLT:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *namesWithinVerse;

- (NSMutableSet*)namesWithinVerseSet;

@end

@interface _YHWHVerse (NamesWithinVerseCoreDataGeneratedAccessors)
- (void)addNamesWithinVerse:(NSSet*)value_;
- (void)removeNamesWithinVerse:(NSSet*)value_;
- (void)addNamesWithinVerseObject:(YHWHName*)value_;
- (void)removeNamesWithinVerseObject:(YHWHName*)value_;

@end

@interface _YHWHVerse (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveBcv;
- (void)setPrimitiveBcv:(NSNumber*)value;

- (int32_t)primitiveBcvValue;
- (void)setPrimitiveBcvValue:(int32_t)value_;

- (NSString*)primitiveReference;
- (void)setPrimitiveReference:(NSString*)value;

- (NSString*)primitiveTextESV;
- (void)setPrimitiveTextESV:(NSString*)value;

- (NSString*)primitiveTextKJV;
- (void)setPrimitiveTextKJV:(NSString*)value;

- (NSString*)primitiveTextNASB;
- (void)setPrimitiveTextNASB:(NSString*)value;

- (NSString*)primitiveTextNIV;
- (void)setPrimitiveTextNIV:(NSString*)value;

- (NSString*)primitiveTextNKJV;
- (void)setPrimitiveTextNKJV:(NSString*)value;

- (NSString*)primitiveTextNLT;
- (void)setPrimitiveTextNLT:(NSString*)value;

- (NSMutableSet*)primitiveNamesWithinVerse;
- (void)setPrimitiveNamesWithinVerse:(NSMutableSet*)value;

@end
