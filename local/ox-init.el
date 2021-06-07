(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)

(require 'org)
(require 'ox)
(require 'ox-latex)
(require 'ox-beamer)
;; (require 'cl) ---> lead to warnings in emacs 27
(require 'cl-lib)

;; org-babel
;; 
;; (setq org-adapt-indentation)
;; Feature parity with doom
(with-eval-after-load 'ox-latex
  ;; Compiler
  (setq bibtex-dialect 'biblatex)
  ;; (setq org-latex-pdf-process '("latexmk -shell-escape -interaction nonstopmode -bibtex -pdf %f"))
  (setq org-latex-pdf-process
        '("latexmk -pdflatex='pdflatex -shell-escape -interaction nonstopmode' -pdf -f  %f"))
  (setq org-latex-packages-alist
        (quote (("" "parskip" t)
                ("" "amsmath" t)
                ("" "amssymb" t)
                ("" "amsthm" t)
                ("" "amsfonts" t)
                ("" "mathtools" t)
                ("" "braket" t)
                ("" "bbm" t)
                ("" "listings" t)
                ("" "algpseudocode" t)
                ("" "algorithm" t)
                ("" "algorithmicx" t)
                ("" "xcolor" t)
                ("" "mymacros" t))))
  ;; org default header
  (add-to-list
   'org-latex-classes
   '("notes"
     "\\documentclass[11pt]{article}
  \\usepackage{mynotes}
  \\usepackage{mymacros}
  \\usepackage[normalem]{ulem}
  \\usepackage{booktabs}
  \\usepackage[inline, shortlabels]{enumitem}
  \\usepackage[backref=true,natbib=true,maxbibnames=99,doi=false,url=false,giveninits=true]{biblatex}
  \\usepackage{hyperref}
  [NO-DEFAULT-PACKAGES]
  [NO-PACKAGES]
  %%%% configs
  \\DefineBibliographyStrings{english}{backrefpage={page}, backrefpages={pages}}
  \\setlength\\parindent{0pt}
  \\setitemize{itemsep=1pt}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  
  (add-to-list 'org-latex-classes
               '("manuscripts"
                 "\\documentclass[11pt]{article}
  \\usepackage[utf8]{inputenc}
  \\usepackage[T1]{fontenc}
  \\usepackage[normalem]{ulem}
  \\usepackage[margin=1in]{geometry}
  [NO-DEFAULT-PACKAGES]
  [PACKAGES]
  \\usepackage{pgf,interval}
  \\usepackage{booktabs}
  \\usepackage[inline]{enumitem}
  \\usepackage[backref=true,natbib=true,maxbibnames=99,doi=false,url=false,giveninits=true,dashed=false]{biblatex}
  \\usepackage{hyperref}
  %%%% configs
  \\DefineBibliographyStrings{english}{backrefpage={page}, backrefpages={pages}}
  \\intervalconfig{soft open fences}
  \\setlength\\parindent{0pt}
  \\setitemize{itemsep=1pt}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  
  (add-to-list 'org-latex-classes
               '("slides"
                 "\\documentclass[notheorems]{beamer}
  \\usepackage[utf8]{inputenc}
  \\usepackage[T1]{fontenc}
  \\usepackage[normalem]{ulem}
  [NO-DEFAULT-PACKAGES]
  [PACKAGES]
  \\usepackage{booktabs}
  \\usepackage[natbib=true,backend=biber,style=authoryear-icomp,maxbibnames=1,maxcitenames=2,uniquelist=false,doi=false,isbn=false,url=false,eprint=false,dashed=false]{biblatex}
  \\usepackage{pgfpages}
  %%%% configs
  \\setlength\\parindent{0pt}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  (add-to-list 'org-latex-classes
               '("moderncv"
                 "\\documentclass{moderncv}
  [NO-DEFAULT-PACKAGES]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
(provide 'autoExport)
