using Documenter, SynchronySDK

makedocs(
    modules = [SynchronySDK],
    format = :html,
    sitename = "Synchrony SDK",
    pages = Any[
        "Home" => "index.md",
        "Getting Started" => "getting_started.md",
        "Examples" => "examples.md",
        "Common Structures and Functions" => "ref_common.md",
        "Making Robust Calls" => "handling_errors.md",
        "User Service" => "ref_user.md",
        "Robot Service" => "ref_robot.md",
        "Session Service" => "ref_session.md",
        "Reference" => "reference.md"
    ]
    # html_prettyurls = !("local" in ARGS),
    )


deploydocs(
    repo   = "github.com/GearsAD/SynchronySDK.jl.git",
    target = "build",
    deps   = Deps.pip("mkdocs", "python-markdown-math"),
    julia  = "0.6",
    osname = "linux"
)
