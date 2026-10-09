# julia-corvus-json-schema

A [Bowtie](https://github.com/bowtie-json-schema/bowtie) test harness for
[CorvusJsonSchema](https://github.com/corvus-dotnet/Corvus.JsonSchema/tree/main/src-jl/CorvusJsonSchema), the Julia
port of [Corvus.JsonSchema](https://github.com/corvus-dotnet/Corvus.JsonSchema)'s V5 evaluator.

Its image is published to `ghcr.io/bowtie-json-schema/julia-corvus-json-schema` and run via
`bowtie run -i julia-corvus-json-schema`.

The harness compiles each case's schema with the case's `registry` as the document resolver and validates each
instance, passing each schema and instance to the package as the JSON text it arrived as. For `annotations` output it
evaluates through a verbose results collector and reports each annotation with its instance location and `#…` keyword
location. An exception, or an evaluation beyond the maximum depth, is reported as an error for that case or instance.

The package is compiled into the image, with the harness, for any processor of the architecture, so a container
starts with both compiled.

Until CorvusJsonSchema 0.1.0 is in the General registry, the `Dockerfile` pins the commit being registered and the
build fetches the package from it.
