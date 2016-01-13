+++
date = "2015-03-20T14:19:00+07:00"
draft = false
title = "Small code optimizations"
+++

There's a lot of optimizations that are done by the compiler at compile time. Here are a couple of them! Some compilers do these optimizations and some don't.

**[Strength reduction](https://en.wikipedia.org/wiki/Strength_reduction)**

Strength reduction optimizations usually take place in a loop. It usually looks for expression involving a loop invariant and an induction variable. Sometimes these operations can be simplified.

Strength reduction could be replacing X with Y in a piece of code. For example, replacing a multiplication with an addition. The point is to simplify a more complex expression (multiplication) with an addition expression.

A **[loop invariable](https://en.wikipedia.org/wiki/Loop_invariant)** in compiler design are values that do not change within the scope of the loop.

An **[induction variable](https://en.wikipedia.org/wiki/Induction_variable)** in compiler design is a variable that always gets increased or decreased by the same amount each time the loop iterates. When you have a particular loop for example:

```
for (i = 0; i < N; i++)
```

the variable i is always an induction variable. Induction variables can be said to be the values that are being iterated and changed every time the loop iterates.

The following example is taken from Wikipedia. Lets say we have a program with a constant c, an array y, and a bound N. We have setup a loop that has a the loop counter i and is bounded by N. Each time we are setting the index i of array y by the constant multiplied by i.

```
c = 8;
for (i = 0; i < N; i++)
{
    y[i] = c * i;
}
```

Here the loop invariant is c, and the induction variable is i. The loop invariable is c because it's a value set before the loop, and does not update in the scope of the loop. The induction variable is i because it's the variable that is being iterated or changed at every iteration of the loop. I believe it can also be said that y[i] is an induction variable because it's also being changed at each iteration of the loop, but we don't need to make this statement (as you will see).

When the strength is reduced for this particular block of code, it becomes:

```
c = 8;
k = 0;
for (i = 0; i < N; i++)
{
    y[i] = k;
    k = k + c;
}
```
