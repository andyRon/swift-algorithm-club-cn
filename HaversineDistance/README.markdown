# Haversine Distance
# Haversine距离

Calculates the distance on a sphere between two points given in latitude and longitude using the haversine formula.
使用半正公式计算纬度和经度给出的两点之间的球体距离。

The haversine formula can be found on [Wikipedia](https://en.wikipedia.org/wiki/Haversine_formula)
[Haversine formula的维基百科](https://en.wikipedia.org/wiki/Haversine_formula)

The Haversine Distance is implemented as a function as a class would be kind of overkill.
Haversine Distance实现为一个函数，因为类会有点矫枉过正。

`haversineDinstance(la1: Double, lo1: Double, la2: Double, lo2: Double, radius: Double = 6367444.7) -> Double`

- `la1` is the latitude of point 1 in degrees.
- `lo1` is the longitude of point 1 in degrees.
- `la2` is the latitude of point 2 in degrees.
- `lo2` is the longitude of point 2 in degrees.
- `radius` is the radius of the sphere considered in meters, which defaults to the mean radius of the earth (from [WolframAlpha](http://www.wolframalpha.com/input/?i=earth+radius)).

 - `la1`是点1的纬度（以度为单位）。
 - `lo1`是度数为1的经度。
 - `la2`是以度为单位的第2点的纬度。
 - `lo2`是度数为2的经度。
 - `radius`是以米为单位的球体半径，默认为地球的平均半径（来自[WolframAlpha](http://www.wolframalpha.com/input/?i=earth+radius)）。

The function contains 3 closures in order to make the code more readable and comparable to the Haversine formula given by the Wikipedia page mentioned above.

1. `haversine` implements the haversine, a trigonometric function.
2. `ahaversine` the inverse function of the haversine.
3. `dToR` a closure converting degrees to radians.

The result of `haversineDistance` is returned in meters.

该函数包含3个闭包，以使代码更具可读性，并与上面提到的Wikipedia页面给出的Haversine公式相当。

1. `hasrsine`实现了三角函数hasrsine。
2. `ahaversine`thersine的反函数。
3. `dToR`一个将度数转换为弧度的闭包。

`hasrsineDistance`的结果以米为单位返回。

*Written for Swift Algorithm Club by Jaap Wijnen.*

*作者：Jaap Wijnen*     
*翻译：[Andy Ron](https://github.com/andyRon)*  
