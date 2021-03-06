(in-package :coleslaw)

(defclass blog ()
  ((author          :initarg :author         :reader author)
   (deploy-dir      :initarg :deploy-dir     :reader deploy-dir)
   (domain          :initarg :domain         :reader domain)
   (feeds           :initarg :feeds          :reader feeds)
   (license         :initarg :license        :reader license)
   (page-ext        :initarg :page-ext       :reader page-ext)
   (plugins         :initarg :plugins        :reader plugins)
   (repo            :initarg :repo           :reader repo)
   (routing         :initarg :routing        :reader routing)
   (separator       :initarg :separator      :reader separator)
   (sitenav         :initarg :sitenav        :reader sitenav)
   (staging-dir     :initarg :staging-dir    :reader staging-dir)
   (theme           :initarg :theme          :reader theme)
   (title           :initarg :title          :reader title))
  (:default-initargs
   :page-ext "html"
   :separator ";;;;;"
   :staging-dir "/tmp/coleslaw"))

(defparameter *config* nil
  "A variable to store the blog configuration and plugin settings.")

(define-condition plugin-conf-error ()
  ((plugin  :initarg :plugin :reader plugin)
   (message :initarg :message :reader message))
  (:report (lambda (condition stream)
             (format stream "~A: ~A" (plugin condition) (message condition))))
  (:documentation "Condition to signal when the plugin is misconfigured."))

(defun enable-plugin (name args)
  "Given a plugin, NAME, compile+load it and call its ENABLE function with ARGS."
  (flet ((plugin-path (sym)
           (app-path "plugins/~(~A~)" sym))
         (plugin-package (sym)
           (format nil "~:@(coleslaw-~A~)" sym)))
    (let ((file (plugin-path name)))
      (load (compile-file file :verbose nil :print nil) :verbose t))
    (let ((package (find-package (plugin-package name))))
      (apply (find-symbol "ENABLE" package) args))))

(defun load-plugins (plugins)
  "Compile and load the listed PLUGINS. It is expected that matching *.lisp files
are in the plugins folder in coleslaw's source directory."
  (setf *injections* nil)
  (dolist (plugin plugins)
    (destructuring-bind (name &rest args) plugin
      (enable-plugin name args))))

(defun discover-config-path (repo-path)
  "Check the supplied REPO-PATH for a .coleslawrc and if one
doesn't exist, use the .coleslawrc in the home directory."
  (let ((repo-config (rel-path repo-path ".coleslawrc")))
    (if (file-exists-p repo-config)
        repo-config
        (rel-path (user-homedir-pathname) ".coleslawrc"))))

(defun load-config (&optional repo-dir)
  "Find and load the coleslaw configuration from .coleslawrc. REPO-DIR will be
preferred over the home directory if provided."
  (with-open-file (in (discover-config-path repo-dir) :external-format '(:utf-8))
    (let ((config-form (read in)))
      (setf *config* (construct 'blog config-form))))
  (load-plugins (plugins *config*)))
