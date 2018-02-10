using Documenter, SynchronySDK

makedocs(
    modules = [SynchronySDK],
    format = :html,
    sitename = "Synchrony SDK",
    pages = Any[
        "Home" => "index.md",
        "Function Calls" => "func_ref.md",
        "Reference" => "reference.md"
    ]
    # html_prettyurls = !("local" in ARGS),
    )


deploydocs(
    repo   = "github.com/GearsAD/SynchronySDK.jl.git",
    target = "build",
    deps   = nothing,
    make   = nothing,
    julia  = "0.6",
    osname = "linux"
)




# deploydocs(
#     deps   = Deps.pip("mkdocs", "python-markdown-math", "mkdocs-material"),
#     repo   = "github.com/Affie/Video4Linux.jl.git",
#     julia  = "release",
# )
