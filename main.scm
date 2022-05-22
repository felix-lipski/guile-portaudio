(use-modules (system foreign)
             (system foreign-library)
             (rnrs bytevectors))

(define libsink (dynamic-link "libsink"))

; (define c_main
;   (pointer->procedure double
;                       (dynamic-func "main" libsink)
;                       (list double)))

(define c_note_stack (pointer->procedure void
                      (dynamic-func "note_stack" libsink)
                      (list '* int)))

(define c_note (pointer->procedure void
                      (dynamic-func "note" libsink)
                      (list float)))

(define c_main_ptr (foreign-library-pointer "libsink" "entr"))
(define c_main
  (pointer->procedure double
                      c_main_ptr
                      (list double)))

(define src-bits
  (u8-list->bytevector '(0 1 2 3 4 5 6 7)))
(define src
  (bytevector->pointer src-bits))
; (newline)
(c_note_stack src 3)
; (c_note_stack (scm->pointer #1f32(1.3 2.0 3.2)) 3)
; (c_note_stack (list->array 1 '(1 2 3)))
; (c_note 1.0)
; (c_note 1.0)
; (c_note 2.0)
; (c_note 3.0)

; (c_note 1.0)
; (c_note 1.0)
; (c_note 2.0)
(c_note 3.0)

; (display (c_main 3.0))
