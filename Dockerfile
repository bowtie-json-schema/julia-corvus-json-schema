# Julia publishes no build for musl, so the image is the official one, on Debian.
FROM julia:1.13
# Package images are compiled for the processor of the machine that builds them unless told otherwise, and Julia
# compiles them again at start-up on any other. A Bowtie image is built on one machine and run on many, so the
# images are compiled for any processor of the architecture.
ENV JULIA_CPU_TARGET=generic
WORKDIR /usr/src/harness
COPY Project.toml bowtie.jl ./
COPY src src
# Installs CorvusJsonSchema from Julia's General registry (the latest version Project.toml's [compat] allows), then
# compiles the package and the harness into package images, so that a container starts with both compiled.
RUN julia --startup-file=no --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.precompile(strict=true)'
CMD ["julia", "--startup-file=no", "--project=/usr/src/harness", "/usr/src/harness/bowtie.jl"]
