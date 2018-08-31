# Examples

## Conceptual Examples

There are a few simple examples that take you through the creation of a robot, a session, and add data. These are:
1. [Graff Initialization](basics_initialization.md)
1. [Creating a Robot and Adding Configuration Data](basics_robot.md)
1. [Creating Sessions, Adding Nodes](basics_session.md)
1. [A Deep Dive into Variables and Factors](nope)

## End-To-End Examples

We are growing a library of end-to-end examples that highlight specific features of SlamInDb/Graff which we think are, well, cool. These are:

1. [The Hexagonal Robot Example](hexagonal.md): Imagine a little wheeled robot driving in a circle. The tread measurement is a little sketchy, so as it progresses it gets a little less certain of where it is. But, each time it loops around, it's fairly certain it sees the same AprilTag. We construct this problem in SlamInDb/Graff, and show how the little guy is able to keep his cool as he progresses on his Sisyphean journey. Concepts highlighted:  
    1. Adding incremental odometry data
    1. Adding data to poses
    1. Adding factors like loop closures
    1. Solver robustness when contradictory data is provided
    1. Visualization

1. [Brookstone Rover Example](brookstone.md): In the Brookstone Rover example we implement a real-world version of the Hexagonal example, and demonstrate batch-processing in Graff using a simple \$100 robot. The robot is cheap, the data is messy, and we still a good solution. Concepts highlighted:
    1. Integrating Graff with MIT's LCM to process an LCM log
    1. Processing offline camera data
    1. Visualization
