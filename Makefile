PROJECT_NAME := proto2asciidoc
PROJECT_NAME_STYLISHED := ${PROJECT_NAME}
PROJECT_REPO := https://github.com/productsupcom/proto2asciidoc
GIT_VERSION_NAME := $(shell git describe --tags --exact-match 2> /dev/null || git symbolic-ref -q HEAD || git rev-parse HEAD)

// tag::extension[]
ASCIIDOC_EXT := -r ./asciidoctor/extensions/proto2asciidoc-inline-macro.rb
ASCIIDOC_ATTRIBUTES := ${ASCIIDOC_EXT} -a project-name=${PROJECT_NAME_STYLISHED} -a project-author="Productsup GmbH" -a project-repo=${PROJECT_REPO} -a version=${GIT_VERSION_NAME}
// end::extension[]

.PHONY: man docs html

man:
	@asciidoctor -a version=${GIT_VERSION_NAME} -b manpage man/proto2asciidoc.1.adoc
	@gzip man/proto2asciidoc.1

markdown:
	@asciidoctor docs/readme.adoc -b docbook -a leveloffset=+1 -o - | pandoc  --atx-headers --wrap=preserve -t gfm -f docbook - > README.md

docs:
	@./proto2asciidoc --source ${CURDIR}/examples/examples.proto --out docs/generated/api.adoc -f --api-docs

// tag::extension[]
html: docs
	@rm -rf html
	@mkdir html
	@asciidoctor ${ASCIIDOC_ATTRIBUTES} docs/generated/api.adoc -o html/api.html
// tag::extension[]