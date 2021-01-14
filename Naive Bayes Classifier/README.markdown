# Naive Bayes Classifier

# 朴素贝叶斯分类器



> ***Disclaimer:*** Do not get scared of complicated formulas or terms, I will describe them right after I use them. Also the math skills you need to understand this are very basic.

> **免责声明：**不要害怕复杂的公式或术语，我会在使用它们后立即对它们进行描述。 您需要了解的相关数学技能是非常基础的。

The goal of a classifier is to predict the class of a given data entry based on previously fed data and its features. 

分类器的目标是基于先前馈送的数据及其特征来预测给定数据条目的类。

Now what is a class or a feature? The best I can do is to describe it with a table. 
This is a dataset that uses height, weight and foot size of a person to illustrate the relationship between those values and the sex.

现在什么是类别或特征？ 我能做的最好的就是用表来描述它。
这是一个使用人的身高，体重和脚尺寸来说明这些值与性别之间关系的数据集。

| Sex       | height (feet)          | weight(lbs)  | foot size (inches) |
| ------------- |:-------------:|:-----:|:---:|
| male      | 6     | 180 | 12  |
| male      | 5.92  | 190 | 11  |
| male      | 5.58  | 170 | 12  |
| male      | 5.92  | 165 | 10  |
| female    | 5     | 100 | 6   |
| female    | 5.5   | 150 | 8   |
| female    | 5.42  | 130 | 7   |
| female    | 5.75  | 150 | 9   |

The ***classes*** of this table is the data in the sex column (male/female). You "classify" the rest of the data and bind them to a sex.

该表的***类***是性别栏中的数据（男/女）。 您将其余数据“分类”并将其绑定到性别。

The ***features*** of this table are the labels of the other columns (height, weight, foot size) and the numbers right under the labels.

此表的***特征***是其他列的标签（高度，重量，尺寸）和标签下方的数字。

Now that I've told you what a classifier is I will tell you what exactly a ***Naive Bayes classifier*** is. There are a lot of other classifiers out there but what's so special about this specific is that it only needs a very small dataset to get good results. The others like Random Forests normally need a very large dataset.

Why isn't this algorithm used more you might ask (or not). Because it is normally ***outperformed*** in accuracy by ***Random Forests*** or ***Boosted Trees***.

现在我已经告诉过你什么是分类器我会告诉你究竟是什么***朴素贝叶斯分类器***。 那里有很多其他的分类器，但是这个特殊的特殊之处在于它只需要一个非常小的数据集来获得好的结果。 像随机森林这样的其他人通常需要一个非常大的数据集。

为什么这个算法使用得不多，你可能会问（或不）。 因为它通常***在***随机森林***或*** Boosted Trees ***精确度超过***。

## Theory

## 理论

The Naive Bayes classifier utilizes the ***Bayes Theorem*** (as its name suggests) which looks like this.

朴素贝叶斯分类器使用***贝叶斯定理***（顾名思义），看起来像这样。



![](images/bayes.gif)

***P*** always means the probability of something.

*** P ***是指某事的概率。

***A*** is the class, ***B*** is the data depending on a feature and the ***pipe*** symbol means given. 

P(A | B) therefore is: probability of the class given the data (which is dependent on the feature).

This is all you have to know about the Bayes Theorem. The important thing for us is now how to calculate all those variables, plug them into this formula and you are ready to classify data.

***A***是等级，***B***是取决于特征的数据，***管道***符号表示给出。

因此，P(A|B) 是：给定数据的类的概率（取决于特征）。

这是关于贝叶斯定理的全部知识。 对我们来说重要的是现在如何计算所有这些变量，将它们插入到这个公式中，您就可以对数据进行分类了。

### **P(A)**
This is the probability of the class. To get back to the example I gave before: Let's say we want to classify this data entry:

这是类的概率。 回到我之前给出的例子：假设我们想要对这个数据条目进行分类：

| height (feet)          | weight(lbs)  | foot size (inches) |
|:-------------:|:-----:|:---:|
| 6     | 130 | 8  |

What Naive Bayes classifier now does: it checks the probability for every class possible which is in our case either male or female. Look back at the original table and count the male and the female entries. Then divide them by the overall count of data entries.

朴素贝叶斯分类器现在做了什么：它检查每个类可能的概率，在我们的例子中是男性或女性。 回顾原始表并计算男性和女性的条目。 然后将它们除以数据条目的总数。

P(male) = 4 / 8 = 0.5

P(female) = 4 / 8 = 0.5

This should be a very easy task to do. Basically just the probability of all classes.

这应该是一项非常容易的任务。 基本上只是所有课程的概率。

### **P(B)**
This variable is not needed in a Naive Bayes classifier. It is the probability of the data. It does not change, therefore it is a constant. And what can you do with a constant? Exactly! Discard it. This saves time and code.

朴素贝叶斯分类器中不需要此变量。 这是数据的概率。 它不会改变，因此它是一个常数。 你能用常数做什么？ 究竟！ 丢弃它。 这节省了时间和代码。

### **P(B | A)**
This is the probability of the data given the class. To calculate this I have to introduce you to the subtypes of NB. You have to decide which you use depending on your data which you want to classify.

这是给出类别的数据的概率。 为了计算这个，我必须向您介绍NB的子类型。 您必须根据要分类的数据决定使用哪种。

### **Gaussian Naive Bayes**  高斯朴素贝叶斯
If you have a dataset like the one I showed you before (continuous features -> `Double`s) you have to use this subtype. There are 3 formulas you need for Gaussian NB to calculate P(B | A).

如果你有一个我之前展示过的数据集（连续特征 ->`Double`s），你必须使用这个子类型。 高斯NB计算P（B | A）需要3个公式。

![mean](images/mean.gif)

![standard deviation](images/standard_deviation.gif)

![normal distribution](images/normal_distribution.gif)

and **P(x | y) = P(B | A)**

Again, very complicated looking formulas but they are very easy. The first formula with µ is just the mean of the data (adding all data points and dividing them by the count). The second with σ is the standard deviation. You might have heard of it somewhen in school. It is just the sum of all values minus the mean, squared and that divided by the count of the data minus 1 and a sqaure root around it. The third equation is the Gaussian or normal distribution if you want to read more about it I suggest reading [this](https://en.wikipedia.org/wiki/Normal_distribution).

同样，非常复杂的外观公式，但它们非常容易。 μ的第一个公式只是数据的平均值（添加所有数据点并将其除以计数）。 第二个是σ是标准偏差。 你可能在学校时听说过它。 它只是所有值的总和减去平均值，平方和除以数据减去1的数量和它周围的平方根。 第三个等式是高斯分布或正态分布，如果你想了解更多关于它我建议阅读[这](https://en.wikipedia.org/wiki/Normal_distribution)。

Why the Gaussian distribution? Because we assume that the continuous values associated with each class are distributed according to the Gaussian distribution. Simple as that.

为什么高斯分布？ 因为我们假设与每个类相关联的连续值是根据高斯分布分布的。 就那么简单。

### **Multinomial Naive Bayes** 多项朴素贝叶斯

What do we do if we have this for examples:

如果我们有这个例子，我们该怎么办：

![tennis or golf](images/tennis_dataset.png)

We can't just calculate the mean of sunny, overcast and rainy. This is why we need the categorical model which is the multinomial NB. This is the last formula, I promise!

我们不能只计算晴天，阴天和下雨的平均值。 这就是为什么我们需要分类模型，即多项式NB。 这是最后一个公式，我保证！

![multinomial](images/multinomial.gif)

Now this is the number of times feature **i** appears in a sample **N** of class **y** in the data set divided by the count of the sample just depending on the class **y**. That θ is also just a fancy way of writing P(B | A).

现在，这是特征**i**出现在样本中的次数数据集中的除以样本的数量仅取决于类**y**。 那个θ也只是写P（B | A）的一种奇特方式。

You might have noticed that there is still the α in this formula. This solves a problem called "zero-frequency-problem". Because what happens if there is no sample with feature **i** and class **y**? The whole equation would result in 0 (because 0 / something is always 0). This is a huge problem but there is a simple solution to this. Just add 1 to any count of the sample (α = 1).
你可能已经注意到这个公式中仍然存在α。 这解决了称为“零频率问题”的问题。 因为如果没有具有功能**i**和类**y**的样本会发生什么？ 整个方程将导致0（因为0 /某些东西总是0）。 这是一个很大的问题，但有一个简单的解决方案。 只需对样本的任何计数加1（α= 1）。

## Those formulas in action 这些公式的作用

Enough talking! This is the code. If you want a deeper explanation of how the code works just look at the Playground I provided.

够说话了！ 这是代码。 如果您想要更深入地解释代码的工作方式，请查看我提供的Playground。

![code example](images/code_example.png)

*Written for Swift Algorithm Club by Philipp Gabriel*



*作者：Philipp Gabriel*

*翻译：[Andy Ron](https://github.com/andyRon) *