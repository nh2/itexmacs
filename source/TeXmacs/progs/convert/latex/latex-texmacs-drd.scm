
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : latex-texmacs-drd.scm
;; DESCRIPTION : TeXmacs extensions to LaTeX
;; COPYRIGHT   : (C) 2005  Joris van der Hoeven
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (convert latex latex-texmacs-drd))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra TeXmacs symbols
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(drd-table latex-texmacs-symbol%
  ;; arrows with limits
  (leftarrowlim "\\mathop{\\leftarrow}\\limits")
  (rightarrowlim "\\mathop{\\rightarrow}\\limits")
  (leftrightarrowlim "\\mathop{\\leftrightarrow}\\limits")
  (mapstolim "\\mathop{\\mapsto}\\limits")
  (longleftarrowlim "\\mathop{\\longleftarrow}\\limits")
  (longrightarrowlim "\\mathop{\\longrightarrow}\\limits")
  (longleftrightarrowlim "\\mathop{\\longleftrightarrow}\\limits")
  (longmapstolim "\\mathop{\\longmapsto}\\limits")
  (leftsquigarrowlim "\\mathop{\\leftsquigarrow}\\limits")
  (rightsquigarrowlim "\\mathop{\\rightsquigarrow}\\limits")
  (leftrightsquigarrowlim "\\mathop{\\leftrightsquigarrow}\\limits")
  (equallim "\\mathop{=}\\limits")
  (longequallim "\\mathop{\\longequal}\\limits")
  (Leftarrowlim "\\mathop{\\leftarrow}\\limits")
  (Rightarrowlim "\\mathop{\\rightarrow}\\limits")
  (Leftrightarrowlim "\\mathop{\\leftrightarrow}\\limits")
  (Longleftarrowlim "\\mathop{\\longleftarrow}\\limits")
  (Longrightarrowlim "\\mathop{\\longrightarrow}\\limits")
  (Longleftrightarrowlim "\\mathop{\\longleftrightarrow}\\limits")
   
  ;; asymptotic relations by Joris
  (nasymp "\\not\\asymp")
  (asympasymp "{\\asymp\\!\\!\\!\\!\\!\\!-}")
  (nasympasymp "{\\not\\asymp\\!\\!\\!\\!\\!\\!-}")
  (simsim "{\\approx\\!\\!\\!\\!\\!\\!-}")
  (nsimsim "{\\not\\approx\\!\\!\\!\\!\\!\\!-}")
  (npreccurlyeq "\\not\\preccurlyeq")
  (precprec "\\prec\\!\\!\\!\\prec")
  (precpreceq "\\preceq\\!\\!\\!\\preceq")
  (precprecprec "\\prec\\!\\!\\!\\prec\\!\\!\\!\\prec")
  (precprecpreceq "\\preceq\\!\\!\\!\\preceq\\!\\!\\!\\preceq")
  (succsucc "\\succ\\!\\!\\!\\succ")
  (succsucceq "\\succeq\\!\\!\\!\\succeq")
  (succsuccsucc "\\succ\\!\\!\\!\\succ\\!\\!\\!\\succ")
  (succsuccsucceq "\\succeq\\!\\!\\!\\succeq\\!\\!\\!\\succeq")
  (lleq "\\leq\\negmedspace\\negmedspace\\leq")
  (llleq "\\leq\\negmedspace\\negmedspace\\leq\\negmedspace\\negmedspace\\leq")
  (ggeq "\\geq\\negmedspace\\negmedspace\\geq")
  (gggeq "\\geq\\negmedspace\\negmedspace\\geq\\negmedspace\\negmedspace\\geq")

  ;; extra literal symbols
  (btimes "{\\mbox{\\rotatebox[origin=c]{90}{$\\ltimes$}}}")
  (Backepsilon "{\\mbox{\\rotatebox[origin=c]{180}{E}}}")
  (Mho "{\\mbox{\\rotatebox[origin=c]{180}{$\\Omega$}}}")
  (mapmulti "{\\mbox{\\rotatebox[origin=c]{180}{$\\multimap$}}}")
  (mathcatalan "C")
  (mathd "\\mathrm{d}")
  (mathe "\\mathrm{e}")
  (matheuler "\\gamma")
  (mathlambda "\\lambda")
  (mathi "\\mathrm{i}")
  (mathpi "\\pi")
  (Alpha "\\mathrm{A}")
  (Beta "\\mathrm{B}")
  (Epsilon "\\mathrm{E}")
  (Eta "\\mathrm{H}")
  (Iota "\\mathrm{I}")
  (Kappa "\\mathrm{K}")
  (Mu "\\mathrm{M}")
  (Nu "\\mathrm{N}")
  (Omicron "\\mathrm{O}")
  (Chi "\\mathrm{X}")
  (Rho "\\mathrm{P}")
  (Tau "\\mathrm{T}")
  (Zeta "\\mathrm{Z}")

  ;; other extra symbols
  (exterior "\\wedge")
  (Exists "\\exists")
  (bigintwl "\\int")
  (bigointwl "\\oint")
  (asterisk "*")
  (point ".")
  (cdummy "\\cdot")
  (comma "{,}")
  (bignone "")
  (nobracket "")
  (nospace "")
  (nocomma "")
  (noplus "")
  (nosymbol "")
  (nin "\\not\\in")
  (nni "\\not\\ni")
  (notni "\\not\\ni")
  (nequiv "\\not\\equiv")
  (nleadsto "\\not\\leadsto")
  (dotamalg "\\mathaccent95{\\amalg}")
  (dottimes "\\mathaccent95{\\times}")
  (dotoplus "\\mathaccent95{\\oplus}")
  (dototimes "\\mathaccent95{\\otimes}")
  (into "\\rightarrow")
  (longequal "{=\\!\\!=}")
  (longhookrightarrow "{\\lhook\\joinrel\\relbar\\joinrel\\rightarrow}")
  (longhookleftarrow "{\\leftarrow\\joinrel\\relbar\\joinrel\\rhook}")
  (longdownarrow "\\downarrow")
  (longuparrow "\\uparrow")
  (triangleup "\\triangle")
  (precdot "{\\prec\\hspace{-0.6em}\\cdot}\\;\\,")
  (preceqdot "{\\preccurlyeq\\hspace{-0.6em}\\cdot}\\;\\,")
  (llangle "{\\langle\\!\\langle}")
  (rrangle "{\\rangle\\!\\rangle}")
  (join "\\Join")
  (um "-")
  (upl "+")
  (upm "\\pm")
  (ump "\\mp")
  (upequal "{\\mbox{\\rotatebox[origin=c]{90}{$=$}}}")
  (assign ":=")
  (plusassign "+\\!\\!=")
  (minusassign "-\\!\\!=")
  (timesassign "\times\\!\\!=")
  (overassign "/\\!\\!=")
  (lflux "\\ll")
  (gflux "\\gg")
  (colons "\\,:\\,")
  (transtype "\\,:\\!!>")
  (udots "{\\mathinner{\\mskip1mu\\raise1pt\\vbox{\\kern7pt\\hbox{.}}\\mskip2mu\\raise4pt\\hbox{.}\\mskip2mu\\raise7pt\\hbox{.}\\mskip1mu}}"))

(drd-rules
  ((latex-texmacs-macro% 'x 'body) (latex-texmacs-symbol% 'x 'body))
  ((latex-texmacs-arity% 'x 0) (latex-texmacs-symbol% 'x 'body))
  ;;;
  ((latex-texmacs-tag% 'x) (latex-texmacs-macro% 'x 'body))
  ((latex-arity% 'x 'arity) (latex-texmacs-arity% 'x 'arity))
  ((latex-symbol% 'x) (latex-texmacs-symbol% 'x 'body)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra TeXmacs macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(drd-table latex-texmacs-0%
  (tmunsc "\\_")
  (emdash "---")
  (tmat "\\symbol{\"40}")
  (tmbsl "\\ensuremath{\\backslash}")
  (tmdummy "$\\mbox{}$")
  (TeXmacs "T\\kern-.1667em\\lower.5ex\\hbox{E}\\kern-.125emX\\kern-.1em\\lower.5ex\\hbox{\\textsc{m\\kern-.05ema\\kern-.125emc\\kern-.05ems}}")
  (madebyTeXmacs (footnote (!recurse (withTeXmacstext))))
  (withTeXmacstext
   (!append (!translate "This document has been produced using") " "
	    (!recurse (TeXmacs)) " (" (!translate "see") " "
	    (texttt "http://www.texmacs.org") ")"))
  (scheme "{\\sc Scheme}")
  (pari "{\\sc Pari}"))

(drd-table latex-texmacs-1%
  (tmrsub (ensuremath (!append "_{" (textrm 1) "}")))
  (tmrsup (ensuremath (!append "^{" (textrm 1) "}")))
  (tmtextrm (!group (rmfamily) (!group 1)))
  (tmtextsf (!group (sffamily) (!group 1)))
  (tmtexttt (!group (ttfamily) (!group 1)))
  (tmtextmd (!group (mdseries) (!group 1)))
  (tmtextbf (!group (bfseries) (!group 1)))
  (tmtextup (!group (upshape) (!group 1)))
  (tmtextsl (!group (slshape) (!group 1)))
  (tmtextit (!group (itshape) (!group 1)))
  (tmtextsc (!group (scshape) (!group 1)))
  (tmmathbf (ensuremath (boldsymbol 1)))
  (tmop (ensuremath (operatorname 1)))
  (tmstrong (textbf 1))
  (tmem (!group "\\em " 1 "\\/"))
  (tmtt (texttt 1))
  (tmname (textsc 1))
  (tmsamp (textsf 1))
  (tmabbr 1)
  (tmdfn (textbf 1))
  (tmkbd (texttt 1))
  (tmvar (texttt 1))
  (tmacronym (textsc 1))
  (tmperson (textsc 1))
  (tmscript (text (scriptsize (!math 1))))
  (tmdef 1)
  (dueto (textup (textbf (!append "(" 1 ") "))))
  (op 1)
  (email (!group (textit (!translate "Email:")) " " (texttt 1)))
  (homepage (!group (textit (!translate "Web:")) " "(texttt 1)))
  (keywords (!group (textbf (!translate "Keywords:")) " " 1))
  (AMSclass (!group (textbf (!translate "A.M.S. subject classification:"))
		    " " 1)))

(drd-table latex-texmacs-2%
  (tmhlink (!group "\\color{blue} " 1))
  (tmaction (!group "\\color{blue} " 1))
  (subindex (index (!append 1 "!" 2))))

(drd-table latex-texmacs-3%
  (subsubindex (index (!append 1 "!" 2 "!" 3)))
  (tmref 1)
  (glossaryentry (!append (item (!option (!append 1 (hfill)))) 2 (dotfill) 3)))

(drd-table latex-texmacs-4%
  (subsubsubindex (index (!append 1 "!" 2 "!" 3 "!" 4))))

(drd-rules
  ((latex-texmacs-macro% 'x 'body) (latex-texmacs-0% 'x 'body))
  ((latex-texmacs-arity% 'x 0) (latex-texmacs-0% 'x 'body))
  ((latex-texmacs-macro% 'x 'body) (latex-texmacs-1% 'x 'body))
  ((latex-texmacs-arity% 'x 1) (latex-texmacs-1% 'x 'body))
  ((latex-texmacs-macro% 'x 'body) (latex-texmacs-2% 'x 'body))
  ((latex-texmacs-arity% 'x 2) (latex-texmacs-2% 'x 'body))
  ((latex-texmacs-macro% 'x 'body) (latex-texmacs-3% 'x 'body))
  ((latex-texmacs-arity% 'x 3) (latex-texmacs-3% 'x 'body))
  ((latex-texmacs-macro% 'x 'body) (latex-texmacs-4% 'x 'body))
  ((latex-texmacs-arity% 'x 4) (latex-texmacs-4% 'x 'body))
  ;;;
  ((latex-texmacs% 'x) (latex-texmacs-0% 'x 'body))
  ((latex-texmacs% 'x) (latex-texmacs-1% 'x 'body))
  ((latex-texmacs% 'x) (latex-texmacs-2% 'x 'body))
  ((latex-texmacs% 'x) (latex-texmacs-3% 'x 'body))
  ((latex-texmacs% 'x) (latex-texmacs-4% 'x 'body)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra TeXmacs environments
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(drd-table latex-texmacs-environment%
  ("proof"
   (!append (noindent) (textbf (!append (!translate "Proof") "\\ "))
	    ---
	    (hspace* (fill)) (!math (Box)) (medskip)))
  ("proof*"
   (!append (noindent) (textbf (!append 1 "\\ "))
	    ---
	    (hspace* (fill)) (!math (Box)) (medskip)))
  ("left-aligned"
   (!append (!begin "flushleft")
	    ---
            (!end "flushleft")))
  ("right-aligned"
   (!append (!begin "flushright")
	    ---
            (!end "flushright")))
  ("tmparmod"
   ((!begin "list" "" (!append "\\setlength{\\topsep}{0pt}"
			       "\\setlength{\\leftmargin}{" 1 "}"
			       "\\setlength{\\rightmargin}{" 2 "}"
			       "\\setlength{\\parindent}{" 3 "}"
			       "\\setlength{\\listparindent}{\\parindent}"
			       "\\setlength{\\itemindent}{\\parindent}"
			       "\\setlength{\\parsep}{\\parskip}"))
    (!append "\\item[]"
	     ---)))
  ("tmparsep"
   (!append (begingroup) "\\setlength{\\parskip}{" 1 "}"
	     ---
	     (endgroup)))
  ("tmindent"
   ((!begin "tmparmod" "1.5em" "0pt" "0pt") ---))
  ("elsequation" ((!begin "eqnarray") (!append --- "&&")))
  ("elsequation*" ((!begin "eqnarray*") (!append --- "&&")))
  ("theglossary"
   ((!begin "list" "" (!append "\\setlength{\\labelwidth}{6.5em}"
			       "\\setlength{\\leftmargin}{7em}"
			       "\\small")) ---)))

(drd-table latex-texmacs-env-arity%
  ("proof" 0)
  ("proof*" 1)
  ("tmparmod" 3)
  ("tmparsep" 1)
  ("tmindent" 0)
  ("proof" 0)
  ("elsequation" 0)
  ("elsequation*" 0)
  ("theglossary" 1))

(drd-group latex-texmacs-tag%
  begin-proof begin-proof* begin-tmparmod begin-tmparsep begin-tmindent
  begin-elsequation begin-elsequation* begin-theglossary)

(drd-group latex-environment-0%
  begin-proof begin-tmindent begin-elsequation begin-elsequation*)

(drd-group latex-environment-1%
  begin-proof* begin-theglossary)

(drd-group latex-environment-3%
  begin-tmparmod begin-tmparsep)

(define-macro (latex-texmacs-itemize env lab)
  (with env-sym (string->symbol (string-append "begin-" env))
    `(begin
       (drd-table latex-texmacs-environment%
	 (,env
	  ((!begin "itemize")
	   (!append "\\renewcommand{\\labelitemi}{" ,lab "}"
		    "\\renewcommand{\\labelitemii}{" ,lab "}"
		    "\\renewcommand{\\labelitemiii}{" ,lab "}"
		    "\\renewcommand{\\labelitemiv}{" ,lab "}"
		    ---))))
       (drd-table latex-texmacs-env-arity% (,env 0))
       ;;;
       (drd-group latex-texmacs-tag% ,env-sym)
       (drd-group latex-list% ,env-sym))))

(define-macro (latex-texmacs-enumerate env lab)
  (with env-sym (string->symbol (string-append "begin-" env))
    `(begin
       (drd-table latex-texmacs-environment%
	 (,env ((!begin "enumerate" (!option ,lab)) ---)))
       (drd-table latex-texmacs-env-arity% (,env 0))
       ;;;
       (drd-group latex-texmacs-tag% ,env-sym)
       (drd-group latex-list% ,env-sym))))

(define-macro (latex-texmacs-description env)
  (with env-sym (string->symbol (string-append "begin-" env))
    `(begin
       (drd-table latex-texmacs-environment%
	 (,env ((!begin "description") ---)))
       (drd-table latex-texmacs-env-arity% (,env 0))
       ;;;
       (drd-group latex-texmacs-tag% ,env-sym)
       (drd-group latex-list% ,env-sym))))

(latex-texmacs-itemize "itemizeminus" "$-$")
(latex-texmacs-itemize "itemizedot" "$\\bullet$")
(latex-texmacs-itemize "itemizearrow" "$\\rightarrow$")
(latex-texmacs-enumerate "enumeratenumeric" "1.")
(latex-texmacs-enumerate "enumerateroman" "i.")
(latex-texmacs-enumerate "enumerateromancap" "I.")
(latex-texmacs-enumerate "enumeratealpha" "a{\\textup{)}}")
(latex-texmacs-enumerate "enumeratealphacap" "A.")
(latex-texmacs-description "descriptioncompact")
(latex-texmacs-description "descriptionaligned")
(latex-texmacs-description "descriptiondash")
(latex-texmacs-description "descriptionlong")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra preamble definitions which are needed to export certain macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(drd-table latex-texmacs-preamble%
  (mho
   (!append
    "\\renewcommand{\\mho}{\\mbox{\\rotatebox[origin=c]{180}{$\\omega$}}}"))
  (color
   (!append
    "\\definecolor{grey}{rgb}{0.75,0.75,0.75}\n"
    "\\definecolor{orange}{rgb}{1.0,0.5,0.5}\n"
    "\\definecolor{brown}{rgb}{0.5,0.25,0.0}\n"
    "\\definecolor{pink}{rgb}{1.0,0.5,0.5}\n"))
  (tmfloat
   (!append
    "\\newcommand{\\tmfloatcontents}{}\n"
    "\\newlength{\\tmfloatwidth}\n"
    "\\newcommand{\\tmfloat}[5]{\n"
    "  \\renewcommand{\\tmfloatcontents}{#4}\n"
    "  \\setlength{\\tmfloatwidth}{\\widthof{\\tmfloatcontents}+1in}\n"
    "  \\ifthenelse{\\equal{#2}{small}}\n"
    "    {\\ifthenelse{\\lengthtest{\\tmfloatwidth > \\linewidth}}\n"
    "      {\\setlength{\\tmfloatwidth}{\\linewidth}}{}}\n"
    "    {\\setlength{\\tmfloatwidth}{\\linewidth}}\n"
    "  \\begin{minipage}[#1]{\\tmfloatwidth}\n"
    "    \\begin{center}\n"
    "      \\tmfloatcontents\n"
    "      \\captionof{#3}{#5}\n"
    "    \\end{center}\n"
    "  \\end{minipage}}\n")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Plain style theorems
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (latex-texmacs-thmenv prim name before after)
  (with env-sym (string->symbol (string-append "begin-" prim))
    `(begin
       (drd-table latex-texmacs-env-preamble%
	 (,prim (!append ,@before (newtheorem ,prim (!translate ,name))
			 ,@after "\n")
		no-amsthm-package%))
       ;;;
       (drd-group latex-texmacs-tag% ,env-sym)
       (drd-group latex-environment-0% ,env-sym))))

(define-macro (latex-texmacs-theorem prim name)
  `(latex-texmacs-thmenv ,prim ,name () ()))

(define-macro (latex-texmacs-remark prim name)
  `(latex-texmacs-thmenv
    ,prim ,name ("{" (!recurse (theorembodyfont "\\rmfamily"))) ("}")))

(define-macro (latex-texmacs-exercise prim name)
  `(latex-texmacs-thmenv
    ,prim ,name ("{" (!recurse (theorembodyfont "\\rmfamily\\small"))) ("}")))

(latex-texmacs-theorem "theorem" "Theorem")
(latex-texmacs-theorem "proposition" "Proposition")
(latex-texmacs-theorem "lemma" "Lemma")
(latex-texmacs-theorem "corollary" "Corollary")
(latex-texmacs-theorem "axiom" "Axiom")
(latex-texmacs-theorem "definition" "Definition")
(latex-texmacs-theorem "notation" "Notation")
(latex-texmacs-theorem "conjecture" "Conjecture")
(latex-texmacs-remark "remark" "Remark")
(latex-texmacs-remark "note" "Note")
(latex-texmacs-remark "example" "Example")
(latex-texmacs-remark "convention" "Convention")
(latex-texmacs-remark "warning" "Warning")
(latex-texmacs-remark "acknowledgments" "Acknowledgments")
(latex-texmacs-exercise "exercise" "Exercise")
(latex-texmacs-exercise "problem" "Problem")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AMS style theorems
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (ams-texmacs-theorem abbr full)
  `(begin
     (drd-table latex-texmacs-env-preamble%
       (,abbr (!append "\\theoremstyle{plain}\n"
		       (newtheorem ,abbr (!translate ,full))
		       "\n")
	      amsthm-package%))))

(define-macro (ams-texmacs-remark abbr full)
  `(begin
     (drd-table latex-texmacs-env-preamble%
       (,abbr (!append "\\theoremstyle{remark}\n"
		       (newtheorem ,abbr (!translate ,full))
		       "\n")
	      amsthm-package%))))

(ams-texmacs-theorem "theorem" "Theorem")
(ams-texmacs-theorem "proposition" "Proposition")
(ams-texmacs-theorem "lemma" "Lemma")
(ams-texmacs-theorem "corollary" "Corollary")
(ams-texmacs-theorem "axiom" "Axiom")
(ams-texmacs-theorem "definition" "Definition")
(ams-texmacs-theorem "notation" "Notation")
(ams-texmacs-theorem "conjecture" "Conjecture")
(ams-texmacs-remark "remark" "Remark")
(ams-texmacs-remark "note" "Note")
(ams-texmacs-remark "example" "Example")
(ams-texmacs-remark "convention" "Convention")
(ams-texmacs-remark "acknowledgments" "Acknowledgments")
(ams-texmacs-remark "warning" "Warning")
(ams-texmacs-remark "exercise" "Exercise")
(ams-texmacs-remark "problem" "Problem")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Style-dependent extra macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(drd-table latex-texmacs-0%
  (appendix "" letter-style%))

(define-macro (latex-texmacs-section name inside . conds)
  `(drd-table latex-texmacs-1%
     (,name (!append (medskip) (bigskip) "\n\n" (noindent) (textbf ,inside))
	    ,@conds)))

(define-macro (latex-texmacs-paragraph name inside . conds)
  `(drd-table latex-texmacs-1%
     (,name (!append (smallskip) "\n\n" (noindent) (textbf ,inside))
	    ,@conds)))

(latex-texmacs-section chapter (!append "\\huge " 1) article-style%)
(latex-texmacs-section chapter (!append "\\huge " 1) letter-style%)
(latex-texmacs-section section (!append "\\LARGE " 1) letter-style%)
(latex-texmacs-section subsection (!append "\\Large " 1) letter-style%)
(latex-texmacs-section subsubsection (!append "\\large " 1) letter-style%)
(latex-texmacs-paragraph paragraph 1 letter-style%)
(latex-texmacs-paragraph subparagraph 1 letter-style%)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deprecated extra macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(drd-table latex-texmacs-0%
  (labeleqnum "\\addtocounter{equation}{-1}\\refstepcounter{equation}\\addtocounter{equation}{1})")
  (eqnumber (!append "\\hfill(\\theequation" (!recurse (labeleqnum)) ")"))
  (leqnumber (!append "(\\theequation" (!recurse (labeleqnum)) ")\\hfill"))
  (reqnumber (!append "\\hfill(\\theequation" (!recurse (labeleqnum)) ")")))

(drd-table latex-texmacs-1%
  (key (!append "\\fbox{\\rule[-2pt]{0pt}{9pt}" (texttt 1) "}"))
  (skey (!recurse (key (!append "shift-" 1))))
  (ckey (!recurse (key (!append "ctrl-" 1))))
  (akey (!recurse (key (!append "alt-" 1))))
  (mkey (!recurse (key (!append "meta-" 1))))
  (hkey (!recurse (key (!append "hyper-" 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Language specific preambles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(drd-table latex-preamble-language-def%
  ("bulgarian"
   "\\usepackage[cp1251]{inputenc}\n\\usepackage[bulgarian]{babel}")
  ("czech" "\\usepackage[czech]{babel}")
  ("danish" "\\usepackage[danish]{babel}")
  ("dutch" "\\usepackage[dutch]{babel}")
  ("finnish" "\\usepackage[finnish]{babel}")
  ("french" "\\usepackage[french]{babel}")
  ("german" "\\usepackage[german]{babel}")
  ("hungarian" "\\usepackage[hungarian]{babel}")
  ("italian" "\\usepackage[italian]{babel}")
  ("polish" "\\usepackage[polish]{babel}")
  ("portuguese" "\\usepackage[portuges]{babel}")
  ("romanian" "\\usepackage[romanian]{babel}")
  ("russian" "\\usepackage[cp1251]{inputenc}\n\\usepackage[russian]{babel}")
  ("slovene" "\\usepackage[slovene]{babel}")
  ("spanish" "\\usepackage[spanish]{babel}")
  ("swedish" "\\usepackage[swedish]{babel}")
  ("ukrainian"
   "\\usepackage[cp1251]{inputenc}\n\\usepackage[ukrainian]{babel}"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Catcode tables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(drd-table corkT1-to-latex-catcodes%
  ("\x00" "\\`{ }")
  ("\x01" "\\'{ }")
  ("\x02" "\\^{ }")
  ("\x03" "\\~{ }")
  ("\x04" "\\\"{ }")
  ("\x05" "\\H{ }")
  ("\x06" "\\r{ }")
  ("\x07" "\\v{ }")
  ("\x08" "\\u{ }")
  ("\x09" "\\b{ }")
;  ("\x0A" "\\.{ }") ; newline may still be present in strings!!!
  ("\x0B" "\\c{ }")
  ("\x0C" "\\k{ }")
  ("\x0D" ",")
  ("\x0E" "{\\guilsinglleft}")
  ("\x0F" "{\\guilsinglright}")
  ("\x10" "``")
  ("\x11" "''")
  ("\x12" ",,")
  ("\x13" "<<")
  ("\x14" ">>")
  ("\x15" "--")
  ("\x16" "---")
  ("\x17" "{}")
  ("\x18" "{}")
  ("\x19" "\\i")
  ("\x1A" "\\j")
  ("\x1B" "ff")
  ("\x1C" "fi")
  ("\x1D" "fl")
  ("\x1E" "ffi")
  ("\x1F" "ffl")
  ("\x80" "\\u{A}")
  ("\x81" "\\k{A}")
  ("\x82" "\\'C")
  ("\x83" "\\v{C}")
  ("\x84" "\\v{D}")
  ("\x85" "\\v{E}")
  ("\x86" "\\k{E}")
  ("\x87" "\\u{G}")
  ("\x88" "\\'L")
  ("\x89" "\\v{L}")
  ("\x8A" "\\L")
  ("\x8B" "\\'N")
  ("\x8C" "\\v{N}")
  ("\x8D" "{\\NG}")
  ("\x8E" "\\H{O}")
  ("\x8F" "\\'R")
  ("\x90" "\\v{R}")
  ("\x91" "\\'S")
  ("\x92" "\\v{S}")
  ("\x93" "\\c{S}")
  ("\x94" "\\v{T}")
  ("\x95" "\\c{T}")
  ("\x96" "\\H{U}")
  ("\x97" "\\r{U}")
  ("\x98" "\\\"Y")
  ("\x99" "\\'Z")
  ("\x9A" "\\v{Z}")
  ("\x9B" "\\.Z")
  ("\x9C" "IJ")
  ("\x9D" "\\.I")
  ("\x9E" "{\\dj}")
  ("\x9F" "{\\S}")
  ("\xA0" "\\u{a}")
  ("\xA1" "\\k{a}")
  ("\xA2" "\\'c")
  ("\xA3" "\\v{c}")
  ("\xA4" "\\v{d}")
  ("\xA5" "\\v{e}")
  ("\xA6" "\\k{e}")
  ("\xA7" "\\u{g}")
  ("\xA8" "\\'l")
  ("\xA9" "\\v{l}")
  ("\xAA" "{\\l}")
  ("\xAB" "\\'n")
  ("\xAC" "\\v{n}")
  ("\xAD" "{\\ng}")
  ("\xAE" "\\H{o}")
  ("\xAF" "\\'r")
  ("\xB0" "\\v{r}")
  ("\xB1" "\\'s")
  ("\xB2" "\\v{s}")
  ("\xB3" "\\c{s}")
  ("\xB4" "\\v{t}")
  ("\xB5" "\\c{t}")
  ("\xB6" "\\H{u}")
  ("\xB7" "\\r{u}")
  ("\xB8" "\\\"y")
  ("\xB9" "\\'z")
  ("\xBA" "\\v{z}")
  ("\xBB" "\\.z")
  ("\xBC" "ij")
  ("\xBD" "!`")
  ("\xBE" "?`")
  ("\xBF" "{\\pounds}")
  ("\xC0" "\\`A")
  ("\xC1" "\\'A")
  ("\xC2" "\\^A")
  ("\xC3" "\\~A")
  ("\xC4" "\\\"A")
  ("\xC5" "{\\AA}")
  ("\xC6" "{\\AE}")
  ("\xC7" "\\c{C}")
  ("\xC8" "\\`E")
  ("\xC9" "\\'E")
  ("\xCA" "\\^E")
  ("\xCB" "\\\"E")
  ("\xCC" "\\`I")
  ("\xCD" "\\'I")
  ("\xCE" "\\^I")
  ("\xCF" "\\\"I")
  ("\xD0" "{\\DH}")
  ("\xD1" "\\~N")
  ("\xD2" "\\`O")
  ("\xD3" "\\'O")
  ("\xD4" "\\^O")
  ("\xD5" "\\~O")
  ("\xD6" "\\\"O")
  ("\xD7" "{\\OE}")
  ("\xD8" "{\\O}")
  ("\xD9" "\\`U")
  ("\xDA" "\\'U")
  ("\xDB" "\\^U")
  ("\xDC" "\\\"U")
  ("\xDD" "\\'Y")
  ("\xDE" "{\\TH}")
  ("\xDF" "{\\SS}")
  ("\xE0" "\\`a")
  ("\xE1" "\\'a")
  ("\xE2" "\\^a")
  ("\xE3" "\\~a")
  ("\xE4" "\\\"a")
  ("\xE5" "{\\aa}")
  ("\xE6" "{\\ae}")
  ("\xE7" "\\c{c}")
  ("\xE8" "\\`e")
  ("\xE9" "\\'e")
  ("\xEA" "\\^e")
  ("\xEB" "\\\"e")
  ("\xEC" "\\`{\\i}")
  ("\xED" "\\'{\\i}")
  ("\xEE" "\\^{\\i}")
  ("\xEF" "\\\"{\\i}")
  ("\xF0" "{\\dh}")
  ("\xF1" "\\~n")
  ("\xF2" "\\`o")
  ("\xF3" "\\'o")
  ("\xF4" "\\^o")
  ("\xF5" "\\~o")
  ("\xF6" "\\\"o")
  ("\xF7" "{\\oe}")
  ("\xF8" "{\\o}")
  ("\xF9" "\\`u")
  ("\xFA" "\\'u")
  ("\xFB" "\\^u")
  ("\xFC" "\\\"u")
  ("\xFD" "\\'y")
  ("\xFE" "{\\th}")
  ("\xFF" "{\\ss}"))

(drd-table cyrillic-catcodes%
  ("�" "\\CYRA")
  ("�" "\\cyra")
  ("�" "\\CYRB")
  ("�" "\\cyrb")
  ("�" "\\CYRV")
  ("�" "\\cyrv")
  ("�" "\\CYRG")
  ("�" "\\cyrg")
  ("�" "\\CYRD")
  ("�" "\\cyrd")
  ("�" "\\CYRE")
  ("�" "\\cyre")
  ("�" "\\CYRZH")
  ("�" "\\cyrzh")
  ("�" "\\CYRZ")
  ("�" "\\cyrz")
  ("�" "\\CYRI")
  ("�" "\\cyri")
  ("�" "\\CYRISHRT")
  ("�" "\\cyrishrt")
  ("�" "\\CYRK")
  ("�" "\\cyrk")
  ("�" "\\CYRL")
  ("�" "\\cyrl")
  ("�" "\\CYRM")
  ("�" "\\cyrm")
  ("�" "\\CYRN")
  ("�" "\\cyrn")
  ("�" "\\CYRO")
  ("�" "\\cyro")
  ("�" "\\CYRP")
  ("�" "\\cyrp")
  ("�" "\\CYRR")
  ("�" "\\cyrr")
  ("�" "\\CYRS")
  ("�" "\\cyrs")
  ("�" "\\CYRT")
  ("�" "\\cyrt")
  ("�" "\\CYRU")
  ("�" "\\cyru")
  ("�" "\\CYRF")
  ("�" "\\cyrf")
  ("�" "\\CYRH")
  ("�" "\\cyrh")
  ("�" "\\CYRC")
  ("�" "\\cyrc")
  ("�" "\\CYRCH")
  ("�" "\\cyrch")
  ("�" "\\CYRSH")
  ("�" "\\cyrsh")
  ("�" "\\CYRSHCH")
  ("�" "\\cyrshch")
  ("�" "\\CYRHRDSN")
  ("�" "\\cyrhrdsn")
  ("�" "\\CYRERY")
  ("�" "\\cyrery")
  ("�" "\\CYRSFTSN")
  ("�" "\\cyrsftsn")
  ("�" "\\CYREREV")
  ("�" "\\cyrerev")
  ("�" "\\CYRYU")
  ("�" "\\cyryu")
  ("�" "\\CYRYA")
  ("�" "\\cyrya")
  ("�" "\\CYRYO")
  ("�" "\\cyryo"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Page size settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(drd-table latex-paper-type%
  ("a0" "a0paper")
  ("a1" "a1paper")
  ("a2" "a2paper")
  ("a3" "a3paper")
  ("a4" "a4paper")
  ("a5" "a5paper")
  ("a6" "a6paper")
  ("a7" "papersize={74mm,105mm}")
  ("a8" "papersize={52mm,74mm")
  ("a9" "papersize={37mm,52mm}")
  ("b0" "b0paper")
  ("b1" "b1paper")
  ("b2" "b2paper")
  ("b3" "b3paper")
  ("b4" "b4paper")
  ("b5" "b5paper")
  ("b6" "b6paper")
  ("b7" "papersize={88mm,125mm}")
  ("b8" "papersize={62mm,88mm}")
  ("b9" "papersize={44mm,62mm}")
  ("legal" "legalpaper")
  ("letter" "letterpaper")
  ("executive" "executivepaper")
  ("archA" "papersize={9in,12in}")
  ("archB" "papersize={12in,18in}")
  ("archC" "papersize={18in,24in}")
  ("archD" "papersize={24in,36in}")
  ("archE" "papersize={36in,48in}")
  ("10x14" "papersize={10in,14in}")
  ("11x17" "papersize={11in,17in}")
  ("C5" "papersize={162mm,229mm}")
  ("Comm10" "papersize={297pt,684pt}")
  ("DL" "papersize={110mm,220mm}")
  ("halfletter" "papersize={140mm,216mm}")
  ("halfexecutive" "papersize={133mm,184mm}")
  ("ledger" "papersize={432mm,279mm}")
  ("Monarch" "papersize={98mm,190mm}")
  ("csheet" "papersize={432mm,559mm}")
  ("dsheet" "papersize={559mm,864mm}")
  ("esheet" "papersize={864mm,1118mm}")
  ("flsa" "papersize={216mm,330mm}")
  ("flse" "papersize={216mm,330mm}")
  ("folio" "papersize={216mm,330mm}")
  ("lecture note" "papersize={15.5cm,23.5cm}")
  ("note" "papersize={216mm,279mm}")
  ("quarto" "papersize={215mm,275mm}")
  ("statement" "papersize={140mm,216mm}")
  ("tabloid" "papersize={279mm,432mm}"))
