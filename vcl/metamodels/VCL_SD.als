--=======================================================================
-- Name: 'VCL_SD'
--
-- Version: 2.3
--
-- Last Change Date: 16/12/2010
--
-- Description:
--    + Defines meta-model of VCL structural diagrams (SDs).
--
-- Change History:
--    + Version 2.0:
--       + Renamed 'SetElement' to 'Object'.
--       + Renamed 'Invariant' to 'Constraint'
--			 + Renamed 'BlobDef' to 'Blob'.
--       + Made signature 'Constant' an extension of 'Object'.
--    + Version 2.1:
--    	+ Introduced BlobInt', 'BlobNat', 'BlobTimeNat' and 'BlobId'.
--      + Introduced 'ValueBlob'
--			+ Signature 'Blob' became abstract
--      + Moved what was in 'Blob' to 'BlobId'
--      + Made 'ValueBlob' and 'DomainBlob' extensions of 'BlobId'
--   + Version 2.2:
--	 		+ removed 'lone' from ProEdge.mult
--      + removed signature 'Edge'
--      + signature 'Constant' extends 'SDElem' rather than 'Object'
--      + added field ''peTarget' to 'PropEdge' signature
--      + renamed 'Constant.belongsTo' to 'Constant.type'  
--   + Version 2.3:
--      + Defined 'BlobKind' enumeration for 'Domain' and 'Value' blob.
--   + Version 2.4:
--      + Renamed 'Constraint' to 'Assertion'.
--			+ Added the constraint 'one' to signatures of 'IntBlob', 
-- 			'TimeNatBlob' and 'NatBlob'.
--========================================================================

module VCL_SD

open VCL_Common as c 
open VCL_Mult as m 

--=========================================================================
-- Name: 'YesNo'
--
-- Description:
--    + Signature of all 'Yes', 'No' atoms.
--=========================================================================

abstract sig YesNo {}

one sig Yes, No extends YesNo {}

--=========================================================================
-- Name: 'SDElem'
--
-- Description:
--    + Introduces the labelled structural diagram element.
--    + To be extended by 'Blob', 'Object', 'Edge' and constraint. 
--
--   -----------         ------
--   |SDElem   |-------->|Name|
--   -----------   name  ------
--
-- The subsetting structure underlying 'SDElem'.
-- ----------------------------------------------------|
-- | SDElem                                            |
-- | ----------------------|                           |
-- | | Node                |                           |
-- | | |-------| |--------|| |------------| |---------||
-- | | | Blob  | | Object || | Constraint | | Constant|| 
-- | | |-------| |--------|| |------------| |---------||
-- | | --------------------|                           |
-- | ---------------------------------------------------
--=========================================================================

--
-- A modelling element may be labelled with a Name.
-- Modelling elements are subdivided into 'Node' and 'Edge'
abstract sig SDElem {
   name  : Name -- a modelling element has a name (a label).
}


--============================================================================
-- Name: 'Assertion'
--
-- Description:
--    + Assertion can be connected to some blob (local invariant)
--       + related to 'Blob' through relation 'lInvariants'
--    + Or they can stand alone (global invariants)
--============================================================================

sig Assertion extends SDElem {
}

--=======================================================================
-- Name: 'Constant'
--
-- Description:
--    + Represents constants. A constant has a type (field 'type).
--    + Constants can be 'local' or 'global'.
--======================================================================

sig Constant extends SDElem {
   type : Name
}

--============================================================================
-- Name: 'Node'
--
-- Description:
--    + Nodes of VCL graphs structures.  
--    + To be extended by blob and object.
--============================================================================

abstract sig Node extends SDElem {
}

--=======================================================================
-- Name: 'Object'
--
-- Description:
--    + The elements that can be inside a blob (defined as enumeration). 
--    + To be extended by constants.
--======================================================================

sig Object extends Node {
}

--
-- Objects must be inside one blob (one blob only) 
fact ObjectsInsideOneBlob {
   all o : (Object) | one hasInside.o
}



--=============================================================
-- Name: 'RelEdge' (Relational Edge)
--
-- Description: 
--    + Blob relational edges are binary edges connecting blobs.
--    + They have multiplicities at each end of edge.
--=============================================================

sig RelEdge extends SDElem {
	 source, target : Blob,
   sourceMult, targetMult : Mult,
} 


--=========================================================================
-- Name: 'Blob' (Blob Definitions)
--
-- Description: 
--    + Defines a global blob definition. 
--    + It's characterised by inside property. 
--
--=========================================================================

abstract sig Blob extends Node {
}

--
-- This is a well-formedness constraint to rule out redundant definitons!
-- The transitive constructions on the blob relation are unnecessary because 
-- they can be obtained through the transitive closure
--fact insideTransitiveIsRedundant {
---  all n1, n2, n3 : Node | n1->n2 in hasInside && n3 in n2.^hasInside
--      => !(n1->n3 in hasInside)
--}

--=========================================================================
-- Name: 'IntBlob' (Integer Blob)
--
-- Description: 
--    + Defines a blob representing the integers
--=========================================================================
one sig IntBlob extends Blob {}

--=========================================================================
-- Name: 'NatBlob' (Natural numbers Blob)
--
-- Description: 
--    + Defines a blob representing the natural numbers
--=========================================================================
one sig NatBlob extends Blob {}

--=========================================================================
-- Name: 'TimeNatBlob' (Time as Natural numbers Blob)
--
-- Description: 
--    + Defines a blob representing time as natural numbers
--=========================================================================
one sig TimeNatBlob extends Blob {}

abstract sig BlobKind {}

--=========================================================================
-- Name: 'Value', 'Domain' 
--
-- Description: 
--    + Defines two blob kinds: 'value' and 'domain.      
--=========================================================================

one sig Value, Domain extends BlobKind {}


--=========================================================================
-- Name: 'BlobId' (Blob  with an identifier)
--
-- Description: 
--    + Defines a blob with an identifier 
--
--   ---------      0..*    ---------
--   |BlobId |------------->| Node  |
--   ---------    hasInside ---------
--     | |  |            0..*---------          
--     | |  |-------------->|PropEdge|
--     | |           lProps ----------
--     | |               0..*------------          
--     | |------------------>|Constraint|
--     |         lInvariants ------------
--     |                 0..*-----------  
--     |-------------------->|Constant |
--               lConstants  -----------  
--=========================================================================
abstract sig BlobId extends Blob {
   kind         : BlobKind,
   isDefBlob    : YesNo,
	 hasInside    : set Node,
   lProps       : set PropEdge,
	 lInvariants  : set Assertion,
   lConstants   : set Constant,
}
--
-- The following defines what it means for VCL structures to be well-formed 
-- regarding the 'inside' property.

--
-- The graph representing the 'inside' relation should be acyclic. 
fact acyclicInside {
   no ^hasInside & iden
}

--
-- A node should be in at most one blob (the inverse of the relation is a partial function)
fact inAtMostOneBlob {
	all n : Node | lone n.~hasInside
}

--
-- Each 'Blob' has its own set of local invariants.
-- Or local invariants are not shared.
fact LInvariantsNotShared {
   all c : Assertion | (some lInvariants.c) 
      =>  one lInvariants.c
}

--
-- Each 'Blob' has its own set of local constants
-- Or local constants are not shared.
fact LConstantsNotShared {
   all c : Constant | (some lConstants.c) 
      =>  one lConstants.c
}

-- Definitional blobs must have things inside.
fact DefBlobsHasThingsInside {
    all b : isDefBlob.Yes | #b.hasInside > 0
}


--
-- Each domain blob can contain other domain blobs obly
-- and they can be inside of domain blobs only.
fact DBlobHasDBlobsInside {
   all b : BlobId | b.kind = Domain
      => (b.hasInside) in kind.Domain && hasInside.b in kind.Domain
}


--=========================================================================
-- Name: 'PropEdge' (Property Edges)

-- Description:
--    + Property edges define properties of blobs. 
--    + They relate one blob (having property) to another (type of property).
--    + A property edge has a 'Blob' as target.
--    + A property edge may have a multiplicity.
--
--   ----------          0..*-------
--   |PropEdge|------------->|Blob |
--   ----------       target -------
--=========================================================================

sig PropEdge extends SDElem {
	 peTarget : Blob,
   mult : Mult
}
{  
   -- a property edge cannot have its blob or one of the blobs inside has target
   not (peTarget in ((this.~lProps) + (this.~lProps).^hasInside))
}
 
--
-- Each 'Blob' has its own set of property edges
-- Or property edges are not shared. All property edges belong to some blob
fact propEdgesNotSharedAndBelongToSomeBlob {
   all pe : PropEdge | one lProps.pe
}

--
-- Local Names in the scope of a 'Blob'must be unique
--
fact localNamesAreUnique {
	all b : Blob |
		all sde1, sde2 : (b.lConstants+b.lInvariants+b.lProps+(b.^hasInside & Object)) 
			| sde1.name = sde2.name
	       =>  sde1 = sde2
}

--
-- All global names must be unique
fact BlobAndConstraintNamesAreUnique {
   all n : (Blob+(Assertion-(BlobId.lInvariants))+RelEdge+(Constant-(BlobId.lConstants))).name 
	 | one n.~name  
}
