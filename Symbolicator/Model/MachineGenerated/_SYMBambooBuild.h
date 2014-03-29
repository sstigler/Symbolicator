// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooBuild.h instead.

#import <CoreData/CoreData.h>
#import "MMRecord.h"

extern const struct SYMBambooBuildAttributes {
	__unsafe_unretained NSString *number;
	__unsafe_unretained NSString *status;
} SYMBambooBuildAttributes;

extern const struct SYMBambooBuildRelationships {
	__unsafe_unretained NSString *artifacts;
	__unsafe_unretained NSString *plan;
} SYMBambooBuildRelationships;

extern const struct SYMBambooBuildFetchedProperties {
} SYMBambooBuildFetchedProperties;

@class SYMBambooArtifact;
@class SYMBambooPlan;




@interface SYMBambooBuildID : NSManagedObjectID {}
@end

@interface _SYMBambooBuild : MMRecord {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SYMBambooBuildID*)objectID;





@property (nonatomic, strong) NSNumber* number;



@property int32_t numberValue;
- (int32_t)numberValue;
- (void)setNumberValue:(int32_t)value_;

//- (BOOL)validateNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* status;



//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *artifacts;

- (NSMutableSet*)artifactsSet;




@property (nonatomic, strong) SYMBambooPlan *plan;

//- (BOOL)validatePlan:(id*)value_ error:(NSError**)error_;





@end

@interface _SYMBambooBuild (CoreDataGeneratedAccessors)

- (void)addArtifacts:(NSSet*)value_;
- (void)removeArtifacts:(NSSet*)value_;
- (void)addArtifactsObject:(SYMBambooArtifact*)value_;
- (void)removeArtifactsObject:(SYMBambooArtifact*)value_;

@end

@interface _SYMBambooBuild (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveNumber;
- (void)setPrimitiveNumber:(NSNumber*)value;

- (int32_t)primitiveNumberValue;
- (void)setPrimitiveNumberValue:(int32_t)value_;




- (NSString*)primitiveStatus;
- (void)setPrimitiveStatus:(NSString*)value;





- (NSMutableSet*)primitiveArtifacts;
- (void)setPrimitiveArtifacts:(NSMutableSet*)value;



- (SYMBambooPlan*)primitivePlan;
- (void)setPrimitivePlan:(SYMBambooPlan*)value;


@end
