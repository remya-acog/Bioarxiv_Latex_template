%% biorxiv.cls
%% ---------------------------------------------------------------------------
%% A LaTeX port of the bioRxiv Word template by Christian L. Ebbesen
%% (https://github.com/chrelli/bioRxiv-word-template, GPL-3.0).
%%
%% Reproduces the Word template's measurements:
%%   * A4 paper; margins 20 mm top, 23 mm bottom, 13 mm left/right
%%   * two 89 mm columns separated by 5.9 mm (183.9 mm text width)
%%   * STIX Two Text 10/12.5 pt body, Helvetica headings / abstract / captions
%%   * accent colour #C00000 (Word "dark red")
%%
%% Works with pdfLaTeX (Overleaf default), XeLaTeX and LuaLaTeX.
%% ---------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{biorxiv}[2026/11/03 v1.0 bioRxiv preprint class (port of the bioRxiv Word template)]

%% ----------------------------------------------------------------- options
\newif\ifbx@logo        \bx@logotrue
\newif\ifbx@supercite   \bx@supercitetrue
\DeclareOption{nologo}{\bx@logofalse}
\DeclareOption{numbers}{\bx@supercitefalse}     % [1] instead of superscript ^1
\DeclareOption{super}{\bx@supercitetrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[a4paper,twocolumn,10pt]{article}

%% ----------------------------------------------------------------- packages
\RequirePackage{iftex}
\RequirePackage{amsmath}
\RequirePackage{etoolbox}
\RequirePackage{environ}
\RequirePackage[table]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{titlesec}
\RequirePackage{fancyhdr}
\RequirePackage{caption}
\RequirePackage{listings}
\RequirePackage{enumitem}
\RequirePackage{booktabs}
\RequirePackage{url}

%% ----------------------------------------------------------------- fonts
%% Word template: STIX Two Text (body), STIX Two Math (equations),
%% Helvetica (title, authors, abstract, headings, captions, header/footer),
%% Courier New (supplementary code).
\iftutex
  % ---- XeLaTeX / LuaLaTeX: the real OpenType fonts --------------------
  \RequirePackage{fontspec}
  \RequirePackage{unicode-math}
  \IfFontExistsTF{STIXTwoText-Regular.otf}{%
    \setmainfont{STIXTwoText}[Extension=.otf,
      UprightFont=*-Regular, ItalicFont=*-Italic,
      BoldFont=*-Bold, BoldItalicFont=*-BoldItalic]}{%
    \setmainfont{STIX Two Text}}
  \IfFontExistsTF{STIXTwoMath-Regular.otf}{%
    \setmathfont{STIXTwoMath-Regular.otf}}{%
    \setmathfont{STIX Two Math}}
  % TeX Gyre Heros = metric clone of Helvetica; TeX Gyre Cursor = Courier
  \setsansfont{texgyreheros}[Extension=.otf,
    UprightFont=*-regular, ItalicFont=*-italic,
    BoldFont=*-bold, BoldItalicFont=*-bolditalic]
  \setmonofont{texgyrecursor}[Extension=.otf,
    UprightFont=*-regular, ItalicFont=*-italic,
    BoldFont=*-bold, BoldItalicFont=*-bolditalic]
\else
  % ---- pdfLaTeX --------------------------------------------------------
  \RequirePackage[T1]{fontenc}
  \IfFileExists{stix2.sty}{%
    \RequirePackage{stix2}}{%
    \ClassWarningNoLine{biorxiv}{stix2.sty not found; falling back to
      a Times-like font. Install the stix2-type1 package for the exact font}%
    \IfFileExists{newtxtext.sty}{%
      \RequirePackage{newtxtext}\RequirePackage{newtxmath}}{%
      \RequirePackage{mathptmx}}}
  \RequirePackage[scaled=1]{helvet}  % Nimbus Sans = Helvetica metrics
  \RequirePackage{courier}            % Nimbus Mono = Courier metrics
\fi
\RequirePackage[protrusion=false]{microtype}

%% ----------------------------------------------------------------- colours
\definecolor{bxred}{HTML}{C00000}       % headings, superscripts, legend titles
\definecolor{bxcode}{HTML}{666666}      % supplementary code
\definecolor{bxplaceholder}{HTML}{5B9BD5}% Word's blue figure placeholder

%% ----------------------------------------------------------------- page
\RequirePackage[a4paper,
  top=20mm, bottom=23mm, left=13mm, right=13mm,
  columnsep=5.9mm,
  headheight=11pt, headsep=8.86pt,
  footskip=27.2pt]{geometry}
\setlength{\columnseprule}{0pt}

%% ----------------------------------------------------------------- sizes
%% Word measures type in PostScript points (bp); \bx@size{<bp>}{<bp>} converts.
%% Word "single" line spacing: STIX Two = 1.25 x size, Helvetica = 1.2 x size
\newcommand\bx@bp[1]{\strip@pt\dimexpr#1bp\relax}
\newcommand\bx@size[2]{\fontsize{\bx@bp{#1}}{\bx@bp{#2}}\selectfont}
\renewcommand\normalsize{%
  \@setfontsize\normalsize{\bx@bp{10}}{\bx@bp{12.5}}%
  \abovedisplayskip 3pt \@plus 1pt \@minus 1pt
  \abovedisplayshortskip 1pt \@plus 1pt
  \belowdisplayshortskip 2pt \@plus 1pt \@minus 1pt
  \belowdisplayskip \abovedisplayskip
  \let\@listi\@listI}
\normalsize
\renewcommand\small{\@setfontsize\small{\bx@bp{9}}{\bx@bp{11.25}}}
\renewcommand\footnotesize{\@setfontsize\footnotesize{\bx@bp{8}}{\bx@bp{10}}}
\renewcommand\scriptsize{\@setfontsize\scriptsize{\bx@bp{7}}{\bx@bp{8.75}}}

\newcommand\bx@titlefont{\sffamily\bfseries\bx@size{21}{25.2}}
\newcommand\bx@authorfont{\sffamily\bfseries\bx@size{11}{13.2}}
\newcommand\bx@affilfont{\sffamily\bx@size{9}{10.8}}
\newcommand\bx@abstractfont{\sffamily\bfseries\bx@size{9}{10.8}}
\newcommand\bx@hfont{\sffamily\bx@size{9}{10.8}}% header/footer
\newcommand\bx@methodsfont{%
  \bx@size{8}{10}
  \abovedisplayskip 2pt \@plus 1pt \@minus 1pt
  \belowdisplayskip \abovedisplayskip
  \abovedisplayshortskip 1pt \@plus 1pt
  \belowdisplayshortskip 1pt \@plus 1pt}
\newcommand\bx@captionfont{\sffamily\bx@size{8}{9.6}}
\newcommand\bx@codefont{\ttfamily\bx@size{8}{9.12}}

\setlength{\parindent}{5mm}   % "Main Text with Tab": 284 twips
\setlength{\parskip}{0pt}
\renewcommand{\baselinestretch}{1}
\setlength{\emergencystretch}{1.5em}
\clubpenalty=10000   % Word: widow/orphan control
\widowpenalty=10000
\frenchspacing       % Word puts a single space after full stops
\raggedbottom        % Word does not stretch columns to equal height

%% ----------------------------------------------------------------- metadata
\newcommand\bx@runningtitle{Running title}
\newcommand\runningtitle[1]{\renewcommand\bx@runningtitle{#1}}
\newcommand\bx@footer{Lastname et al. \the\year\ (preprint)}
\newcommand\preprintfooter[1]{\renewcommand\bx@footer{#1}}
\newcommand\bx@logofile{biorxiv-logo}
\newcommand\logo[1]{\renewcommand\bx@logofile{#1}}

% superscript affiliation marks: red, bold, Helvetica
\newcommand\affil[1]{\textsuperscript{\textcolor{bxred}{\bfseries\sffamily #1}}}
% affiliation list
\newcommand\bx@affils{}
\newcommand\address[2]{%
  \g@addto@macro\bx@affils{\affil{#1}#2\par}}
\newcommand\bx@correspondence{}
\newcommand\correspondence[1]{%
  \renewcommand\bx@correspondence{%
    \textcolor{bxred}{\bfseries *}#1\par}}

% abstract environment: stored, typeset by \maketitle
\newcommand\bx@abstract{}
\RenewEnviron{abstract}{\global\let\bx@abstract\BODY}

%% ----------------------------------------------------------------- title block
\newlength\bx@logowidth  \setlength\bx@logowidth{42.86mm}
\newcommand\bx@titleblock{%
  \parindent\z@
  \ifbx@logo
    \includegraphics[width=\bx@logowidth]{\bx@logofile}\par
    \vskip 7.8pt
  \else
    \vskip 0pt
  \fi
  {\bx@titlefont\raggedright\@title\par}%
  \vskip 15.75pt
  {\bx@authorfont\raggedright\@author\par}%
  \vskip 1.1pt
  {\bx@affilfont\raggedright\bx@affils\bx@correspondence}%
  \vskip 10.8pt
  \ifx\bx@abstract\@empty\else
    {\bx@abstractfont\bx@abstract\par}%
  \fi
  \vskip 25.4pt}
\renewcommand\maketitle{%
  \twocolumn[\bx@titleblock]%
  \thispagestyle{bxfirst}%
  \global\let\bx@titleblock\relax}

%% ----------------------------------------------------------------- header/footer
\fancypagestyle{bxfirst}{%
  \fancyhf{}%
  \renewcommand\headrulewidth{0pt}%
  \renewcommand\footrulewidth{0pt}%
  \fancyfoot[L]{\bx@hfont\bx@footer}%
  \fancyfoot[R]{\bx@hfont\thepage}}
\fancypagestyle{bxmain}{%
  \fancyhf{}%
  \renewcommand\headrulewidth{0pt}%
  \renewcommand\footrulewidth{0pt}%
  \fancyhead[C]{\bx@hfont\itshape\bx@runningtitle}%
  \fancyfoot[L]{\bx@hfont\bx@footer}%
  \fancyfoot[R]{\bx@hfont\thepage}}
\fancypagestyle{plain}{\pagestyle{bxfirst}}
\pagestyle{bxmain}

%% ----------------------------------------------------------------- headings
%% Heading 1: Helvetica bold 11 pt, #C00000, 6 pt before
%% Heading 2: Helvetica bold  9 pt, #C00000, 6 pt before (0 pt right after H1)
%% Methods subheading: Helvetica bold 7.5 pt, #C00000, 4 pt before (0 after H1)
\setcounter{secnumdepth}{0}
\newskip\bx@subsecbefore  \bx@subsecbefore=6pt
\newskip\bx@subsecafter   \bx@subsecafter=0pt
\newcommand\bx@subsecfont{\bx@size{9}{10.8}}
\newcommand\bx@methsubfont{\bx@size{7.5}{9}}
\newif\ifbx@afterhead

\titleformat{\section}
  {\sffamily\bfseries\bx@size{11}{13.2}\color{bxred}\raggedright}
  {}{0pt}{}[\global\bx@afterheadtrue]
\titlespacing*{\section}{0pt}{6pt plus 2pt minus 1pt}{-0.4pt}

\titleformat{\subsection}
  {\sffamily\bfseries\bx@subsecfont\color{bxred}\raggedright}
  {}{0pt}{}[\global\bx@afterheadtrue]
\titlespacing*{\subsection}{0pt}{0pt}{\bx@subsecafter}

\titleformat{\subsubsection}
  {\sffamily\bfseries\bx@methsubfont\color{bxred}\raggedright}
  {}{0pt}{}[\global\bx@afterheadtrue]
\titlespacing*{\subsubsection}{0pt}{0pt}{-0.5pt}

% "First subheading has no extra space before it":
% the space before a (sub)subheading is dropped when it directly follows
% another heading.
\AddToHook{para/begin}{\global\bx@afterheadfalse}
\let\bx@orig@subsection\subsection
\let\bx@orig@subsubsection\subsubsection
\renewcommand\subsection{%
  \par\ifbx@afterhead\else\addvspace{\bx@subsecbefore}\fi
  \bx@orig@subsection}
\renewcommand\subsubsection{%
  \par\ifbx@afterhead\else\addvspace{4pt}\fi
  \bx@orig@subsubsection}

%% ----------------------------------------------------------------- methods
%% "Methods Text": STIX Two 8/10 pt; subsections become methods subheadings.
%% Use it for Acknowledgements, Author contributions, Competing interests and
%% Materials and Methods (exactly as in the Word template).
\newenvironment{methods}{%
  \par\bx@methodsfont
  \renewcommand\bx@subsecfont{\bx@methsubfont}%
  \bx@subsecbefore=4pt
  \bx@subsecafter=-0.5pt
  \setlength{\parindent}{5mm}}{\par}
\newenvironment{backmatter}{\begin{methods}}{\end{methods}}

%% ----------------------------------------------------------------- figures
%% Figure widths from the Word template
\newlength\onecolumnwidth     \setlength\onecolumnwidth{89mm}
\newlength\onehalfcolumnwidth \setlength\onehalfcolumnwidth{133.125mm}
\newlength\twocolumnwidth     \setlength\twocolumnwidth{183.9mm}

\DeclareCaptionFont{bxcap}{\bx@captionfont}
\DeclareCaptionFont{bxred}{\color{bxred}}
\captionsetup{font=bxcap, labelfont={bf,bxred}, labelsep=colon,
  justification=justified, singlelinecheck=false, skip=1.9pt,
  margin=0pt, parskip=0pt}
\captionsetup[table]{position=top, skip=3pt}

% Legend title (bold red) and panel letters
\newcommand\figtitle[1]{{\color{bxred}\bfseries #1}}
\newcommand\panel[1]{{\color{bxred}\bfseries(#1)}}

% Blue placeholder box, as used in the Word template
\newcommand\figureplaceholder[2]{%
  {\color{bxplaceholder}\rule{#1}{#2}}}

% Float spacing (caption -> text = one empty 8 pt legend line in Word)
\setlength{\textfloatsep}{10.6pt plus 2pt minus 2pt}
\setlength{\dbltextfloatsep}{10.6pt plus 2pt minus 2pt}
\setlength{\floatsep}{8pt plus 2pt minus 2pt}
\setlength{\dblfloatsep}{8pt plus 2pt minus 2pt}
\setlength{\intextsep}{8pt plus 2pt minus 2pt}
\renewcommand{\topfraction}{0.9}
\renewcommand{\dbltopfraction}{0.9}
\renewcommand{\textfraction}{0.07}
\renewcommand{\floatpagefraction}{0.8}
\renewcommand{\dblfloatpagefraction}{0.8}
\setcounter{topnumber}{3}
% float-only pages: floats start at the top, like anchored Word figures
\setlength{\@fptop}{0pt}\setlength{\@fpsep}{8pt plus 2pt}\setlength{\@fpbot}{0pt plus 1fil}
\setlength{\@dblfptop}{0pt}\setlength{\@dblfpsep}{8pt plus 2pt}\setlength{\@dblfpbot}{0pt plus 1fil}
\setcounter{dbltopnumber}{3}

%% ----------------------------------------------------------------- lists
\setlist{nosep, leftmargin=5mm}

%% ----------------------------------------------------------------- references
%% Word "References" style: 8/10 pt, label flush left, 6.3 mm hanging indent
\ifbx@supercite
  \RequirePackage[super,comma,sort&compress]{natbib}
\else
  \RequirePackage[numbers,square,comma,sort&compress]{natbib}
\fi
\renewcommand\bibfont{\bx@size{8}{10}}
\setlength{\bibsep}{0pt}
\renewcommand\bibnumfmt[1]{#1.}
\renewcommand\bibsection{\section*{\refname}}
\newcommand\bx@biblabel[1]{#1\hfil}
\apptocmd{\NAT@bibsetnum}{%
  \setlength{\leftmargin}{17.85pt}%
  \setlength{\labelsep}{0pt}%
  \setlength{\labelwidth}{\leftmargin}%
  \setlength{\itemindent}{0pt}%
  \setlength{\listparindent}{0pt}%
  \let\makelabel\bx@biblabel}{}{%
  \ClassWarningNoLine{biorxiv}{Could not patch natbib's bibliography list}}

%% ----------------------------------------------------------------- supplement
%% \supplementary starts a new single-column part; figures and tables are
%% numbered S1, S2, ...; level-1 headings are centred (Word template p. 9).
\newcommand\supplementary{%
  \onecolumn
  \setcounter{figure}{0}\setcounter{table}{0}\setcounter{equation}{0}%
  \renewcommand\thefigure{S\arabic{figure}}%
  \renewcommand\thetable{S\arabic{table}}%
  \renewcommand\theequation{S\arabic{equation}}%
  \titleformat{\section}
    {\vspace*{6.6pt}\sffamily\bfseries\bx@size{11}{13.2}\color{bxred}\centering}
    {}{0pt}{}[\global\bx@afterheadtrue]%
  \titlespacing*{\section}{0pt}{0pt}{10.5pt}}

%% Supplementary code: Courier, 8 pt, grey #666666
\lstdefinestyle{biorxiv}{%
  basicstyle=\bx@codefont\color{bxcode},
  columns=fixed, basewidth=0.6em, keepspaces=true,
  breaklines=true, breakindent=0pt, showstringspaces=false,
  upquote=true, aboveskip=0pt, belowskip=0pt,
  xleftmargin=0pt, frame=none, tabsize=2}
\lstset{style=biorxiv}
\lstnewenvironment{code}[1][]{\lstset{style=biorxiv,#1}}{}

%% ----------------------------------------------------------------- hyperlinks
\AtEndPreamble{%
  \RequirePackage[hidelinks]{hyperref}%
  \urlstyle{same}}

\endinput
