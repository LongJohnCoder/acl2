; Converter From ACL2 System Documentation to Text
; Copyright (C) 2013 Centaur Technology
;
; Contact:
;   Centaur Technology Formal Verification Group
;   7600-C N. Capital of Texas Highway, Suite 300, Austin, TX 78731, USA.
;   http://www.centtech.com/
;
; This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU General Public License as published by the Free Software
; Foundation; either version 2 of the License, or (at your option) any later
; version.  This program is distributed in the hope that it will be useful but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
; more details.  You should have received a copy of the GNU General Public
; License along with this program; if not, write to the Free Software
; Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA 02110-1335, USA.
;
; Original author: Jared Davis <jared@centtech.com>

(in-package "XDOC")
(include-book "xdoc/display" :dir :system)
(include-book "std/util/defconsts" :dir :system)
(set-state-ok t)
(program)

(table xdoc 'doc nil)     ; throw away potentially GPL'd docs from the above
(include-book "acl2-doc") ; load only pure bsd-licensed system documentation

(value-triple (len (get-xdoc-table (w state))))

(defun render-topic (x all-topics state)
  ;; Adapted from display-topic
  (b* ((name (cdr (assoc :name x)))
       (parents (cdr (assoc :parents x)))
       ((mv text state) (preprocess-topic
                         (acons :parents nil x) ;; horrible hack
                         all-topics nil nil state))
       ((mv err tokens) (parse-xml text))

       ((when err)
        (cw "Error rendering xdoc topic ~x0:~%~%" name)
        (b* ((state (princ$ err *standard-co* state))
             (state (newline *standard-co* state))
             (state (newline *standard-co* state)))
          (er hard? 'make-topic-text "Failed to process topic ~x0.~%" name)
          (mv nil state)))

       (merged-tokens (reverse (merge-text tokens nil 0)))
       (acc (if (atom parents)
                nil
              (str::explode
               (reverse
                (fms-to-string "Parent~s0: ~&1.~%"
                               (list (cons #\0 (if (consp (cdr parents))
                                                   "s"
                                                 ""))
                                     (cons #\1 parents)))))))
       (acc (tokens-to-terminal merged-tokens 70 nil nil acc))
       (terminal (str::trim (str::rchars-to-string acc))))

; Originally the first value returned was (cons name terminal).  But we prefer
; to avoid the "." in the output file, to make its viewing more pleasant.  If
; we decide to associate additional information with name, then we may have a
; more convincing reason to make this change.

    (mv (list name terminal) state)))

(defun render-topics (x all-topics state)
  (b* (((when (atom x))
        (mv nil state))
       ((mv first state) (render-topic (car x) all-topics state))
       ((mv rest state) (render-topics (cdr x) all-topics state)))
    (mv (cons first rest) state)))

(acl2::defconsts (*rendered* state)
  (b* ((all-topics (get-xdoc-table (w state)))
       ((mv rendered state)
        (render-topics all-topics all-topics state)))
    (mv rendered state)))

(defttag :open-output-channel!)

(acl2::defconsts state
  (b* ((- (cw "Writing rendered-doc.lisp~%"))
       ((mv channel state) (open-output-channel! "rendered-doc.lisp"
                                                 :character state))
       ((unless channel)
        (er hard? 'rendered-doc.lisp
            "can't open rendered-doc.lisp for output.")
        state)
       (state (princ$ "; Documentation for the ACL2 Theorem Prover
; WARNING: GENERATED FILE, DO NOT HAND EDIT!
; The contents of this file are derived from ACL2 Community Book
; books/system/acl2-doc.lisp.

; ACL2 Version 6.3 -- A Computational Logic for Applicative Common Lisp
; Copyright (C) 2013, Regents of the University of Texas

; This version of ACL2 is a descendent of ACL2 Version 1.9, Copyright
; (C) 1997 Computational Logic, Inc.  See the documentation topic NOTE-2-0.

; This program is free software; you can redistribute it and/or modify
; it under the terms of the LICENSE file distributed with ACL2.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; LICENSE for more details.

; Here are the original authors of books/system/acl2-doc.lisp.
; Additional contributions may have been made to that file by members
; of the ACL2 community.

; Written by:  Matt Kaufmann               and J Strother Moore
; email:       Kaufmann@cs.utexas.edu      and Moore@cs.utexas.edu
; Department of Computer Science
; University of Texas at Austin
; Austin, TX 78701 U.S.A.

; WARNING: This file is generated from ACL2 Community Book
; books/system/acl2-doc.lisp.  To edit ACL2 documentation modify that
; file, not this one!  Instructions are just above the in-package form
; in that book.

(in-package \"ACL2\")

(defconst *acl2-system-documentation* '"
                    channel state))
       (state (fms! "~x0"
                    (list (cons #\0 *rendered*))
                    channel state nil))
       (state (fms! ")" nil channel state nil))
       (state (newline channel state))
       (state (close-output-channel channel state)))
    state))