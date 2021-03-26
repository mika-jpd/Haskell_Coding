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
