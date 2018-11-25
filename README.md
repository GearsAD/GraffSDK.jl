![GraffSDK Logo](graff_logo_white.png)

# GraffSDK.jl
Build status: [![Build Status](https://travis-ci.org/GearsAD/GraffSDK.jl.svg?branch=master)](https://travis-ci.org/GearsAD/GraffSDK.jl)

## Overview
A Julia SDK for the Graff/SlamInDb project!nc

## Installation
This package is not yet registered with JuliaLang/METADATA.jl, but can be easily installed in Julia 0.6 with:
```julia
Pkg.clone("https://github.com/GearsAD/GraffSDK.jl.git")
Pkg.build("GraffSDK")
```

## Dependencies

If you're starting from a completely fresh Linux image (e.g. Docker), you'll need some essential tools, such as make, unzip, and patch. You can install these independently, or you can just pull them with this command:

```julia
sudo apt-get install unzip patch build-essential
```

That should get you started! (You probably don't need the full 216Mb build-essential, but it's probably going to crop up as a dependency later during your endeavours)

## Documentation
You can find all the Graff SDK documentation at [GraffSDK.jl GitHub Page](https://gearsad.github.io/GraffSDK.jl/latest/)

> **Important Note:** User, robot, and session names cannot contain spaces or special characters. We're revising this in an upcoming release, but please ensure that you only use alphanumeric names for the moment.

## Examples
There are quite a few examples in the [Examples](examples) folder and we're constantly growing more. Here you'll find everything from an introductory 'Registering your First Robot' example through to a full Apil-tags driven localization example with a Brookstone Rover.  

## Questions
Any questions, please feel free to post Issues or email me directly sclaassens.ad[at]gmail.com.
