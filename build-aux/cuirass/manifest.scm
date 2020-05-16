(use-package
 (flat packages emacs)
 (nongnu packages linux))

(define (spec->packages spec)
  (call-with-values (lambda ()
                      (specification->package+output spec)) list))

(list emacs-native-comp
      linux)
