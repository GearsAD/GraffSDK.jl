using Documenter, GraffSDK

makedocs(
    modules = [GraffSDK],
    format = :html,
    sitename = "GraffSDK.jl",
    pages = Any[
        "Home" => "index.md",
        "Getting Started" => [
            "Introduction" => "getting_started.md",
            "Making Robust Calls" => "handling_errors.md",
            "Common Structures and Functions" => "ref_common.md",
            "Working with Data" => "working_with_data.md"
        ],
        "Examples" => [
            "Introduction" => "examples/examples.md",
            "Basic Initialization" => "examples/basics_initialization.md",
            "Basic Robot" => "examples/basics_robot.md",
            "Basic Session" => "examples/basics_session.md",
            "Hexagonal Robot" => "examples/hexagonal.md",
            "Brookstone Rover" => "examples/brookstone.md"
        ],
        "Service Reference" => [
            "User Service" => "ref_user.md",
            "Robot Service" => "ref_robot.md",
            "Session Service" => "ref_session.md"   
        ],
        "Reference" => "reference.md"
    ]
    # html_prettyurls = !("local" in ARGS),
    )


deploydocs(
    repo   = "github.com/GearsAD/GraffSDK.jl.git",
    target = "build",
    deps   = Deps.pip("mkdocs", "python-markdown-math"),
    make   = nothing,
    julia  = "0.6",
    osname = "linux"
)
