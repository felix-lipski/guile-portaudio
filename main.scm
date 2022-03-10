(use-modules (system foreign)
             (system foreign-library))

(define libsink (dynamic-link "libsink"))

; (define c_main
;   (pointer->procedure double
;                       (dynamic-func "main" libsink)
;                       (list double)))

(define c_note (pointer->procedure void
                      (dynamic-func "note" libsink)
                      (list float)))

(define c_main_ptr (foreign-library-pointer "libsink" "entr"))
(define c_main
  (pointer->procedure double
                      c_main_ptr
                      (list double)))
; (newline)
(c_note 1.0)
(c_note 1.0)
(c_note 2.0)
(c_note 3.0)

(c_note 1.0)
(c_note 1.0)
(c_note 2.0)
(c_note 3.0)

(display (c_main 3.0))
