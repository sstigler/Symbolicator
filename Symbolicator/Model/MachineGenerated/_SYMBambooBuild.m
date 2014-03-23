// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SYMBambooBuild.m instead.

#import "_SYMBambooBuild.h"

const struct SYMBambooBuildAttributes SYMBambooBuildAttributes = {
	.number = @"number",
	.status = @"status",
};

const struct SYMBambooBuildRelationships SYMBambooBuildRelationships = {
	.artifacts = @"artifacts",
	.plan = @"plan",
};

const struct SYMBambooBuildFetchedProperties SYMBambooBuildFetchedProperties = {
};

@implementation SYMBambooBuildID
@end

@implementation _SYMBambooBuild

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BambooBuild" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BambooBuild";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BambooBuild" inManagedObjectContext:moc_];
}

- (SYMBambooBuildID*)objectID {
	return (SYMBambooBuildID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"numberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"number"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic number;



- (int32_t)numberValue {
	NSNumber *result = [self number];
	return [result intValue];
}

- (void)setNumberValue:(int32_t)value_ {
	[self setNumber:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveNumberValue {
	NSNumber *result = [self primitiveNumber];
	return [result intValue];
}

- (void)setPrimitiveNumberValue:(int32_t)value_ {
	[self setPrimitiveNumber:[NSNumber numberWithInt:value_]];
}





@dynamic status;






@dynamic artifacts;

	
- (NSMutableSet*)artifactsSet {
	[self willAccessValueForKey:@"artifacts"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"artifacts"];
  
	[self didAccessValueForKey:@"artifacts"];
	return result;
}
	

@dynamic plan;

	






@end
