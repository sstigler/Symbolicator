// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooProject.h instead.

#import <CoreData/CoreData.h>
#import "MMRecord.h"

extern const struct SYMBambooProjectAttributes {
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *name;
} SYMBambooProjectAttributes;

extern const struct SYMBambooProjectRelationships {
	__unsafe_unretained NSString *plans;
	__unsafe_unretained NSString *server;
} SYMBambooProjectRelationships;

extern const struct SYMBambooProjectFetchedProperties {
} SYMBambooProjectFetchedProperties;

@class SYMBambooPlan;
@class SYMBambooServer;




@interface SYMBambooProjectID : NSManagedObjectID {}
@end

@interface _SYMBambooProject : MMRecord {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SYMBambooProjectID*)objectID;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *plans;

- (NSMutableSet*)plansSet;




@property (nonatomic, strong) SYMBambooServer *server;

//- (BOOL)validateServer:(id*)value_ error:(NSError**)error_;





@end

@interface _SYMBambooProject (CoreDataGeneratedAccessors)

- (void)addPlans:(NSSet*)value_;
- (void)removePlans:(NSSet*)value_;
- (void)addPlansObject:(SYMBambooPlan*)value_;
- (void)removePlansObject:(SYMBambooPlan*)value_;

@end

@interface _SYMBambooProject (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitivePlans;
- (void)setPrimitivePlans:(NSMutableSet*)value;



- (SYMBambooServer*)primitiveServer;
- (void)setPrimitiveServer:(SYMBambooServer*)value;


@end
