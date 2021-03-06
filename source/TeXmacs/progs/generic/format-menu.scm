
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : format-menu.scm
;; DESCRIPTION : menus for setting local formatting properties
;; COPYRIGHT   : (C) 1999  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (generic format-menu)
  (:use (generic generic-edit)
	(generic format-edit)
	(generic format-geometry-edit)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menus for fonts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind font-size-menu
  ("5" (make-with "font-base-size" "5"))
  ("6" (make-with "font-base-size" "6"))
  ("7" (make-with "font-base-size" "7"))
  ("8" (make-with "font-base-size" "8"))
  ("9" (make-with "font-base-size" "9"))
  ("10" (make-with "font-base-size" "10"))
  ("11" (make-with "font-base-size" "11"))
  ("12" (make-with "font-base-size" "12"))
  ("14" (make-with "font-base-size" "14"))
  ("17" (make-with "font-base-size" "17"))
  ("20" (make-with "font-base-size" "20"))
  ("24" (make-with "font-base-size" "24"))
  ---
  ("Other" (make-interactive-with "font-base-size")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menus for text properties and formatting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind opacity-menu
  ("10%" (make-with "opacity" "10%"))
  ("20%" (make-with "opacity" "20%"))
  ("30%" (make-with "opacity" "30%"))
  ("40%" (make-with "opacity" "40%"))
  ("50%" (make-with "opacity" "50%"))
  ("60%" (make-with "opacity" "60%"))
  ("70%" (make-with "opacity" "70%"))
  ("80%" (make-with "opacity" "80%"))
  ("90%" (make-with "opacity" "90%"))
  ("100%" (make-with "opacity" "100%"))
  ---
  ("Other" (make-interactive-with "opacity")))

(menu-bind color-menu
  (pick-color (make-with "color" answer))
  ---
  ("Palette" (interactive-color (lambda (col) (make-with "color" col)) '()))
  ("Other" (make-interactive-with "color")))

(menu-bind horizontal-space-menu
  ("Stretchable" (interactive make-hspace))
  ("Rigid" (interactive make-space))
  ("Rigid box" (interactive make-var-space))
  ("Tab" (make-htab "5mm"))
  ("Custom tab" (interactive make-htab)))

(menu-bind transform-menu
  ("Move object" (interactive make-move))
  ("Shift object" (interactive make-shift))
  ("Resize object" (interactive make-resize))
  ("Clip object" (interactive make-clipped))
  ---
  ("Group" (make-rigid))
  ("Superpose" (make 'superpose))
  ("Repeat object" (make 'repeat))
  ("Decorate atoms" (make-arity 'datoms 2))
  ;;("Decorate lines" (make-arity 'dlines 2))
  ;;("Decorate pages" (make-arity 'dpages 2))
  )

(menu-bind specific-menu
  ("TeXmacs" (make-specific "texmacs"))
  ("LaTeX" (make-specific "latex"))
  ("HTML" (make-specific "html"))
  ("Screen" (make-specific "screen"))
  ("Printer" (make-specific "printer"))
  ("Image" (make-specific "image")))

(tm-menu (local-supported-scripts-menu)
  (let* ((dummy (lazy-plugin-force))
         (l (list-sort supported-scripts-list string<=?)))
    (for (name l)
      ((eval (ahash-ref supported-scripts-table name))
       (make-with "prog-scripts" name)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menus for paragraph formatting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind vertical-space-menu
  (group "Space before")
  ("Small skip" (make-vspace-before "0.5fn"))
  ("Medium skip" (make-vspace-before "1fn"))
  ("Big skip" (make-vspace-before "2fn"))
  ("Other" (interactive make-vspace-before))
  ---
  (group "Space after")
  ("Small skip" (make-vspace-after "0.5fn"))
  ("Medium skip" (make-vspace-after "1fn"))
  ("Big skip" (make-vspace-after "2fn"))
  ("Other" (interactive make-vspace-after)))

(menu-bind indentation-menu
  ("Disable indentation before" (make 'no-indent))
  ("Enable indentation before" (make 'yes-indent))
  ---
  ("Disable indentation after" (make 'no-indent*))
  ("Enable indentation after" (make 'yes-indent*)))

(menu-bind line-break-menu
  ("New line" (make 'next-line))
  ("Line break" (make 'line-break))
  ("No line break" (make 'no-break))
  ("New paragraph" (make 'new-line)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menus for page formatting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind page-header-menu
  ("This page header" (make 'set-this-page-header))
  ("Permanent header" (make 'set-header))
  ("Odd page header" (make 'set-odd-page-header))
  ("Even page header" (make 'set-even-page-header)))

(menu-bind page-footer-menu
  ("This page footer" (make 'set-this-page-footer))
  ("Permanent footer" (make 'set-footer))
  ("Odd page footer" (make 'set-odd-page-footer))
  ("Even page footer" (make 'set-even-page-footer)))

(menu-bind page-numbering-menu
  ("Renumber this page" (make 'set-page-number))
  ("Page number text" (make 'set-page-number-macro)))

(menu-bind page-break-menu
  (group "Before")
  ("New page" (make 'new-page*))
  ("New double page" (make 'new-dpage*))
  ("Page break" (make 'page-break*))
  ("No page break" (make 'no-page-break*))
  ---
  (group "After")
  ("New page" (make-new-page))
  ("New double page" (make-new-dpage))
  ("Page break" (make-page-break))
  ("No page break" (make 'no-page-break)))

(menu-bind insert-page-insertion-menu
  ("Footnote" (make 'footnote))
  ---
  ("Floating object" (make-insertion "float"))
  ("Floating figure" (begin (make-insertion "float") (make 'big-figure)))
  ("Floating table" (begin (make-insertion "float") (make 'big-table)))
  ("Floating algorithm" (begin (make-insertion "float") (make 'algorithm))))

(menu-bind position-float-menu
  ("Top" (toggle-insertion-positioning "t"))
  ("Here" (toggle-insertion-positioning "h"))
  ("Bottom" (toggle-insertion-positioning "b"))
  ("Other pages" (toggle-insertion-positioning-not "f")))

(menu-bind page-insertion-menu
  (when (not (inside? 'float))
    (link insert-page-insertion-menu))
  ---
  (when (inside? 'float)
    (group "Position float")
    (link position-float-menu)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The main Format menu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bind format-menu
  (if (or (in-text?) (in-source?)) (link text-format-menu))
  (if (in-math?) (link math-format-menu))
  (if (in-prog?) (link prog-format-menu)))
