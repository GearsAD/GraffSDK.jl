# Install dependencies
using Pkg;
Pkg.add(PackageSpec(url="/graffsdk/GraffSDK.jl"));
Pkg.instantiate();
Pkg.add("JSON");
using GraffSDK;
#using GraffSDK.DataHelpers
#using ProgressMeter