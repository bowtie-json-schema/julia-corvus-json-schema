# The package's source, fetched on the machine that builds the image, whatever platform the image is for. Git under
# emulation takes longer over this repository than the build is allowed.
FROM --platform=$BUILDPLATFORM alpine:3.22 AS source
RUN apk add --no-cache git
# The commit of Corvus.JsonSchema that is CorvusJsonSchema 0.1.0.
ARG CORVUS_REF=01239a808128dc6c5c403be0459c3d842958a84b
# Only the package's directory of the repository.
RUN git init -q /corvus && cd /corvus \
 && git remote add origin https://github.com/corvus-dotnet/Corvus.JsonSchema.git \
 && git sparse-checkout set src-jl/CorvusJsonSchema \
 && git fetch -q --depth 1 --filter=blob:none origin "$CORVUS_REF" \
 && git checkout -q FETCH_HEAD \
 && rm -rf src-jl/CorvusJsonSchema/test

# Julia publishes no build for musl, so the image is the official one, on Debian.
FROM julia:1.13
# Package images are compiled for the processor of the machine that builds them unless told otherwise, and Julia
# compiles them again at start-up on any other. A Bowtie image is built on one machine and run on many, so the
# images are compiled for any processor of the architecture.
ENV JULIA_CPU_TARGET=generic
WORKDIR /usr/src/harness
COPY Project.toml bowtie.jl ./
COPY src src
COPY --from=source /corvus/src-jl/CorvusJsonSchema CorvusJsonSchema
# Compiles the package and the harness into package images, so that a container starts with both compiled.
RUN julia --startup-file=no --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.precompile(strict=true)'
CMD ["julia", "--startup-file=no", "--project=/usr/src/harness", "/usr/src/harness/bowtie.jl"]
