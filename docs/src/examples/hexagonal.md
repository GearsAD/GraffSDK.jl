# The Hexagonal Robot Example

Imagine a little wheeled robot driving in a circle. The tread measurement is a little sketchy, so as it progresses it gets a little less certain of where it is. But, each time it loops around, it's fairly certain it sees the same AprilTag. We construct this problem in SlamInDb/Graff, and show how the little guy is able to keep his cool as he progresses on his Sisyphean journey. Concepts highlighted:  
  1. Adding incremental odometry data
  1. Adding data to poses
  1. Adding factors like loop closures
  1. Solver robustness when contradictory data is provided
  1. Visualization

## Source Code
The complete source code for this example can be found at [The Hexagonal Robot Example](https://github.com/GearsAD/GraffSDK.jl/blob/master/examples/6_HexagonalSLAM.jl).

## An Overview of the Example
