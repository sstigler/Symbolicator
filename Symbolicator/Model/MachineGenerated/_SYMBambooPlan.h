// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooPlan.h instead.

#import <CoreData/CoreData.h>


extern const struct SYMBambooPlanAttributes {
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *name;
} SYMBambooPlanAttributes;

extern const struct SYMBambooPlanRelationships {
	__unsafe_unretained NSString *builds;
	__unsafe_unretained NSString *project;
} SYMBambooPlanRelationships;

extern const struct SYMBambooPlanFetchedProperties {
} SYMBambooPlanFetchedProperties;

@class SYMBambooBuild;
@class SYMBambooProject;




@interface SYMBambooPlanID : NSManagedObjectID {}
@end

@interface _SYMBambooPlan : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SYMBambooPlanID*)objectID;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *builds;

- (NSMutableSet*)buildsSet;




@property (nonatomic, strong) SYMBambooProject *project;

//- (BOOL)validateProject:(id*)value_ error:(NSError**)error_;





@end

@interface _SYMBambooPlan (CoreDataGeneratedAccessors)

- (void)addBuilds:(NSSet*)value_;
- (void)removeBuilds:(NSSet*)value_;
- (void)addBuildsObject:(SYMBambooBuild*)value_;
- (void)removeBuildsObject:(SYMBambooBuild*)value_;

@end

@interface _SYMBambooPlan (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveBuilds;
- (void)setPrimitiveBuilds:(NSMutableSet*)value;



- (SYMBambooProject*)primitiveProject;
- (void)setPrimitiveProject:(SYMBambooProject*)value;


@end
