# Catgory Theory for Programmers
Summary of some of the important concepts in Bartosz Milewski's "Category Theory for Programmers".

## Table of Contents

## Chapter 1: Composition
Category: consists of objects and arrows between these objects. It's that simple
Arrows are called morphisms and act just like functions. Functions can be called one after another and compose each other; this is called composition denoted by
* g(f(x)) = g . f (x)

In Haskell this gives
```
f :: A->B
g:: B-> C

g . f
```
A composition has three properties:
* Associative
* For all A, there is a unit of composition **id**<sub>A
  * f . **id**<sub>A = *f* *st. f goes from A to B*
  * **id**<sub>B . f = f
  * this function is universally polymorphic since it returns any function which it takes as argument
 
 ```haskell
 id :: a -> a
 id x = x
 ``` 
Why is Category Theory useful for functional programming? In functional programming, once a block is implemented, we forget the details of implementation and focus on its interaction with other functions. In Category Theory we look at how objects are connected, not what's inside.

## Types and Functions
Types are sets of values. 

For example: 
* *Bool* is *True* | *False* or 
* *Binary Tree* is *Empty* | *Node* a *Tree* a *Tree* a

Set theoretically, sets are combinations of elements that constitute a type and functions are mappings between sets of type. However, functions know the answers but not *programming*  functions. Thus, it is better to speak about these functions in terms of Category Theory/arrows.

Mathematical models play an important role in functional programming. The advantage of having these models is that it makes easier formal proofs for the correctness of software. In Haskell, all functions are pure. This means that it is easy to attribute denotational semantics (describing programming constructs as mathematical models) to code and model it with Category Theory.

Examples of types:
1. ```absurd :: Void -> a``` which returns anything since from falsity anything goes (same as contradiciton in formal logic)
2. Returns the singleton set containing the numer 44. This is a function from () unit to an elemt of a set, notably the Integer 44. Thus, we've represented a singleton by a function.
```haskell 
f44 :: () -> Integer
f44 () = 44
```
3. Functions from all elements of a set ***A*** to a singleton set, here unit. This is the function for *Integer* set.
```haskell
fInt :: Integer -> ()
fInt x = ()
```

parametrically polymorphic: functions with the same formula for any type (thing *f44* or ```unit :: a -> ()```)

** Categories Great and Small
Empty category, category of all cetegories where empty is part of it.
We can thinnk of building a cetgory as putting identity arrows, then directed arrows between nodes of a graph, then making arrows representing composition of arrows. By doing this, you're creating a category which has an object for every node and all possible *chains* of composable graph edges as morphisms.

**Pre-order**
* ***id***<sub>A
* composition
* associativity of composition

**Partial Order**
* ***id***<sub>A
* composition
* associativity of composition
* <sub>a</sub>P<sub>b</sub> and <sub>b</sub>P<sub>a</sub> 

**Total Order**
* ***id***<sub>A
* composition
* associativity of composition
* <sub>a</sub>P<sub>b</sub> and <sub>b</sub>P<sub>a</sub> 
* any two objects are in a relation
