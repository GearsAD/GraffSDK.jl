using Pkg;
Pkg.add(PackageSpec(name="ProgressMeter", version="0.6.1"));
Pkg.add(PackageSpec(url="/graffsdk/GraffSDK.jl"));
Pkg.add(PackageSpec(name="JSON", version="0.18.0"));
Pkg.add(PackageSpec(name="Unmarshal", version="0.2.1"));
using GraffSDK;
using ProgressMeter;