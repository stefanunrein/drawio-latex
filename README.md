# drawio-LaTeX
This repository provides a LaTeX package to support the draw.io diagram tool. It aims to have full compatibility and ease of use.

The goal of this project is to have a single source of truth for your diagrams → the draw.io file. The export will be done by LaTeX on demand and only if necessary. You can add a draw.io diagram as simply as with \includegraphics; this package will handle the rest.

The final goal of this project is to be included in the official CTAN LaTeX packages.

## Set-Up
Until this package is included in the official packages, you need to add the `drawio.sty` and the Perl script `drawio-page-resolve.pl` locally to your LaTeX document. Add the package as usual with:

```latex
\usepackage{graphicx}
\usepackage{drawio}
```

Note the requirement of the `graphicx` package. The exported diagrams will be added finally with `\includegraphics`.

In your preamble, you can specify the behavior with the following predefined commands:

```latex
\drawiosetexe{path/to/drawio/executable} % default is "drawio" if it is part of the search PATH
\drawiosetperl{path/to/perl/executable} % default is "perl" if it is part of the search PATH
\drawiosetresolver{relative/or/absolute/path/to/drawio-page-resolve.pl} % default "drawio-page-resolve.pl" if it is in the same folder as your main tex file
\drawiosetdefaultclioptions{<drawio default export options>} % default "--crop --border 5", overwrite if other defaults are necessary
\drawiosetexportserver{<URL to drawio export server>} % needs to be set up if export server functionality should be used, e.g. "http://my.domain.de/drawio-converter/export"
```

NOTE: In a usual environment, with local draw.io and LaTeX set up, you do not need to set any of these.

IMPORTANT: Since you are accessing another program from TeX, you need to enable shell escape by adding `-shell-escape` to your TeX call.

## Usage
This package provides two modes: the local mode, which uses your local draw.io installation, and an export server mode, which uses the drawio-export-server Docker container. This is necessary if you want to build your documents in a CI environment. Both modes work together with the same setup. The package first tries to export your files with your local draw.io installation and falls back to server mode if the local installation is not accessible. All diagrams are exported as PDF pages.

### Including
The package provides two include commands:

```latex
\includedrawio[<includegraphics options>][<drawio CLI options>]{path/to/*.drawio}
\includedrawiopage[<includegraphics options>][<drawio CLI options>]{path/to/*.drawio}{page}
```

Include a diagram simply by calling:

```latex
\includedrawio[width=0.8\textwidth]{diagrams/My-Diagram} % Note: the ending ".drawio" is not included and is assumed by the package
\includedrawiopage[width=0.8\textwidth]{diagrams/My-Diagram}{My-Page}
```

The page can be referenced either by an integer as the page index (draw.io begins with index 1) or by using the name of the page specified in the draw.io file. In the latter case, the Perl script is invoked to resolve the page name.

NOTE: Since you can move the diagram tabs around, it is better to reference pages by name.

### Using the export server
If you want to use the export server, the following prerequisites should be met:
* `curl` is available through PATH
* Only page references by name are used
* Your LaTeX build has access to the export server through `curl`

The CLI options of a local draw.io installation should be used; the package translates them to the correct values for the export server.

## TODO List

* [x] Make drawio package
  * [x] Normal export
  * [x] Page reference by integer
  * [x] Page reference by name
  * [x] Support for drawio-export-server
* [x] Fill out README
* [x] Create example
* [ ] Create documentation
* [ ] Make CI test pipeline
* [ ] Make CI documentation pipeline
* [ ] Create delivery package
* [ ] Upload to CTAN

## Gitignore
This package auto-generates files for various purposes. These files should be ignored by Git. Add these entries to your `.gitignore`:

```
**/*.drawio.pdf
**/*.drawio.pageindex
**/*.drawio.resolverpath
**/drawio.check
```

## Disclaimer
An AI was used to help with this work. Not a single line of code was published without manual review by a human.
