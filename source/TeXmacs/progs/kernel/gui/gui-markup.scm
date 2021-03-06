
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : gui-markup.scm
;; DESCRIPTION : Macros and functions for content generation
;; COPYRIGHT   : (C) 2010  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (kernel gui gui-markup)
  (:use (kernel regexp regexp-match)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Style constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-public widget-style-mini 1)
(define-public widget-style-monospaced 2)
(define-public widget-style-grey 4)
(define-public widget-style-pressed 8)
(define-public widget-style-inert 16)
(define-public widget-style-button 32)
(define-public widget-style-centered 64)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Control structures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (gui-normalize l)
  (cond ((null? l) l)
	((func? (car l) 'list)
	 (append (gui-normalize (cdar l)) (gui-normalize (cdr l))))
	(else (cons (car l) (gui-normalize (cdr l))))))

(tm-define-macro ($list . l)
  (:synopsis "Make widgets")
  `(gui-normalize (list ,@l)))

(tm-define-macro ($begin . l)
  (:synopsis "Begin primitive for content generation")
  `(cons* 'list ($list ,@l)))

(tm-define-macro ($if pred? . l)
  (:synopsis "When primitive for content generation")
  (cond ((== (length l) 1)
         `(cons* 'list (if ,pred? ($list ,(car l)) '())))
        ((== (length l) 2)
         `(cons* 'list (if ,pred? ($list ,(car l)) ($list ,(cadr l)))))
        (else
          (texmacs-error "$if" "invalid number of arguments"))))

(tm-define-macro ($when pred? . l)
  (:synopsis "When primitive for content generation")
  `(cons* 'list (if ,pred? ($list ,@l) '())))

(tm-define (cond$sub l)
  (cond ((null? l)
         (list `(else '())))
        ((npair? (car l))
         (texmacs-error "cond$sub" "syntax error ~S" l))
        ((== (caar l) 'else)
         (list `(else ($list ,@(cdar l)))))
        (else (cons `(,(caar l) ($list ,@(cdar l)))
                    (cond$sub (cdr l))))))

(tm-define-macro ($cond . l)
  (:synopsis "Cond primitive for content generation")
  `(cons* 'list (cond ,@(cond$sub l))))

(tm-define-macro ($let decls . l)
  (:synopsis "Let* primitive for content generation")
  `(let ,decls
     (cons* 'list ($list ,@l))))

(tm-define-macro ($let* decls . l)
  (:synopsis "Let* primitive for content generation")
  `(let* ,decls
     (cons* 'list ($list ,@l))))

(tm-define-macro ($with var val . l)
  (:synopsis "With primitive for content generation")
  `(with ,var ,val
     (cons* 'list ($list ,@l))))

(tm-define-macro ($for var-val . l)
  (:synopsis "For primitive for content generation")
  (when (nlist-2? var-val)
    (texmacs-error "$for" "syntax error in ~S" var-val))
  (with fun `(lambda (,(car var-val)) ($list ,@l))
    `(cons* 'list (append-map ,fun ,(cadr var-val)))))

(tm-define-macro ($dynamic w)
  (:synopsis "Make dynamic widgets")
  `(cons* 'list ,w))

(tm-define-macro ($promise cmd)
  (:synopsis "Promise widgets")
  `(list 'promise (lambda () ,cmd)))

(tm-define-macro ($menu-link w)
  (:synopsis "Make dynamic link to another widget")
  `(list 'link ',w))

(tm-define-macro ($delayed-when pred? . l)
  (:synopsis "Delayed when primitive for content generation")
  `(cons* 'if (lambda () ,pred?) ($list ,@l)))

(tm-define-macro ($assuming pred? . l)
  (:synopsis "Make possibly inert (whence greyed) widgets")
  `(cons* 'when (lambda () ,pred?) ($list ,@l)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General layout widgets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define-macro ($glue hext? vext? minw minh)
  (:synopsis "Make extensible glue")
  `(list 'glue ,hext? ,vext? ,minw ,minh))

(tm-define-macro ($colored-glue col hext? vext? minw minh)
  (:synopsis "Make extensible colored glue")
  `(list 'color ,col ,hext? ,vext? ,minw ,minh))

(tm-define-macro ($hlist . l)
  (:synopsis "Horizontal layout of widgets")
  `(cons* 'hlist ($list ,@l)))

(tm-define-macro ($vlist . l)
  (:synopsis "Vertical layout of widgets")
  `(cons* 'vlist ($list ,@l)))

(tm-define-macro ($horizontal . l)
  (:synopsis "Horizontal layout of widgets")
  `(cons* 'horizontal ($list ,@l)))

(tm-define-macro ($vertical . l)
  (:synopsis "Vertical layout of widgets")
  `(cons* 'vertical ($list ,@l)))

(tm-define-macro ($tile columns . l)
  (:synopsis "Tile layout of widgets")
  `(cons* 'tile ,columns ($list ,@l)))

(tm-define $/
  (:synopsis "Horizontal separator")
  (string->symbol "|"))

(tm-define $---
  (:synopsis "Vertical separator")
  '---)

(tm-define-macro ($mini pred? . l)
  (:synopsis "Make mini widgets")
  `(cons* 'mini (lambda () ,pred?) ($list ,@l)))

(tm-define-macro (gui$minibar . l)
  (:synopsis "Make minibar")
  `(cons* 'minibar ($list ,@l)))

(tm-define-macro ($widget-style st . l)
  (:synopsis "Change the style of a widget")
  `(cons* 'style ,st ($list ,@l)))

(tm-define-macro ($widget-extend w . l)
  (:synopsis "Extend the size of a widget")
  `(cons* 'extend ,w ($list ,@l)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu and widget elements
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define-macro ($-> text . l)
  (:synopsis "Make pullright button")
  `(cons* '-> ,text ($list ,@l)))

(tm-define-macro ($=> text . l)
  (:synopsis "Make pulldown button")
  `(cons* '=> ,text ($list ,@l)))

(tm-define-macro ($> text . cmds)
  (:synopsis "Make button")
  `(list ,text (lambda () ,@cmds)))

(tm-define-macro ($check text check pred?)
  (:synopsis "Make button")
  `(list 'check ,text ,check (lambda () ,pred?)))

(tm-define-macro ($balloon text balloon)
  (:synopsis "Make balloon")
  `(list 'balloon ,text ,balloon))

(tm-define-macro ($concat-text . l)
  (:synopsis "Make text concatenation")
  `(quote (concat ,@l)))

(tm-define-macro ($verbatim-text . l)
  (:synopsis "Make verbatim text")
  `(quote (verbatim ,@l)))

(tm-define-macro ($icon name)
  (:synopsis "Make icon")
  `(list 'icon ,name))

(tm-define-macro ($symbol sym . l)
  (:synopsis "Make a menu symbol")
  (if (null? l)
      `(list 'symbol ,sym)
      `(list 'symbol ,sym (lambda () ,(car l)))))

(tm-define-macro ($menu-group text)
  (:synopsis "Make a menu group")
  `(list 'group ,text))

(tm-define-macro ($input cmd type proposals width)
  (:synopsis "Make input field")
  `(list 'input (lambda (answer) ,cmd) ,type (lambda () ,proposals) ,width))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic text markup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define $lf '$lf)

(tm-define (markup-build-atom x)
  (cond ((number? x) (number->string x))
        ((symbol? x) (symbol->string x))
        ((== x #t) "true")
        ((== x #f) "false")
        (else x)))

(tm-define (markup-build-concat l)
  (with r (map markup-build-atom l)
    (cond ((null? r) "")
          ((list-1? r) (car r))
          (else (cons 'concat r)))))

(tm-define (markup-build-paragraphs l block?)
  (with s (list-scatter l (lambda (x) (== x '$lf)) #f)
    (with r (map markup-build-concat s)
      (cond ((and (null? r) block?) '(document ""))
            ((null? r) "")
            ((and (list-1? r) (not block?)) (car r))
            (else (cons 'document r))))))

(tm-define (markup-expand-document x)
  (if (tm-is? x 'document)
      (append-map (lambda (x) (list x $lf)) (tm-cdr x))
      (list x)))

(tm-define (markup-build-document l block?)
  (with x (append-map markup-expand-document l)
    (with y (if (and (nnull? x) (== (cAr x) $lf)) (cDr x) x)
      (markup-build-paragraphs y block?))))

(tm-define-macro ($textual . l)
  `(markup-build-document ($list ,@l) #f))

(tm-define-macro ($inline . l)
  `(markup-build-document ($list ,@l) #f))

(tm-define-macro ($block . l)
  `(markup-build-document ($list ,@l) #t))

(define (replace-unquotes x)
  (cond ((npair? x) x)
        ((== (car x) '$unquote) (cons 'unquote (cdr x)))
        (else (cons (replace-unquotes (car x)) (replace-unquotes (cdr x))))))

(tm-define ($quote x)
  (list 'quasiquote (replace-unquotes x)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic markup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define-macro ($para . l)
  ($quote `(document ($unquote ($block ,@l)))))

(tm-define-macro ($itemize . l)
  ($quote `(document (itemize ($unquote ($block ,@l))))))

(tm-define-macro ($enumerate . l)
  ($quote `(document (enumerate ($unquote ($block ,@l))))))

(tm-define-macro ($description . l)
  ($quote `(document (description ($unquote ($block ,@l))))))

(tm-define-macro ($description-aligned . l)
  ($quote `(document (description-aligned ($unquote ($block ,@l))))))

(tm-define-macro ($description-long . l)
  ($quote `(document (description-long ($unquote ($block ,@l))))))

(tm-define-macro ($item)
  ($quote `(item)))

(tm-define-macro ($item* . l)
  ($quote `(item* ($unquote ($inline ,@l)))))

(tm-define-macro ($list-item . l)
  `($begin ($item) ,@l $lf))

(tm-define-macro ($describe-item key . l)
  `($begin ($item* ,key) ,@l $lf))

(tm-define-macro ($strong . l)
  ($quote `(strong ($unquote ($inline ,@l)))))

(tm-define-macro ($link dest . l)
  ($quote `(hlink ($unquote ($inline ,@l)) ($unquote ($textual ,dest)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Specific markup for TeXmacs documentation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define-macro ($tmdoc . l)
  (with lan (get-output-language)
    ($quote
      `(document
         (style "tmdoc")
         (body ($unquote ($localize ($block ,@l))))
         (initial (collection (associate "language" ,lan)))))))

(tm-define-macro ($localize . l)
  `(tree-translate ($inline ,@l)))

(tm-define-macro ($tmdoc-title . l)
  ($quote `(document (tmdoc-title ($unquote ($inline ,@l))))))

(tm-define-macro ($folded-documentation key . l)
  ($quote `(document (folded-documentation ($unquote ($inline ,key))
                                           ($unquote ($block ,@l))))))

(tm-define-macro ($unfolded-documentation key . l)
  ($quote `(document (unfolded-documentation ($unquote ($inline ,key))
                                             ($unquote ($block ,@l))))))

(tm-define-macro ($explain key . l)
  ($quote `(document (explain ($unquote ($inline ,key))
			      ($unquote ($block ,@l))))))

(tm-define-macro ($tm-fragment . l)
  ($quote `(document (tm-fragment ($unquote ($block ,@l))))))

(tm-define-macro ($markup . l)
  ($quote `(markup ($unquote ($inline ,@l)))))

(tm-define-macro ($tmstyle . l)
  ($quote `(tmstyle ($unquote ($inline ,@l)))))

(tm-define-macro ($shortcut cmd)
  ($quote `(shortcut ($unquote (object->string ',cmd)))))

(tm-define-macro ($tmdoc-link dest . l)
  `(with s (string-append "$TEXMACS_DOC_PATH/" ,dest ".en.tm")
     ($link s ,@l)))

(tm-define-macro ($menu . l)
  `(list 'menu ,@l))

(tm-define-macro ($tmdoc-icon dest)
  ($quote `(icon ($unquote ($textual ,dest)))))

(tm-define-macro ($src-arg s)
  ($quote `(src-arg ($unquote ($textual ,s)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User interface for dynamic content generation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define-macro (tm-generate head . l)
  (receive (opts body) (list-break l not-define-option?)
    `(tm-define ,head ,@opts ($begin ,@body))))
