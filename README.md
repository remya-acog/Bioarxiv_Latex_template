# bioRxiv preprint template for LaTeX / Overleaf

A LaTeX port of the bioRxiv Word template by Christian L. Ebbesen
([chrelli/bioRxiv-word-template](https://github.com/chrelli/bioRxiv-word-template)).
`main.tex` reproduces the template's example PDF page by page.

## Using it on Overleaf

1. **New Project → Upload Project** and select the zip file.
2. Click **Recompile**. The default **pdfLaTeX** compiler works.
   **XeLaTeX** gives the closest match because it uses the original OpenType
   STIX Two fonts (Menu → Settings → Compiler).

## Files

| File | Purpose |
|---|---|
| `biorxiv.cls` | The class: page layout, fonts, colours, headings, legends, references |
| `main.tex` | Example manuscript, identical in content to the Word template |
| `biorxiv.bst` | Nature-style numbered references, as in the template |
| `references.bib` | Example references |
| `biorxiv-logo.png` | The bioRxiv logo, cropped exactly as in the Word file |

## What is reproduced from the Word template

| Element | Specification |
|---|---|
| Paper / margins | A4; 20 mm top, 23 mm bottom, 13 mm left/right |
| Columns | 2 × 89 mm with a 5.9 mm gap (183.9 mm text width) |
| Accent colour | `#C00000` for headings, affiliation marks, legend titles and panel letters |
| Logo | 42.86 mm wide, top left on page 1 |
| Title | Helvetica Bold 21/25.2 pt |
| Authors | Helvetica Bold 11 pt; red bold superscript affiliation marks |
| Affiliations | Helvetica 9/10.8 pt; red `*` for correspondence |
| Abstract | Helvetica Bold 9/10.8 pt, justified, full width |
| Body | STIX Two Text 10/12.5 pt, justified; 5 mm indent except after headings |
| Heading 1 | Helvetica Bold 11 pt, red, 6 pt before |
| Heading 2 | Helvetica Bold 9 pt, red, 6 pt before, or 0 pt directly after a Heading 1 |
| Methods text | STIX Two Text 8/10 pt; subheadings Helvetica Bold 7.5 pt, red, 4 pt before |
| Figure legends | Helvetica 8/9.6 pt; bold red "Figure N: Title." and **(A)** panel letters |
| References | STIX Two 8/10 pt; number flush left, 6.3 mm hanging indent |
| Header | *Running title* (Helvetica Oblique 9 pt), centred, from page 2 |
| Footer | "Lastname et al. 2019 (preprint)" left, page number right (Helvetica 9 pt) |
| Supplementary | Single column, centred red headings, Figure S1…, grey Courier 8 pt code |

Text sizes are set in PostScript points (bp), as Word uses them. In a
side-by-side measurement against the Word PDF, the title, authors, abstract,
headings, header and footer are within 0.6 pt of the original positions.

## Quick reference

```latex
\documentclass{biorxiv}            % options: numbers (for [1] citations), nologo
\runningtitle{Short title}         % page header from page 2
\preprintfooter{Smith et al. 2026 (preprint)}
\title{...}
\author{Ann Smith,\affil{a,*} Bob Jones\affil{b}}
\address{a}{Institute ...}
\correspondence{Correspondence should be addressed to A.S. (ann@uni.edu)}
\begin{abstract} ... \end{abstract}
\begin{document}
\maketitle
\section{Introduction}      % Heading 1
\subsection{...}            % Heading 2

\begin{figure}[t]           % single column, 89 mm
  \includegraphics[width=\onecolumnwidth]{fig1}
  \caption{\figtitle{Bold red title.} \panel{A} Text ... \panel{B} ...}
\end{figure}
% full width: figure* + \twocolumnwidth (183.9 mm)
% 1.5 column: figure* + minipage of \onehalfcolumnwidth (133.125 mm)

\bibliographystyle{biorxiv}
\bibliography{references}

\begin{methods}             % 8 pt "Methods Text"
\section*{Acknowledgements} ...
\section{Materials and Methods}
\subsection{...}            % methods subheading inside this environment
\end{methods}

\supplementary              % new page, single column, S-numbering
\section{Supplementary Note 1: ...}
\begin{code} ... \end{code}
\end{document}
```

## Fonts

* **XeLaTeX / LuaLaTeX:** STIX Two Text and STIX Two Math (the template's fonts),
  TeX Gyre Heros (Helvetica clone) and TeX Gyre Cursor (Courier clone).
* **pdfLaTeX:** the `stix2` package, `helvet` (Nimbus Sans) and `courier`.

All of these fonts are included in Overleaf's TeX Live installation.

## Known differences from Word

* **Text beside 1.5-column figures.** LaTeX cannot flow text beside a float. A
  1.5-column figure keeps its width and position, but the 50.8 mm beside it
  stays empty.
* **Line breaks.** LaTeX hyphenates automatically, so line breaks differ slightly
  from the Word PDF. From page 3 onward, headings can therefore land a few
  lines away from their position in the original.

The original Word template is GPL-3.0; this port keeps that licence.
