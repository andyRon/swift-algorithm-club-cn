# Shunting Yard Algorithm
# 调度场算法

Any mathematics we write is expressed in a notation known as *infix notation*. For example:
我们编写的任何数学都用一种称为*中缀符号*的符号表示。 例如：

**A + B * C**

The operator is placed in between the operands, hence the expression is said to be in *infix* form. If you think about it, any expression that you write on a piece of paper will always be in infix form. This is what we humans understand.
操作符位于操作数之间，因此表达式被称为*infix*形式。 如果你考虑一下，你在一张纸上写的任何表达都将是中缀形式。 这是我们人类所理解的。

Multiplication has higher precedence than addition, so when the above expression is evaluated you would first multiply **B** and **C**, and then add the result to **A**. We humans can easily understand the precedence of operators, but a machine needs to be given instructions about each operator.
乘法具有比加法更高的优先级，因此当评估上述表达式时，首先将**B**和**C**相乘，然后将结果添加到**A**。我们人类可以很容易地理解运算符的优先级，但是需要为机器提供有关每个运算符的指令。

To change the order of evaluation, we can use parentheses:
要更改计算顺序，我们可以使用括号：

**(A + B) * C**

Now **A** is first added to **B** and then the sum is multiplied by **C**.
现在**A**首先加到**B**然后总和乘以**C**。

If you were to write an algorithm that parsed and evaluated expressions in infix notation you will realize that it's a tedious process. You'd have to parse the expression multiple times to know what operation to perform first. As the number of operators increase so does the complexity.
如果您要编写一个以中缀表示法解析和计算表达式的算法，您将意识到这是一个繁琐的过程。 您必须多次解析表达式才能知道首先要执行的操作。 随着运营商数量的增加，复杂性也随之增加。

## Postfix notation
## Postfix表示法

In postfix notation, also known as Reverse Polish Notation or RPN, the operators come after the corresponding operands. Here is the postfix representation of the example from the previous section:
在后缀表示法（也称为反向波兰表示法或RPN）中，运算符位于相应的操作数之后。 以下是上一节中示例的后缀表示：

**A B C * +**

An expression in postfix form will not have any parentheses and neither will you have to worry about scanning for operator precedence. This makes it easy for the computer to evaluate expressions, since the order in which the operators need to be applied is fixed.
后缀形式的表达式不会有任何括号，您也不必担心扫描运算符优先级。 这使得计算机可以很容易地计算表达式，因为需要应用运算符的顺序是固定的。

Evaluating a postfix expression is easily done using a stack. Here is the pseudocode:

1. Read the postfix expression token by token
2. If the token is an operand, push it onto the stack
3. If the token is a binary operator,
    1. Pop the two topmost operands from the stack
    2. Apply the binary operator to the two operands
    3. Push the result back onto the stack
4. Finally, the value of the whole postfix expression remains in the stack

使用堆栈可以轻松地评估后缀表达式。 这是伪代码：

1. 通过令牌读取后缀表达式标记
2. 如果令牌是操作数，则将其推入堆栈
3. 如果令牌是二元运算符，
     1. 从堆栈中弹出两个最顶层的操作数
     2. 将二元运算符应用于两个操作数
     3. 将结果推回堆栈
4. 最后，整个后缀表达式的值保留在堆栈中



Using the above pseudocode, the evaluation of **A B C * +** would be as follows:
使用上述伪代码，**A B C * +**的评估如下：

| Expression    | Stack   |
| ------------- | --------|
| A B C * +     |         |
| B C * +       | A       |
| C * +         | A, B    |
| * +           | A, B, C |
| +             | A, D    |
|               | E       |

Where **D = B * C** and **E = A + D.**

As seen above, a postfix operation is relatively easy to evaluate as the order in which the operators need to be applied is pre-decided.
如上所述，后缀操作相对容易评估，因为预先决定了运算符需要应用的顺序。

## Converting infix to postfix
## 将中缀转换为后缀

The shunting yard algorithm was invented by Edsger Dijkstra to convert an infix expression to postfix. Many calculators use this algorithm to convert the expression being entered to postfix form.
分流码算法是由Edsger Dijkstra发明的，用于将中缀表达式转换为后缀。 许多计算器使用此算法将输入的表达式转换为后缀形式。

Here is the psedocode of the algorithm:

1. For all the input tokens:
    1. Read the next token
    2. If token is an operator (x)
        1. While there is an operator (y) at the top of the operators stack and either (x) is left-associative and its precedence is less or equal to that of (y), or (x) is right-associative and its precedence is less than (y)
            1. Pop (y) from the stack
            2. Add (y) output buffer
        2. Push (x) on the stack
    3. Else if token is left parenthesis, then push it on the stack
    4. Else if token is a right parenthesis
        1. Until the top token (from the stack) is left parenthesis, pop from the stack to the output buffer
        2. Also pop the left parenthesis but don’t include it in the output buffer
    7. Else add token to output buffer
2. Pop any remaining operator tokens from the stack to the output


这是算法的psedocode：

1. 对于所有输入令牌：
     1. 阅读下一个标记
     2. 如果令牌是运营商（x）
         1. 虽然在运算符堆栈的顶部有一个运算符（y），并且（x）是左关联的，其优先级小于或等于（y）的优先级，或者（x）是右关联的，并且 优先级小于（y）
             1. 从堆栈中弹出（y）
             2. 添加（y）输出缓冲区
         2. 按（x）在堆栈上
     3. 否则，如果令牌是左括号，则将其推入堆栈
     4. 否则，如果令牌是右括号
         1. 在顶部令牌（来自堆栈）左括号之前，从堆栈弹出到输出缓冲区
         2. 同时弹出左括号，但不要将其包含在输出缓冲区中
     7. 否则将令牌添加到输出缓冲区
2. 将任何剩余的操作符标记从堆栈弹出到输出



Let's take a small example and see how the pseudocode works. Here is the infix expression to convert:
让我们举一个小例子，看看伪代码是如何工作的。 这是要转换的中缀表达式：

**4 + 4 * 2 / ( 1 - 5 )**

The following table describes the precedence and the associativity for each operator. The same values are used in the algorithm.
下表描述了每个运算符的优先级和关联性。 算法中使用相同的值。

| Operator | Precedence   | Associativity   |
| ---------| -------------| ----------------|
| ^        | 10           | Right           |
| *        | 5            | Left            |
| /        | 5            | Left            |
| +        | 0            | Left            |
| -        | 0            | Left            |

Here we go:

| Token | Action                                      | Output            | Operator stack |
|-------|---------------------------------------------|-------------------|----------------|
| 4     | Add token to output                         | 4                 |                |
| +     | Push token to stack                         | 4                 | +              |
| 4     | Add token to output                         | 4 4               | +              |
| *     | Push token to stack                         | 4 4               | * +            |
| 2     | Add token to output                         | 4 4 2             | * +            |
| /     | Pop stack to output, Push token to stack | 4 4 2 *           | / +            |
| (     | Push token to stack                         | 4 4 2 *           | ( / +          |
| 1     | Add token to output                         | 4 4 2 * 1         | ( / +          |
| -     | Push token to stack                         | 4 4 2 * 1         | - ( / +        |
| 5     | Add token to output                         | 4 4 2 * 1 5       | - ( / +        |
| )     | Pop stack to output, Pop stack           | 4 4 2 * 1 5 -     | /  +           |
| end   | Pop entire stack to output                  | 4 4 2 * 1 5 - / + |                |

We end up with the postfix expression:
我们最终得到了后缀表达式：

**4 4 2 * 1 5 - / +**

# See also
# 扩展阅读

[Shunting yard algorithm on Wikipedia](https://en.wikipedia.org/wiki/Shunting-yard_algorithm)
[调度场算法的维基百科](https://en.wikipedia.org/wiki/Shunting-yard_algorithm)

*Written for the Swift Algorithm Club by [Ali Hafizji](http://www.github.com/aliHafizji)*
*Migrated to Swift 3 by Jaap Wijnen*

*作者：[Ali Hafizji](http://www.github.com/aliHafizji)，Jaap Wijnen*  
*翻译：[Andy Ron](https://github.com/andyRon)*  
