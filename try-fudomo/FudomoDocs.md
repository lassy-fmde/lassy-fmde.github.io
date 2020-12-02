# Overview
## What is Fudomo?
* FUDOMO is the acronym of
  * FUnctional Decomposition over Object MOdels
* FUDOMO is
  * An example-driven approach to model-to-text transformation
  * A language for describing functional decomposition over object models
  * A web-based tool
## Technology Pillars of FUDOMO
* EDM (example driven modeling) to infer metamodel from examples
* OYAML: a notation for example modeling (in terms of object models)
* The FUDOMO language to specify functional decomposition over object models
* The FUDOMO tool
  * Editors: OYAML, FUDOMO, Javascript/Python
  * Validations: OYAML syntax, conformance of object models to metamodel, FUDOMO syntax, correspondence between transformation model and code
  * Code generation that generates transformation function code skeletons in target language (Javascript or Python)
  * Execute transformation on object models and preview transformation results
## What is EDM?
* Example Driven Modeling (EDM) is a modeling approach that explicitly and systematically uses examples together with abstraction, during all phases of software development, for capturing, communicating, validating, and comprehending domain knowledge.
* FUDOMO exploits EDM (abstraction inference) to infer metamodels from example object models.
## FUDOMO Tool
* The FUDOMO tool is web-based
* Take a look [here](https://fudomo.uni.lu/try-fudomo)
# OYAML
## What is OYAML?
* A notation for object modeling
* A sub-language of YAML with native support for OO concepts: objects, attributes, references, etc.
* Textual, lightweight, human-understandable and machine-readable
* OYAML files have “.yaml” as extension (like YAML files)
## YAML in a Nutshell
* YAML (YAML Ain't Markup Language) is a human friendly data serialization language
* Broadly used for programming related tasks:
  * configuration files
  * internet messaging
  * object persistence
* [YAML 1.2 documentation](https://yaml.org/spec/1.2/spec.html)
## YAML in a Nutshell (2)
*YAML organizes data into different levels
* Levels of data are marked by indentation:
  * Data at the same level are aligned to the left with the same indentation
  * Use spaces instead of tab for indentation
  * You can use any number of spaces to indicate one level of indentation
* YAML supports the following data structures:
  * Scalars
  * Mappings
  * Sequences
## YAML Scalars
* Scalar values (scalars in short) are the most basic and indivisible data items
* Scalar types and example scalar values:
  * String: Paul, Cat
  * Boolean: True, False
  * Integer: 5, 8
  * Floating Point: 3.14159, 314159e-05
## YAML Mappings
* A mapping is a set of key: value pairs
* Note:
  * use a colon and space (“:␣”) to mark each key: value pair
  * each key: value pair starts on its own line
* Example:
  ```yaml
  lastName: Smith
  firstName: Paul
  age: 18
  isMarried: False
  ```
* Translate into JavaScript dictionary:
  ```javascript
  { lastName: 'Smith',
    firstName: 'Paul',
    age: 18,
    isMarried: false }
  ```
## YAML Sequences
* A sequence is a list of data
* Note: use a dash and a space ( “-␣”) to indicate each entry/element in the sequence
* Example:
  ```yaml
  - Cat
  - Dog
  - Goldfish
  ```
* Translate into JavaScript array:
  ```javascript
  [ 'Cat', 'Dog', 'Goldfish' ]
  ```
## YAML Complex Structures
* Sequences and mappings can be nested
* Example:
  ```yaml
  # dictionary with two keys
  # value for first key is sequence
  # value for the second key is dictionary
  languages:
   - YAML
   - Ruby
   - Perl
   - Python
  websites:
   YAML: yaml.org
   Ruby: ruby-lang.org
   Python: python.org
   Perl: use.perl.org
   ```
## YAML Complex Structures (2)
* Translate into JavaScript:
  ```javascript
  { languages: ['YAML', 'Ruby', 'Perl', 'Python' ],
    websites:
     { YAML: 'yaml.org',
       Ruby: 'ruby-lang.org',
       Python: 'python.org',
       Perl: 'use.perl.org' }
  }
  ```
## From YAML to OYAML
* OYAML is a sub-language of YAML for object modeling
* Top level data structure must be a sequence.
* Each element of the top level sequence represents an object.
* An object is represented by a singleton mapping: “key:␣value”, where
  * "key" indicates the type (and optionally the id) of the object, when the id is present, type and id are separated by a space, namely “type␣id” (Note: types must start with  upper case letter.)
  * "value" gives the content of the object
## Simple Objects in OYAML
* OYAML supports two kinds of objects.
* Simple object: the value of a simple object is a scalar value
* Example:
  ```yaml
  Section: Related Work
  ```
## Composite Objects in OYAML
* Composite object: the value of the object is captured by a sequence.
* Elements of the sequence can be either:
  * an attribute mapping:
      attributeName : attributeValue, where attributeValue is a scalar value
  * a reference mapping:
      referenceName >: referenceValue, where referenceValue is a comma-separated list of object id’s
    Note: attribute and reference names must _start with lower case letter_.
  * a contained object (simple or composite)
## OYAML Example: familySmith.yaml
```
  - Address add0001: 1 route de Luxembourg, L-1234 Belval
  - Family smith:
    - familyName: Smith
    - address >: add0001
    - Member jim:
      - firstName: Jim
      - age: 45
    - Member cindy:
      - firstName: Cindy
      - age: 40
    - Member toby:
        - firstName: Toby
        - age: 12
```
# The FUDOMO Language
## Introduction
* We can view a transformation as a mathematical function
* Let M denote a set of object models (or “examples”), let R denote the set of possible transformation outputs (e.g., strings)
* We can then view transformation t as a function with domain M and range R:
  t: M → R
* Key idea underlying Fudomo language
  * Decompose the transformation function into simpler function
* This is called __functional decomposition__
## Functional Decomposition
* From Wikipedia
  * In mathematics, functional decomposition is the process of resolving a functional relationship into its constituent parts in such a way that the original function can be reconstructed (i.e., recomposed) from those parts by function composition.
* For transformation function t:
  * t(M) = F(g1(M),…,gk(M))
    * t is decomposed into functions g1,…,gk
  * We call F the __decomposition function__
  * Note that the values of g1(M),...,gk(M) determine the value of t(M)
## Typed Functions
* We shall assume that all functions are defined in the context of a given type
  * Similar to OCL functions and Java methods
* We can represent a function for type T as a mathematical function having two parameters:
  * the object model and a particular object of type T in this object model
* We denote a function f for type T by: T.f(M,x)
* __Example__: suppose the object model represents a Family with its members. Then we could define a function Family.f that counts the number of members contained in this Family.
## Root Type
* We shall assume that each object model has a single object of type Root from which all other objects can be reached via containment links
* This assumption allows us to view the _main transformation function_ t as a _typed function_ for type Root
* For this reason we denote the transformation function by: Root.t
* Example: the family model contains a Root object in which all Family objects are contained.
## Describing Transformations
* The FUDOMO language allows us to write a transformation as a sequence of (functional) decompositions
  * We call this sequence the FUDOMO model
* Each decomposition will have as left-hand side the typed function that is decomposed, and as right-hand side a comma-separated list of the functions it is decomposed into
* Thus a decomposition will look like this:
  T.f: g1, …, gk // Note that LHS and RHS are separated by a colon
## Hello World!
* The simplest case for a transformation function Root.t is for it to return a constant value (independent of the object model)
* This function does not need to be decomposed which we write as follows:
  ```
Root.t:	// RHS is empty since no decomposition is needed
  ```
* The decomposition function F returns a value that does not depend on the model
* In mathematical notation: Root.t(M,x) = F() = “Hello world” (e.g.)
## A Hybrid Transformation Approach
* FUDOMO is a hybrid transformation approach in the sense that the transformation is represented by
  * The FUDOMO model consisting of the sequence of decompositions
  * Code representing the implementation of the decomposition functions
    * Goal is to allow implementations in common programming languages
    * Currently Javascript and Python are supported
## Back to Hello World!
* For the Hello World transformation:
  * FUDOMO Model:
    ```
  Root.t:
    ```
  * Javascript Code:
    ```javascript
    module.exports = {
      /**
       * Root.t:
       */
      Root_t: function() {
        return "Hello world!"; // generated
      },
    };
    ```
## family2names Transformation
* Let us look at a less trivial example
* Example Input:
  ```yaml
  - Family:
    - familyName: Smith
  - Family:
    - familyName: March
  - Family:
    - familyName: Rafton
  ```
* Desired Output:
  * output comma-separated list of family names
  * In this case:
  ```
Smith, March, Rafton
  ```
## Functional Decomposition
* Call the transformation function that produces the desired output _names_
* We need to decompose typed function _Root.names_
* Note that the value of _Root.names_ is determined by the names of all families contained in the _Root_ object
* To represent this as  functional decomposition, the notion of __forward function__ will be useful
## Forward Function
* Fix types A and B and reference r
* Denote by A.(r→B.g) the typed function for A defined as follows:
    A.(r→B.g)(M,x) = <g(M,b1,),…,g(M,bk)>
  where b1,…,bk are the objects of type B that x refers to via reference r and the angle brackets denote a sequence.
We call it the  forward function (for reference r and type A)
## Back to family2names
* Recall that the value of _Root.names_ is determined by the values of the familyName attribute for each family contained in the root
* In other words: _Root.names_ is determined by forward function
	Root.(cont→Family.familyName)
* We write this in the Fudomo model as follows:
  ```
  Root.names: cont → Family.familyName
  ```
* Note that we write “cont → Family.familyName” on the RHS instead of “Root.(cont → Family.name)” because the context _Root_ is clear from the LHS
* How about the _Family.familyName_ typed function? Does it need to be decomposed further?
* No, because _familyName_ is an attribute of _Family_ so this “function” can be directly looked up in the object model.
## family2names: Solution
* Let us summarize the solution for the family2names transformation:
  * FUDOMO Model:
    ```
    Root.names: cont -> Family.familyName
    ```
  * Javascript Code:
    ```javascript
    module.exports = {
      /**
       * Root.names:
       * @param cont_Family_familyName {Array} The sequence of "familyName" values of Family objects contained in this Root
       */
      Root_names: function(cont_Family_familyName) {
        return cont_Family_familyName.join(', ') + '\n';
      }
    };
    ```
## Next Example: family2persons
* The next transformation, named _family2persons_, drives the complexity one notch up.
* Example input:
  ```yaml
  - Family:
    - lastName: March
    - Member:
       - firstName: Jim
       - sex: male
    - Member:
       - firstName: Cindy
       - sex: female
    - Member:
       - firstName: Brandon
       - sex: male
    - Member:
       - firstName: Brandy
       - sex: female
    ```
* Desired Output:
  ```
  Mr. Jim March
  Mrs Cindy March
  Mr Brandon March
  Mrs Brandy March
  ```
## Decomposing the Transformation Function
* Denote the transformation function by _Root.persons_
* Let typed function _Family.persons_ compute the list of persons (in the required format given above) for a given family
* We note that _Root.persons_ is determined by the values of _Family.persons_ for all the families (contained in the root)
* We can thus decompose _Root.persons_ with a forward function as follows:
  ```
  Root.persons: cont -> Family.persons
  ```
* Next we note that Family.persons is determined by the full names (including “Mr” or “Mrs”) of the members contained in this family
* Call the typed function that returns the full name of a family member: Member.fullName
* Thus we get the next decomposition, again using a forward function:
  ```
  Family.persons: cont-> Member.fullName
  ```
* The full name of a Member depends on its sex, its first name and the last name of the family it is contained in
* Note that for the last name we need to follow the _cont_ reference backwards!!
* We therefore call the corresponding function a __reverse function__
## Reverse Functions
* Fix types A and B and reference r
* Denote by A.(r ← B.g) the typed function for A defined as follows:
  A.(r← B.g)(M,x) = {g(M,b1,),…,g(M,bk)}
  where b1,…,bk are the objects of type B that refer to x via reference r.
* Note that the value of a reverse function is a _set_ rather than a sequence (as was the case for forward functions).
* We call A.(r ← B.g) the  __reverse function__ (for reference r and type A)
## Decomposing the Transformation Function - contd
* We are now ready to write the next decomposition:
  ```
  Member.fullName: sex, firstName, cont <- Family.lastName
  ```
* Note that _sex_, _firstName_ and _lastName_ are attributes that do not need to be decomposed further (since they can be directly looked up in the example)
## family2persons: Solution
* We summarize the solution for the family2persons transformation. This time we implement the decomposition functions in Python.
  * FUDOMO Model:
    ```
    Root.persons: cont -> Family.persons
    Family.persons: cont -> Member.fullName
    Member.fullName: sex, firstName, cont <- Family.lastName
    ```
  * __Python__ Code:
    ```python
    def Root_persons(cont_Family_persons):
        """
        :param cont_Family_persons: The sequence of "persons" values of Family objects contained in this Root
        :type  cont_Family_persons: Array
        """
        return ', '.join(cont_Family_persons)

    def Family_persons(cont_Member_fullName):
        """
        :param cont_Member_fullName: The sequence of "fullName" values of Member objects contained in this Family
        :type  cont_Member_fullName: Array
        """
        return ', '.join(cont_Member_fullName)

    def Member_fullName(sex, firstName, _cont_Family_lastName):
        """
        :param sex: The "sex" of this Member
        :param firstName: The "firstName" of this Member
        :param _cont_Family_lastName: The set of "lastName" values of Family objects that contain this Member
        :type  _cont_Family_lastName: Set
        """
        familyName = next(iter(_cont_Family_lastName))
        prefix = ''
        if sex == 'male':
            prefix = 'Mr '
        else:
            prefix = 'Mrs '
        return prefix + firstName + ' ' + familyName
    ```
