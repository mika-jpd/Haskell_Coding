# Catgory Theory for Programmers
Summary of some of the important concepts in Bartosz Milewski's "Category Theory for Programmers".

## Table of Contents

## Ch. 1: Composition
Category: consists of objects and arrows between these objects. It's that simple
Arrows are called morphisms and act just like functions. Functions can be called one after another and compose each other; this is called composition denoted by
* g(f(x)) = g . f (x)

In Haskell this gives
```haskell
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

## Ch. 2: Types and Functions
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

## Ch. 3: Categories Great and Small
Empty category, category of all cetegories st. {} &#8712; {*set of all sets*}
We can thinnk of building a cetgory as putting identity arrows, then directed arrows between nodes of a graph, then making arrows representing composition of arrows. By doing this, you're creating a category which has an object for every node and all possible *chains* of composable graph edges as morphisms.

In Set language we have:

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

In Category Theory, 

* **pre-Order** is a category where at most one morphism going from an obect *a* to *b*.
* **hom-set** C(*a*, *b*) is a set of morphisms from *a* to *b*

monoid (set<sub>***def***</sub>): a set with a binary operation
* associative
* unit element
 * ex: natural numbers with zero form a monoid
 * ex2: strings and the empty string
```haskell
instance Monoid String where
    mempty = ""
    mappend = (++)
```
monoid (category<sub>***def***</sub>): explain in terms of objects and morphisms. Binary operators "move" or "shift" elements around a set. For most set, we have an "adder".
* the (+ 5) functions will map 0 -> 5, 2 -> 7 etc...
* it is composable since (+ 7) . (+ 5) 0 = (+ 12) 0
* 0 becomes the ***id***<sub>n</sub> function

A monoid is a single object category with a set of morphisms that following composition rules

## Kleisli Categories
Let's look at the Writer Category:
```haskell
type Writer a = (a, String)
```
With our morphisms 
```haskell
a -> Writer b
```
and composition defined as
```haskell
(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \x ->
    let (y, s1) = m1 x
        (z, s2) = m2 y
    in (z, s1 ++ s2)
```
and identity defined as
```haskell
return :: a -> Writer a
return x = (x, "")
```
This category will describe what operations are going on and write the result of a composition along with the sequence of strings that describe what functions a result is composed of! What's super cool is:
* this is a category: it doesn't care about what types  a are only to establish moprhisms between some object a, b, c
* it is based on the *writer* monad
* here we extend our model from simply sets and functions between them to a category where morphisms are represented as embellished functions and compositions do more than merely passing the result of one functions to the input of another. We are in some way wrapping results in some category (here the writer category)

## Products and Coproducts
Universal construction is a way to describe an objects in terms of its relationship to other objects. We might try to first find what the *intitial* object is:

***initial object***<sub>def</sub>: the object that has one and only one morphism going to any object in the category. It is uniquely the ```absurd :: Void -> a``` function in Haskell with regards to the sets and functions.

***terminal object***<sub>def</sub>: *b* is "more terminal" than *a* if there is a morphism a -> b. *The* terminal object is the object with one and only one morphism coming to it from any object in the category. It is uniquely the ```unit :: a -> ()```.

Useful Links:
* https://guides.github.com/features/mastering-markdown/
* https://www.toptal.com/designers/htmlarrows/math/
* https://github.github.com/gfm/#entity-and-numeric-character-references
