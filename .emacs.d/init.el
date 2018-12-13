;; Enable transient mark mode
(transient-mark-mode 1)

;; Visual line mode
(visual-line-mode t)

;; splash-screen
(setq inhibit-splash-screen t)

;; MacOS modifiers
(setq default-input-method "MacOSX")
(setq mac-command-modifier 'meta
      mac-option-modifier nil
      mac-allow-anti-aliasing t
      mac-command-key-is-meta t)

;; Packages
(require 'package)
(setq package-archives (append package-archives
			       '(("melpa" . "http://melpa.org/packages/")
				 ("melpa-stable" . "http://stable.melpa.org/packages/")
				 ("marmalade" . "http://marmalade-repo.org/packages/")
				 ("gnu" . "http://elpa.gnu.org/packages/")
				 ("org" . "http://orgmode.org/elpa/")
				 ;;("elpy" . "http://jorgenschaefer.github.io/packages/")
				 )))
(package-initialize)

;; mouse
(xterm-mouse-mode 1)

;; Coding
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(setq locale-coding-system 'utf-8-unix)
(set-language-environment 'utf-8)
(setq mm-coding-system-priorities '(utf-8-unix))

;; Scrolling one line at a time    
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;;-------------------------- Easy PG -----------------------------------
(require 'epa-file)
(setq epa-pinentry-mode 'loopback)

;;-------------------------- ESS & Julia -------------------------------
(add-to-list 'load-path "~/local/emacs-modes/ess-17.11/lisp/")
(require 'ess-site)
;; julia
(setq  inferior-julia-program-name "/usr/local/bin/julia")
;; ob-julia
(add-to-list 'load-path "~/local/emacs-modes/ob-julia/")

;;------------------------exec-path-from-shell---------------------------
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;;------------------------------Org-mode---------------------------------
(add-to-list 'load-path "~/local/emacs-modes/org-mode/lisp")
(require 'org)

;;pdf view
(eval-after-load
    'org '(require 'org-pdfview))


;; Github Flavored Markdown exporter for Org Mode : ox-gfm
(eval-after-load "org"
  '(require 'ox-gfm nil t))

;; holidays
(load "~/org/holidays.el")

(setq org-agenda-include-diary t)
(setq org-agenda-year-view t)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-cb" 'org-iswitchb)

(setq org-log-done t)

(setq org-agenda-files (file-expand-wildcards "~/org/*.org"))

;; Custom agenda, trimestrial, starting on monday and include all
(setq org-agenda-custom-commands
      '(("i" "Custum calendar view" agenda "trimestrial"
         ((org-agenda-span 90)
          (org-agenda-start-on-weekday 1)
          (org-agenda-time-grid nil) 
          (org-agenda-repeating-timestamp-show-all t)
	  ))  
        ))


(setq org-todo-keywords
  '((sequence "TODO" "INPROGRESS" "WAITING" "DELEGATED" "|" "CANCELLED" "DONE")))

;; TODO entry change  automatically to DONE when all children are done
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; logging & insertion of closing note
(setq org-log-done 'time)
(setq org-log-done 'note)

;;dependencies
(setq org-enforce-todo-dependencies t)

;; Set default column view headings: Task Total-Time Time-Stamp
(setq org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %16TIMESTAMP_IA")

;; Use `org-store-link' to store links, and `org-insert-link' to paste them
(setq org-mu4e-link-query-in-headers-mode nil)

;; Capture templates for: Quick captures, Phone Calls, Meetings, TODO tasks, Deadlines and Scheduled things
(setq org-capture-templates'
      (("n" "Quick captures" entry (file+headline "~/org/notes.org" "Quick Captures")
	"* %? \n %U \n")

       ("m" "Meetings" entry (file+headline "~/org/notes.org" "Meetings")
	"* Meeting %? %U :TAG:\n\n" :org-read-date nil t \"+0d\" :clock-in t :clock-resume t)
       
       ("p" "Phone" entry (file+headline "~/org/notes.org" "Meetings")
	"* Phone %? %U :phone:\n\n" :org-read-date nil t \"+0d\" :clock-in t :clock-resume t)

       ("t" "Todo" entry (file+headline "~/org/notes.org" "Tasks")
	"* %? %a \n SCHEDULED: %(org-insert-time-stamp ()) \n")
	 
       ("d" "Deadline" entry (file+headline "~/org/notes.org" "Scheduled")
	"* %? %a \n DEADLINE: %(org-insert-time-stamp (org-read-date nil t \"+0d\")) \n")	

       ("s" "Scheduled" entry (file+headline "~/org/notes.org" "Scheduled")
	"* %? %a \n %(org-insert-time-stamp (org-read-date nil t \"+0d\")) \n")	

       ("a"               ; key
	"Article"         ; name
	entry             ; type
	(file+headline "~/org/references/article-notes.org" "Article")  ; target
	"* %^{Title}  :article: \n:PROPERTIES:\n:Created: %U\n:Link: %A\n:END:\n%i\nBrief description:\n%?"  ; template
	:prepend t        ; properties
	:empty-lines 1    ; properties
	:created t        ; properties
	)
	 
       ))

;; Org-table made available in other modes
(add-hook 'message-mode-hook 'turn-on-orgtbl)

;;Org-mouse
(require 'org-mouse)

;;Org bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;;pdf export
(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))

;; user defined functions
(org-add-link-type
 "tag" 'follow-tag-link)

(defun follow-tag-link (tag)
"Display a list of TODOs headline with tag TAG
With prefixe arguments, also display headlines without a TODO keyword."
  (org-tag-view (null current-prefix-arg) tag))
  
;; Org-babel
(org-babel-do-load-languages 'org-babel-load-languages
			     (append org-babel-load-languages
				     '((python . t)
				       (emacs-lisp . t)
				       (julia . t)
				       (shell . t)
				       )))
(setq org-babel-python-command "python3")

;; Org-ref
(setq org-ref-bibliography-notes "~/org/references/article-notes.org"
      org-ref-pdf-directory "~/zotfile/"
      org-ref-default-bibliography '("~/org/references/library.bib"))

;;----------------------------Spell check--------------------------------
(setq-default ispell-program-name "/usr/local/bin/aspell")

;;-----------------------------julia mode---------------------------------
(add-to-list 'load-path "~/local/emacs-modes/")
(require 'julia-mode)

;;----------------------------julia-shell-------------------------------
(add-to-list 'load-path "~/local/emacs-modes/julia-shell-mode-master")
(require 'julia-shell)

;;-------------------------------Mu4e------------------------------------

;; Org mode compatibility
(require 'org-mu4e)

(setq mu4e-mu-binary "/usr/local/bin/mu")
(require 'mu4e)
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")

;; default email program as in  C-x m (compose-mail)
(setq mail-user-agent 'mu4e-user-agent)

;; display is definitely nicer with these
(setq mu4e-use-fancy-chars t)

;;---- Get mail
;; allow for updating mail using 'U' in the main view
(setq
      mu4e-get-mail-command "/usr/local/bin/offlineimap -f INBOX, Drafts, Sent, Archive, Trash, Now"
      ;;mu4e-get-mail-command "/usr/local/bin/offlineimap"
      mu4e-update-interval 300             ;; 300 to update every 5 minutes
      )

;;-----Folders

;; these are modified in the contexts
(setq mu4e-trash-folder nil ;; must be configured later by context
      mu4e-drafts-folder nil ;; must be configured later by context
      mu4e-sent-folder nil ;; must be configured later by context
      mu4e-refile-folder nil ;; idem
      mu4e-compose-reply-to-address nil ;; must be configured later by context
      mu4e-compose-signature nil ;; must be configured later by context
      )
;; Default directory for saving attachments
(setq mu4e-attachment-dir  "~/Downloads")

(setq
      mu4e-maildir       "~/Maildir"           ;; top-level Maildir
      )
;;   mu4e-sent-folder   "/mykolab/Sent"       ;; folder for sent messages
;;   mu4e-drafts-folder "/mykolab/Drafts"     ;; unfinished messages
;;   mu4e-trash-folder  "/mykolab/Trash"      ;; trashed messages
;;   mu4e-refile-folder "/mykolab/Archive")   ;; saved messages

;; shortcuts
(setq mu4e-maildir-shortcuts
    '( ("/mykolab/INBOX"  . ?i)
       ("/mykolab/Sent"   . ?s)
       ("/mykolab/Draft"   . ?d)
       ("/mykolab/Trash"   . ?t)
       ("/mykolab/Archive"   . ?a)
       ))

;; show addresses
(setq mu4e-view-show-addresses t) 

;;-------adresses & compose

;; allows reading other emails while composing
;;(setq mu4e-compose-in-new-frame t)

;; don't include me when I reply...
(setq mu4e-compose-dont-reply-to-self t)

;; general emacs mail settings
(setq mu4e-reply-to-address "alexandre.giuliani@synchrotron-soleil.fr")

;;SMTP
(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-debug-info t)

;;------------------ multiple accounts/contexts

 (setq mu4e-contexts
    `( ,(make-mu4e-context
          :name "mykolab"
          :enter-func (lambda () (mu4e-message "Entering Mykolab context"))
          :leave-func (lambda () (mu4e-message "Leaving Mykolab context"))
          :vars '( ( user-mail-address      . "agiuliani@mykolab.com"  )
		   ( mu4e-reply-to-address  . "alexandre.giuliani@synchrotron-soleil.fr" )
                   ( user-full-name         . "Alexandre Giuliani" )
                   ( mu4e-compose-signature . t )
		   ( mu4e-sent-folder      .  "/mykolab/Sent" )
		   ( mu4e-drafts-folder    . "/mykolab/Drafts")
		   ( mu4e-trash-folder     . "/mykolab/Trash" )
		   ( mu4e-refile-folder    . "/mykolab/Archive")
		   ( smtpmail-smtp-server  . "smtp.kolabnow.com" )
		   ( smtpmail-stream-type  . starttls)
		   ( smtpmail-smtp-service . 587 )
		   ( mu4e-sent-folder      . "/mykolab/Sent" )
		   ))
       ,(make-mu4e-context
          :name "soleil"
          :enter-func (lambda () (mu4e-message "Switch to the Soleil context"))
          :vars '( ( user-mail-address       . "alexandre.giuliani@synchrotron-soleil.fr" )
                   ( user-full-name          . "Alexandre Giuliani" )
                   ( smtpmail-smtp-user      .  "giuliani" )
                   ( mu4e-compose-signature  . t )
	 	   ( mu4e-sent-folder      .  "/mykolab/Sent" )
		   ( mu4e-drafts-folder    . "/mykolab/Drafts")
		   ( mu4e-trash-folder     . "/mykolab/Trash" )
		   ( mu4e-refile-folder    . "/mykolab/Archive")
		   ( smtpmail-smtp-server . "smtp.synchrotron-soleil.fr" )
		   ( smtpmail-stream-type  . starttls)
		   ( smtpmail-smtp-service . 587 )
		   ( mu4e-sent-folder      . "/mykolab/Sent" )
		   ))
       ))

;; signature
(setq message-signature-file "~/org/signature.txt") ; Put your signature in this file


(add-hook 'message-send-hook
  (lambda ()
    (unless (yes-or-no-p "Sure you want to send this?")
      (signal 'quit nil))))

;; don't keep message buffers around
(setq message-kill-buffer-on-exit t)

;; Org mode compatibility
(require 'org-mu4e)

;;View in browser
(add-to-list 'mu4e-view-actions
  '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; View as pdf
(add-to-list 'mu4e-view-actions
  '("ViewAsPdf" . mu4e-action-view-as-pdf) t)

;; File attachements
(defun compose-attach-marked-files ()
  "Compose mail and attach all the marked files from a dired buffer."
  (interactive)
  (let ((files (dired-get-marked-files)))
    (compose-mail nil nil nil t)
    (dolist (file files)
          (if (file-regular-p file)
              (mml-attach-file file
                               (mm-default-file-encoding file)
                               nil "attachment")
            (message "skipping non-regular file %s" file)))))

 (load "~/org/agenda-files.el")


;;-------------------------------magit------------------------------------
(global-set-key (kbd "C-x g") 'magit-status)

;;-------------------------------neotree------------------------------------
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;;-------------------------python shell interpreter-------------------------
(setq python-shell-interpreter "python3")


;;-----------------------Org-ref-bibliography----------------------------
(require 'org-ref)
(setq reftex-default-bibliography '("~/org/manuscripts/library.bib"))

;; see org-ref for use of these variables
(setq org-ref-notes-directory "~/org/references/notes.org"
      org-ref-default-bibliography '("~/org/manuscripts/library.bib")
      org-ref-pdf-directory "~/zotfile/")

(require 'doi-utils)
(require 'org-ref-isbn)
(require 'org-ref-pubmed)

;;---------------------------ox-pandoc----------------------------
(with-eval-after-load 'ox
  (require 'ox-pandoc))
  
;; default options for all output formats
(setq org-pandoc-options '((standalone . t)))
;; cancel above settings only for 'docx' format
(setq org-pandoc-options-for-docx '((standalone . nil)))
;; special settings for beamer-pdf and latex-pdf exporters
;;(setq org-pandoc-options-for-beamer-pdf '((pdf-engine . "xelatex")))
(setq org-pandoc-options-for-latex-pdf '((pdf-engine . "xelatex")))

;;--------------------------org-journal-----------------------------------
(add-to-list 'load-path "~/local/emacs-modes/org-journal") 
(require 'org-journal)
(setq org-journal-dir "~/org/journal" )

;;------------------------emacs custom variable----------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes nil)
 '(package-selected-packages
   (quote
    (## zotxt pdf-tools ess org-babel-eval-in-repl exec-path-from-shell ox-pandoc pandoc-mode org-link-minor-mode pretty-mode org-pdfview org-edna org-edit-latex org-bullets openwith neotree magit helm-bibtexkey)))

 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

