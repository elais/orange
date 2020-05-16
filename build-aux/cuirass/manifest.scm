(use-package
 (flat packages emacs)
 (nongnu packages linux))

(define (spec->packages spec)
  (call-with-values (lambda ()
                      (specification->package+output spec)) list))

(define packages-list
  '("emacs-native-comp"
    "linux-firmware"
    "emacs-next"
    "linux@5.4.41"))

(packages->manifest
 (map spec->packages packages-list))
