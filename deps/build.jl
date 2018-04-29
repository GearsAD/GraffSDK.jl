include(joinpath(dirname(@__FILE__), "datafiles.jl"))

if !isdir(datadir)
  mkdir(datadir)
end

info("Downloading test datasets:")

for f in datafiles
  fn = joinpath(datadir, f)
  if !isfile(fn)
    file_url = publicexamples*f*"?raw=true"
    info("Downloading $(file_url)")
    download(file_url, fn)
  end
end

info("Download complete.")
