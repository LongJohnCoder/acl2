; ACL2 Books - Cert.pl Build System Documentation
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

(in-package "ACL2")
(include-book "xdoc/top" :dir :system)

(defxdoc cert.pl
  ;; BOZO parents?
  :short "@('cert.pl') is a mature, user-friendly, industrial-strength tool for
certifying ACL2 @(see books)."

  :long "<h3>Introduction</h3>

<p>For \"pure\" ACL2 projects&mdash;even large ones&mdash;@('cert.pl') will let
you to certify any book, whenever you like, without writing any Makefiles.  If
your book includes supporting books that aren't certified, @('cert.pl') will
rebuild exactly the necessary books, in parallel, even if they're in other
directories.</p>

<p>For more complex projects, where (say) besides just certifying ACL2 books
you also need to build large C libraries and certify ACL2 books that you're
generating on the fly, @('cert.pl') can automate the dependency tracking for
your regular ACL2 books, and you can easily integrate this information into
your project's @('Makefile').</p>

<p>For industrial-scale projects, @('cert.pl') has many features that you may
find valuable.  For instance:</p>

<ul>

<li>ACL2 features like packages, ttags, @(see add-include-book-dir), and @(see
save-exec) images are properly supported.</li>

<li>Parallel builds (as in @('make -j')) are well-supported.  For the truly
adventurous, you may even be able to distribute your build over a cluster.</li>

<li>Tools like @('critpath.pl') can help you to more effectively optimize your
build time for multi-core environments.</li>

<li>Dependency scanning is cached for better performance on NFS file
systems.</li>

</ul>

<p>@('cert.pl') was originally developed in 2008 by Sol Swords at <a
href='http://www.centtech.com/'>Centaur Technology</a>, and has been actively
used and improved since then.  It is now distributed in the @('build')
directory of the Community Books, and is today the main tool behind
@('books/Makefile').</p>


<h3>Copyright Information</h3>

<p>@('cert.pl') and related tools<br/>
Copyright (c) 2008-2013 by Sol Swords @('<sswords@centtech.com>')</p>

<p>This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version.</p>

<p>This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
details.</p>

<p>You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 675 Mass
Ave, Cambridge, MA 02139, USA.</p>


<h3>Using @('cert.pl')</h3>

<p>This documentation is really a <b>tutorial</b>, not a reference.  We
recommend that you read the topics in order.</p>

<p>We assume basic familiarity with a Unix environment, e.g., we expect that
you know how to edit your startup scripts to set up a @('PATH'), create
symbolic links, etc.</p>")



(defxdoc cert-pl-on-windows
  :parents (|0. Preliminaries|)
  :short "Special notes about using @('cert.pl') on Windows."

  :long "<p>There are two main ways you can run @('cert.pl') (and for that
matter ACL2) on Windows.</p>

<h3>Option 1: Virtual Machine</h3>

<p>A good way to run ACL2 on Windows may be to install an operating system like
Linux inside of virtual machine.  Some options are:</p>

<ul>

<li><a href='https://www.virtualbox.org/'>VirtualBox</a> (free)</li>

<li><a href='https://www.vmware.com/products/player/'>VMWare Player</a> (free
for personal use)</li>

<li><a href='https://www.vmware.com/products/workstation/'>VMWare
Workstation</a> (commercial)</li>

</ul>

<p>Using a virtual machine certainly has its downsides.  You're committing to a
certain amount of configuration, sacrificing some disk space and memory, and
probably losing some performance.  Even so, you may find this option to be
generally more reliable than using Unix tools like @('make') and Lisp runtimes
on a Windows system.</p>


<h3>Option 2: Native Windows</h3>

<p>If you prefer to avoid using a virtual machine, you may still be able to use
@('cert.pl') on Windows.  Unlike other operating systems, Windows does not
include a typical Unix environment with commands like @('ls'), @('rm'),
@('grep'), etc, so using ACL2 on Windows typically means installing a Unix
emulation layer such as <a href='http://www.cygwin.com/'>cygwin</a> or <a
href='http://www.mingw.org/wiki/MSYS'>msys</a>.</p>

<p>We do not know which to recommend because we have experienced problems on
both!  With msys, we have seen @('make') hang when we try parallel builds.
With cygwin, we have sometimes seen \"random\" CCL crashes.  From time to time,
we have successfully used @('cert.pl') on msys with a single-threaded
build.</p>

<p>Both cygwin and msys have their own Perl packages available.  For
@('cert.pl') to work, please make sure you are using the Cygwin or Msys version
of Perl.  Native Windows versions of Perl, such as Strawberry Perl, are <b>not
known to work</b>.</p>

<p>We intend for @('cert.pl') to work on Windows.  If you experience any
problems that you believe are due to @('cert.pl') itself, rather than with
@('make') or with your Lisp, then we would appreciate your help with
beta-testing and with making it more robust.</p>")



(defxdoc |0. Preliminaries|
  :parents (cert.pl)
  :short "Where to find @('cert.pl'), how to set up your environment before
using it, and the supporting software you'll need."

  :long "<h3>Prerequisite Software</h3>

<p>We assume that you have a basic, sensible Unix environment; Windows users
should see @(see cert-pl-on-windows).</p>

<p>We assume that you have <a href='http://www.gnu.org/software/make/'>GNU
Make</a> installed and available as @('make') in your @('$PATH').  Some
operating systems (e.g., FreeBSD) use a non-GNU make by default.  You can check
your copy by running @('make --version'); it should say something like \"GNU
Make 3.81.\"</p>

<p>We assume you have <a href='http://www.perl.org/'>Perl</a> installed, and
that your @('perl') executable is in your @('$PATH').</p>

<p>We assume you have <a href='http://www.cs.utexas.edu/~moore/acl2/'>ACL2</a>
or one of its variants like ACL2(h), ACL2(p), or ACL2(r) installed, and that
you know how to launch ACL2&mdash;usually with a script named @('saved_acl2')
or @('saved_acl2h') or similar.</p>

<p>We assume you have a copy of the ACL2 <a
href='https://code.google.com/p/acl2-books/'>Community Books</a> for your
version of ACL2; they are usually put in @('acl2/books').</p>


<h3>Adding @('cert.pl') to your @('$PATH')</h3>

<p>To make running @('cert.pl') more convenient, it's a good idea to have it
accessible in your @('$PATH').  The @('cert.pl') script and related tools like
@('critpath.pl') and @('clean.pl') are found in the @('build') directory of the
Community Books.</p>

<ul>

<li>We recommend that you edit your startup scripts (e.g., @('.bashrc') or
similar) to add @('acl2/books/build') to your @('$PATH').</li>

<li>You could alternately set up symlinks to @('acl2/books/build/cert.pl') and
the other scripts from a directory that is already in your path, for instance,
@('~/bin') is commonly used for this.</li>

</ul>

<p>To test that this is working, you can run @('cert.pl --help').  It should
print a usage message, e.g.,:</p>

@({
     $ cert.pl --help

     cert.pl: Automatic dependency analysis for certifying ACL2 books.

     Usage:
     perl cert.pl <options, targets>
     ...
})


<h3>Helping @('cert.pl') find ACL2</h3>

<p>It is convenient for @('cert.pl') to \"just know\" where your copy of ACL2
is located.</p>

<ul>

<li>We recommend that you configure your @('$PATH') so that running @('acl2')
will invoke @('acl2').  You could do this by adding a symlink to your
@('saved_acl2') script, named @('acl2'), to a directory like @('~/bin').</li>

<li>Alternately, you may set the environment variable @('$ACL2') to point to
your ACL2 executable.  For instance, you might add something like the following
to your @('.bashrc') or similar:

@({
      export ACL2=/path/to/acl2/saved_acl2
})</li>

</ul>

<p>To ensure that @('cert.pl') is properly detecting your copy of ACL2, you can
run @('cert.pl') with no arguments.  The output should look something like
this:</p>

@({
     $ cert.pl
     ACL2 executable is /home/jared/acl2/saved_acl2h
     System books directory is /home/jared/acl2/books
     ...
})

<p>Please check that <b>both</b> the ACL2 executable and your @('books')
directory are correctly detected.  If the books directory is not correct, you
may need to help @('cert.pl') find it by setting another environment variable,
e.g.,</p>

@({
    export ACL2_SYSTEM_BOOKS=/home/jared/acl2/books
})

<p>At this point, @('cert.pl') should be configured properly and ready to
use.</p>")



(defxdoc |1. Certifying Simple Books|
  :parents (cert.pl)
  :short "How to use certify simple ACL2 books, take advantage of parallel
builds, and manage the dependency scanner."

  :long "<h3>Basic Example</h3>

<p>Let's use @('cert.pl') to build a simple ACL2 project.  Say we have two ACL2
books:</p>

@({
    ;; inc.lisp            |  ;; prop.lisp
    (in-package \"ACL2\")    |  (in-package \"ACL2\")
    (defun inc (x)         |  (include-book \"inc\")
      (+ 1 x))             |
                           |  (defthm natp-of-inc
                           |    (implies (natp x)
                           |             (natp (inc x)))
})

<p>We can now certify either book by just running @('cert.pl') on it.  Let's
first just build the @('inc') book:</p>

@({
$ cert.pl inc
ACL2 executable is /home/jared/bin/acl2
System books directory is /home/jared/acl2/books/
Making /home/jared/acl2/books/tmp/inc.cert on 25-Oct-2013 21:49:11
Successfully built /home/jared/acl2/books/tmp/inc.cert
-rw-rw-r-- 1 jared logic 378 Oct 25 21:49 inc.cert
})

<p>If we run @('ls'), we'll now see some new files:</p>

<ul>

<li>@('inc.cert'), the ACL2 @(see certificate) for @('inc.lisp')</li>

<li>@('inc.cert.out'), the log for certifying @('inc'); this shows the
instructions that were submitted to ACL2, and the output from the @(see
certify-book) command.</li>

<li>@('inc.lx64fsl') or @('.fasl') or perhaps some other extension, depending
on the underlying host Lisp.</li>

<li>@('Makefile-tmp'), a Makefile that @('cert.pl') generated.</li>
</ul>

<p>We might now run @('cert.pl') to certify the @('prop') book.  Since @('inc')
is already certified, it only needs to build @('prop'):</p>

@({
$ cert.pl prop
ACL2 executable is /home/jared/bin/acl2
System books directory is /home/jared/acl2/books/
Making /home/jared/acl2/books/tmp/prop.cert on 26-Oct-2013 07:55:16
Successfully built /home/jared/acl2/books/tmp/prop.cert
-rw-rw-r-- 1 jared logic 465 Oct 26 07:55 prop.cert
})

<p>An @('ls') will now show us many files:</p>

@({
$ ls
inc.cert      inc.lisp     Makefile-tmp  prop.cert.out  prop.lx64fsl
inc.cert.out  inc.lx64fsl  prop.cert     prop.lisp
})

<p>We can delete the generated files with <b>clean.pl</b>, a companion script
of @('cert.pl'):</p>

@({
    $ clean.pl
    clean.pl: scanning for generated files
    clean.pl: found 7 targets (0 seconds)
    clean.pl: deleted 7 files (0 seconds)
    $ ls
    inc.lisp  prop.lisp
})

<p>If we now tell @('cert.pl') to certify the @('prop') book directly, it will
notice that the @('inc') book needs to be certified, and do the right thing:</p>

@({
$ cert.pl prop
ACL2 executable is /home/jared/bin/acl2
System books directory is /home/jared/acl2/books/
Making /home/jared/acl2/books/tmp/inc.cert on 26-Oct-2013 07:59:41
Successfully built /home/jared/acl2/books/tmp/inc.cert
-rw-rw-r-- 1 jared logic 378 Oct 26 07:59 inc.cert
Making /home/jared/acl2/books/tmp/prop.cert on 26-Oct-2013 07:59:42
Successfully built /home/jared/acl2/books/tmp/prop.cert
-rw-rw-r-- 1 jared logic 465 Oct 26 07:59 prop.cert
})


<h3>Useful Features</h3>


<h5>Multiple Targets</h5>

<p>You can tell @('cert.pl') to build multiple top-level books at once, for
instance:</p>

@({
    $ cert.pl foo bar baz
})

<p>will try to certify @('foo.lisp'), @('bar.lisp'), and @('baz.lisp').</p>


<h5>File Name Extensions</h5>

<p>You don't have to include a @('.lisp') or @('.cert') extension, but if you
do, @('cert.pl') will do what you mean.  For instance, the following commands
are all equivalent:</p>

@({
     $ cert.pl foo
     $ cert.pl foo.lisp
     $ cert.pl foo.cert
})

<p>The @('.lisp') form can be handy, e.g., you can do:</p>

@({
     $ cert.pl *.lisp
})


<h5>Parallel Builds (-j)</h5>

<p>You can tell @('cert.pl') to build books in parallel, to take advantage of
multi-core processors.  The @('-j') switch tells it how many processors you
want to use, just like with @('make').  Typically you would want to set @('-j')
no higher than the number of cores your machine has available.  For
instance:</p>

@({
    $ cert.pl -j 2 foo    # for a dual-core system
    $ cert.pl -j 4 foo    # for a 4-core system
    $ cert.pl -j 8 foo    # for an 8-core system
})

<p><b>Warning</b>: setting @('-j') too high can cause serious performance
problems.  If you often use ACL2 on both, say, a 16-core server and a 2-core
laptop, then you may sometimes find yourself accidentally telling the laptop to
run 16 jobs at once!  To avoid this kind of trouble, Jared sets up an
@('alias') like this in his @('.bashrc'):</p>

@({
   # in the laptop's .bashrc:
   alias cj=\"cert.pl -j 2\"

   # in the server's .bashrc:
   alias cj=\"cert.pl -j 16\"
})

<p>This way, just running @('cj') will use an appropriate number of cores no
matter which system is being used.</p>

<p><b>Warning</b>: the CPU count is not the only factor to consider when
choosing a @('-j') to use.  You may also need to consider how much memory your
machine has.  For instance, on a quad-core laptop you'd like to run 4 jobs at
once, but if you only have 8 GB of memory and each job takes 4 GB, then using
@('-j 4') may get you into swapping trouble.</p>


<h5>Keep Going (-k)</h5>

<p>Like @('make'), @('cert.pl') will ordinarily stop as soon as it fails to
build any book.</p>

<p>Occasionally this may not be what you want.  You might have made a change
that you know will break several books.  One way to find out what's broken is
to just try to build everything.  The default behavior&mdash;stopping as soon
as anything is broken&mdash;will only let you find one broken book at a
time.</p>

<p>In this situation, you may want to instead do, e.g.,</p>

@({
    $ cert.pl -j 4 top.cert -k
})

<p>This is identical to @('make')'s \"keep going\" switch.</p>


<h5>Prepare (-p)</h5>

<p>Sometimes you want to work on a particular book, which you know won't
certify (e.g., because you're only part-way through a proof).  Before you begin
working on the book again, you may want to rebuild any supporting books it
depends on.  The @('-p') flag lets you do this, e.g.,</p>

@({
    $ cert.pl -p mybook
})

<p>won't try to certify @('mybook.lisp'), but it will try to certify any books
that @('mybook.lisp') includes.</p>


<h3>Dependency Scanning Limitations</h3>

<p>Keep in mind that @('cert.pl') is a dumb Perl script.  It's quite easy to
fool it using @(see macros) or other tricks.  But you don't even need to get
that fancy&mdash;a newline will do the trick.  For instance, if @('foo.lisp')
contains the following, then @('cert.pl') will not think it depends on
@('bar'):</p>

@({
   (include-book     ;; newline to fool dependency scanner
     \"bar\")
})

<p>This is documented behavior that you may rely on.</p>

<p>For instance, sometimes we put multi-line comments in books with performance
comparisons or other kinds of examples or testing code.  This code might need
additional include-books to work.  By putting in newlines, we can hide these
books from the dependency scanner, to avoid slowing down our build with
unnecessary dependencies.  For instance:</p>

@({
    (defun my-function ...)

    #|| ;; this benchmark says my-function is 3x faster than yours:

    (include-book           ;; fool dependency scanner
       \"your-function\")

    :q
    (time (loop for i fixnum from 1 to 100000 do (my-function ...)))
    (time (loop for i fixnum from 1 to 100000 do (your-function ...)))
    ||#

    (defthm my-lemma ...)
})

<p>You can also trick @('cert.pl') in the other direction, to add additional,
unnecessary dependencies.  For instance, a macro library might have some unit
testing books to try to ensure the macros are behaving correctly.  To ensure
these tests get run when the library is rebuilt, we might write a top book like
this:</p>

@({
    (in-package \"ACL2\")
    (include-book \"module1\")
    (include-book \"module2\")
    (include-book \"module3\")

    #|| ;; trick cert.pl into running the unit tests:
    (include-book \"module1-tests\")
    (include-book \"module2-tests\")
    (include-book \"module3-tests\")
    ||#
})")



(defxdoc |2. Pre Certify-Book Commands|
  :parents (cert.pl)
  :short "How to add commands to be executed before calling @(see
certify-book).  You'll need this to use ACL2 features like @(see defpkg) and
@(see add-include-book-dir)."

  :long "<h3>Background: Pre @(see certify-book) Commands</h3>

<p>ACL2 commands like @(see defpkg) can't be embedded within books.  Instead,
when using raw ACL2 to certify books, you typically define the package before
issuing the @(see certify-book) command.  The @(see defpkg) command then
becomes part of the book's @(see portcullis).</p>

<p>For example, here is how to successfully certify a book with its own
package, using raw ACL2:</p>

@({
   $ cat mybook.lisp
   (in-package \"MY-PACKAGE\")
   (defun f (x) (+ x 1))

   $ acl2
   ACL2 !> (defpkg \"MY-PACKAGE\"
             (union-eq *acl2-exports*
                       *common-lisp-symbols-from-main-lisp-package*))
   ACL2 !> (certify-book \"mybook\" ?)
})

<p>If this doesn't make sense, please see the documentation for @(see books),
especially see @(see book-example) which explains something like the above in
far greater detail.</p>


<h3>Individual @('.acl2') Files</h3>

<p>For @('cert.pl') to certify books with packages, it needs to be able to find
these extra @('defpkg') commands that can't go directly into the book.</p>

<p>The most basic way to tell @('cert.pl') how to certify a file like
@('mybook.lisp') is to put the @('defpkg') form into a corresponding file,
named @('mybook.acl2'):</p>

@({
    $ cat mybook.acl2
    (in-package \"ACL2\")
    (defpkg \"MY-PACKAGE\"
      (union-eq *acl2-exports*
                *common-lisp-symbols-from-main-lisp-package*))
    ;; no certify-book command, unlike in legacy files for Makefile-generic
})

<p>At this point, we can simply run:</p>

@({
    $ cert.pl mybook
    ACL2 executable is ...
    System books directory is ...
    Making .../mybook.cert on 24-Oct-2013 09:25:03
    Successfully built .../my-book.cert
    -rw-rw-r-- 1 jared logic 513 Oct 24 09:25 mybook.cert
})

<p>If you inspect the resulting @('mybook.cert.out') output log, you'll see
that these instructions that were picked up from the @('.acl2') file:</p>

@({
    $ cat mybook.cert.out
    -*- Mode: auto-revert -*-
    ...
    ; instructions from .acl2 file mybook.acl2:
    (in-package \"ACL2\")
    (defpkg \"MY-PACKAGE\"
      (union-eq *acl2-exports*
                *common-lisp-symbols-from-main-lisp-package*))
    ...
})


<h3>Directory-Wide @('cert.acl2') Files</h3>

<p>It's very common for all of the books in a directory to want to use the same
packages.  Instead of setting up a corresponding @('.acl2') file for every
single book, it is often much more convenient to use a special, directory-wide
@('.acl2') file, called @('cert.acl2').</p>

<p>Here is how @('cert.pl') chooses the @('.acl2') file to use when you ask
it to certify @('foo.lisp'):</p>

<ol>
<li>First, if a file named @('foo.acl2') exists, then it will be used.</li>
<li>Else, if a file named @('cert.acl2') exists, then it will be used.</li>
<li>Otherwise, no @('.acl2') files will be used; no pre @(see certify-book)
    commands will be given.</li>
</ol>

<p>In the typical case, then, where you have a whole directory of books that
are all supposed to be in some package, you just need a single @('cert.acl2')
file that gets that @(see defpkg) form loaded.</p>")


(defxdoc |3. Custom Certify-Book Commands|
  :parents (cert.pl)
  :short "How to control the options that will be passed to the @(see
certify-book) command.  You'll need this to allow the use of <see topic='@(url
defttag)'>trust tags</see>, @(see skip-proofs), @(see defaxiom)s, and so
forth."

  :long "<p>By default, ACL2's @(see certify-book) command does not allow your
books to use unsafe features that can easily lead to unsoundness.  For
instance, your book may not skip proofs, add arbitrary axioms, or use trust
tags to smash raw Lisp definitions.</p>

<p>However, these restrictions can be lifted by giving @('certify-book')
options such as @(':skip-proofs-okp t') and @(':ttags :all').  In such cases
the resulting certificate is annotated to reflect that it is less trustworthy
and @(see include-book) may print warnings about the book or even reject it
when given suitable options.  See @(see certify-book) and @(see include-book)
for details.</p>

<p>By default @('cert.pl') will similarly disallow these unsafe features.  More
precisely, the default command it uses to certify books is looks like this:</p>

@({  (certify-book \"foo\" ? t)  })

<p>If you want to permit your book to use trust tags, skipped proofs, etc.,
you'll need to tell @('cert.pl') that you want to give different arguments to
@('certify-book').</p>

<p>You can do this on a per-book or per-directory basis by adding a special
comment into the corresponding @('.acl2') file.  If you don't know what an
@('.acl2') file is, see @(see |2. Pre Certify-Book Commands|).</p>

<p>Example: to allow all trust tags, you could use a comment like this:</p>

@({
    ; cert-flags: ? t :ttags :all
})

<p>Example: to allow trust tags and skip-proofs, you could use:</p>

@({
    ; cert-flags: ? t :ttags :all :skip-proofs-okp t
})

<p>Rules of thumb:</p>

<ul>

<li>Your @('cert-flags') should probably start with @('? t').</li>

<li>Even if you have a long list of :ttags, keep them <b>on one line</b>.  A
dumb perl script is reading this, after all.</li>

<li>You should probably <b>not</b> use arguments like @(':acl2x'),
@(':write-port'), or @(':pcert').</li>

</ul>")


(defxdoc |4. Optimizing Build Time|
  :parents (cert.pl)
  :short "How to use @('critpath.pl') to profile your build, so that you can
focus your efforts on speeding up the most critical parts."

  :long "<p>Alongside @('cert.pl') is another script, @('critpath.pl'), that
can be used to analyze the certification times for your files.  When you are
dealing with a large collection of ACL2 books, this can be a useful tool for
seeing where to speed up your build.</p>

<p>Before using @('critpath.pl'), you must tell @('cert.pl') that you want it
to record certification times.  This is done by setting the @('$TIME_CERT')
environment variable.  For instance, you might add the following to your
@('.bashrc') or equivalent:</p>

@({
    export TIME_CERT=yes
})

<p>After setting this variable, you will need to recertify your books.</p>

<p>When @('cert.pl') sees that @('$TIME_CERT') is set, it writes out additional
@('.cert.time') files that record how long each book took to certify.  The
@('critpath.pl') script then correlates these files with the dependencies among
your books to give you a report.</p>

<p>For instance, here is a report for the @('arithmetic-5/top') book, circa
October 2013.</p>

@({
$ cd arithmetic-5
$ critpath.pl top.cert
Critical Path

File                            Cumulative       Time    Speedup     Remove
top.cert                           2.0 min    2.0 sec    2.0 sec    2.0 min
floor-mod/top.cert                 2.0 min    1.8 sec    1.8 sec    1.7 min
floor-mod/logand.cert              1.9 min   33.7 sec   33.7 sec   37.0 sec
floor-mod/logand-helper.cert       1.4 min    7.1 sec    7.1 sec    7.1 sec
floor-mod/more-floor-mod.cert      1.2 min   16.7 sec   15.1 sec   15.1 sec
floor-mod/floor-mod.cert          58.1 sec   19.9 sec   19.9 sec   30.8 sec
...
})

<p>The critical path is the longest chain of books in an unrealistically ideal
build environment with infinite CPUs to draw upon.  The report shows what books
comprise the critical path, and how long each of them takes.  It also shows
you:</p>

<ul>

<li>The @('speedup') time for each book.  This measures how much the critical
path could be reduced by speeding up the book, without affecting its
dependencies.  A book with a large @('speedup') time may be good candidate for
new hints to make proofs faster.</li>

<li>The @('remove') time for each book.  This measures how much your build
would speed up if you didn't need to build this book at all.  The @('remove')
time should always exceed the @('speedup') time.  In some cases, it may be much
larger, since by removing a book we may also avoid needing to build some of the
books it depends on.</li>

</ul>

<p>While the very simple usage shown above is often sufficient, the
@('critpath.pl') script has a number of other options that may occasionally be
useful.  See @('critpath.pl --help') for details.</p>")


(defxdoc |5. Raw Lisp and Other Dependencies|
  :parents (cert.pl)
  :short "How to use @('depends-on') to tell @('cert.pl') about additional,
non-Lisp files that your books depend on."

  :long "<p>Some ACL2 books load extra files in unusual ways.  For
instance,</p>

<ul>

<li>An ACL2 book for verifying a Java program might use @(see io) routines to
load @('encrypt.java'), or</li>

<li>An ACL2 book with trust tags might use @(see include-raw) to load in some
extra raw Lisp file named @('server-raw.lsp').</li>

</ul>

<p>In either case, since these extra files are not being loaded using @(see
include-book), @('cert.pl') will not automatically know that these book depend
on @('encrypt.java') and @('server-raw.lsp').</p>

<p>To tell @('cert.pl') about additional dependencies, you may put a special
@('depends-on') comment in your book.  For the Java program we might write
something like this:</p>

@({
    ; (depends-on \"encrypt.java\")
    (defconsts (*java-file* state)
      (read-java-program \"encrypt.java\"))
})

<p>Whereas for the server, you could write, e.g.,</p>

@({
    ; (depends-on \"server-raw.lsp\")
    (include-raw \"server-raw.lsp\")
})

<p>This dependency mechanism is good enough to handle situations where you are
directly reading in these source or data files.  However, it is <b>not</b>
general enough to handle the situations where the file you are reading needs to
be rebuilt.</p>

<p>For instance, suppose that our Java book doesn't verify a source code file
like @('encrypt.java'), but instead verifies the output of the Java compiler,
i.e., @('encrypt.class').  Normally we would need to build @('encrypt.class')
whenever @('encrypt.java') is updated, by running a command like</p>

@({
    $ javac encrypt.java
})

<p>We can still use a @('depends-on') comment to tell @('cert.pl') that our
ACL2 book depends on @('encrypt.class'), e.g.,</p>

@({
    ; (depends-on \"encrypt.class\")
    (defconsts (*class-file* state)
      (read-java-class-file \"encrypt.class\"))
})

<p>This is better than nothing.  @('cert.pl') will at least know it needs to
recertify our ACL2 book if the @('.class') file changes.  However, there's no
way to tell @('cert.pl') that this @('.class') file also depends on
@('encrypt.java'), so editing @('encrypt.java') won't be enough to trigger a
recertification.</p>

<p>When your project gets to this point&mdash;needing a build system that can
deal with both ACL2 books and other kinds of files&mdash;you have exceeded the
ability of @('cert.pl') as a purely standalone tool.  It now becomes a tool
to help you write a Makefile for your whole project.</p>")



(defxdoc |6. Static Makefiles|
  :parents (cert.pl)
  :short "How to use @('cert.pl') within a larger Makefile that needs to know
how to build non-ACL2 files (e.g., C libraries) or dynamically generated ACL2
books."

  :long "<p>For many ACL2 projects, @('cert.pl') may allow you to entirely
avoid needing to write any Makefiles.  But sometimes it's not enough.  For
instance:</p>

<ul>

<li>If your project involves dynamically generating new ACL2 books,
@('cert.pl') has no way to see their dependencies.</li>

<li>If your project has a non-ACL2 component that needs to be built in some
special way, e.g., say you're linking ACL2 with a C library and you need to
recompile the library when you change its code, @('cert.pl') has no support for
building the C library.</li>

</ul>

<p>In these cases, the general approach is to write an ordinary @('Makefile'),
but use @('cert.pl') to automate the dependency scanning for all of the static
ACL2 books.</p>


<h3>Basic Makefile Generation</h3>

<p>Ordinarily, when you run a command like @('cert.pl foo'), what happens
is:</p>

<ul>

<li>@('cert.pl') scans @('foo') for @(see include-book) commands, etc., to
figure out the dependencies of @('foo').</li>

<li>It writes these dependencies into a temporary Makefile named
@('Makefile-tmp').</li>

<li>It invokes @('make') on @('Makefile-tmp') to do the actual build.</li>

</ul>

<p>When you use @('cert.pl') as part of your own Makefile, you don't want it to
run @('make') for you.  Instead, you just want it to do the dependency analysis
and write out a Makefile that your Makefile can <a
href='http://www.gnu.org/software/make/manual/make.html#Include'>include</a>.</p>

<p>This is done using the @('-s') switch.  For instance, here's how we could
create a Makefile for the @('arithmetic-5') library:</p>

@({
    $ cd acl2/books/arithmetic-5
    $ cert.pl top.cert -s Makefile-arith5
})

<p>The resulting Makefile has all the dependencies for Arithmetic-5:</p>

@({
    # This makefile was generated by running:
    # cert.pl top.cert -s Makefile-arith5
    ...
    ACL2_SYSTEM_BOOKS ?= ..                      # Boilerplate stuff
    export ACL2_BIN_DIR := ../../cn/e/bin
    include $(ACL2_SYSTEM_BOOKS)/build/make_cert

    .PHONY: all-cert-pl-certs
    # Depends on all certificate files.
    all-cert-pl-certs:

    CERT_PL_CERTS := \
        lib/basic-ops/arithmetic-theory.cert \
        ... \
        top.cert

    all-cert-pl-certs: $(CERT_PL_CERTS)
    ...

    lib/basic-ops/integerp-helper.cert : \       # Dependency info
        support/top.cert \
        lib/basic-ops/building-blocks.cert \
        lib/basic-ops/default-hint.cert \
        lib/basic-ops/integerp-helper.lisp
    ...
})

<p>The general idea is then to include the generated @('Makefile') into your
own Makefile.  For real examples of how to do this, see</p>

<ul>

<li>The @('books/Makefile'); just search for @('cert.pl') to see how it is used
to build @('Makefile-books').</li>

<li>The similar use of @('cert.pl') in @('books/projects/milawa/ACL2/Makefile'),
which may in some ways be simpler to understand.</li>

</ul>

<p>There are various options to control whether to emit the boilerplate
section, to rename variables like @('CERT_PL_CERTS'), etc.  See @('cert.pl
--help') for a summary.</p>")


(defxdoc |7. Distributed Builds|
  :parents (cert.pl)
  :short "(Advanced) how to use a distribute ACL2 book building over a cluster
of machines."

  :long "<p>Warning: getting a cluster set up and running smoothly is a
significant undertaking.  Aside from hardware costs, it may take significant
energy to install and administer the system, and you will need to learn how to
effectively use the queuing system.  You'll probably also need to be ready to
do some scripting to work around dumb problems.  Think of this topic as:
<i>some hints that may help you</i>, not <i>a usable guide to setting up a
cluster.</i></p>

<p>At Centaur, @('cert.pl') is successfully used within a <a
href='http://www.rocksclusters.org/'>rocks</a> cluster environment at Centaur,
using the open-source queuing system <a
href='http://www.adaptivecomputing.com/support/download-center/torque-download/'>torque</a>
and the <a
href='http://www.adaptivecomputing.com/products/open-source/maui/'>maui</a>
scheduler.  This clustering software allows for the submission of <a
href='http://en.wikipedia.org/wiki/Portable_Batch_System'>PBS</a> scripts as
jobs.  To support this cluster, @('cert.pl') has certain features.</p>


<h3>Support for PBS directives</h3>

<p>For one, @('cert.pl') writes out a PBS script for each book is going to
certify.  These scripts look like ordinary shell scripts (so they work fine for
use in non-cluster environments), but they contain special comments that the
clustering software understands.</p>

<p>These comments allow you to say, e.g., how much memory a job is going to
take, so that if a job takes more than its allotted memory, the clustering
software may choose to kill it.  The clustering software also uses this memory
limit to ensure that when it allocates a job to a machine, the machine will
have enough physical machine to run the job.</p>

<p>This is really very useful.  If you let a machine start swapping into the
gigabytes, at worst you will need to physically reset it, because it dies a
special kind of horrible death where its load average is 50 and you can't even
\"kill\" anything.  In a slightly better case, you may run into the Linux
overcommit and OOM killer features, which are also really awful.  My favorite
article on the topic, from back before we had the cluster and were running into
this frequently, is <a
href='http://thoughts.davisjeff.com/2009/11/29/linux-oom-killer/'>here</a>.</p>

<p>At any rate, when cert.pl writes out the scripts to certify books, it
includes some PBS commands that say how much memory the book is expected to
take. This is done by a stupid heuristic: we search for @('set-max-mem') lines;
if no such line is found we say the book will take 4 GB, and otherwise we
reserve I think 2-3 GB more than the set-max-mem line calls for. This extra
padding is because set-max-mem only affects the heap, and doesn't account for
the stacks, and we typically build a CCL image with large stacks, as explained
in centaur/ccl-config.lsp, and also because set-max-mem is sort of best thought
of as a soft cap, anyway.</p>


<h3>Support for a Queuing System</h3>

<p>Besides this support for PBS directives, @('cert.pl') also consults an
environment variable @('$STARTJOB').  If this variable isn't set, we default it
to your current @('$SHELL').  When we run ACL2 jobs, we basically use:</p>

@({
    $STARTJOB -c \"acl2 < certify-commands &> foo.cert.out\"
})

<p>So, given a suitable @('startjob') command, @('cert.pl') can automatically
distribute the jobs to your cluster.  A suitable command is one that:</p>

<ul>
<li>Accepts the @('-c') syntax or (without @('-c')) accepts a script.</li>
<li>Waits for the job to finish.</li>
<li>Exits \"transparently\", i.e., with the exit code of the job.</li>
</ul>

<p>A suitable @('startjob') command does not need to support any input/output
redirection; we embed that into the command itself.</p>


<h3>Support for NFS Lag</h3>

<p>We originally found that our builds would often \"fail\" due to the
following scenario:</p>

<ul>
<li>Head node: Makefile submits book A to the queue.</li>
<li>Compute node: Certifies book A successfully.</li>
<li>Head node: startjob returns control to the Makefile.</li>
<li>Head node: Makefile runs @('ls A.cert') to check success.</li>
<li>Head node: @('ls') fails because NFS isn't up to date.</li>
<li>Make thinks there's been a problem and dies.</li>
<li>Moments later @('A.cert') shows up.</li>
</ul>

<p>To avoid this, @('cert.pl') now has special support for NFS lag.  We now use
exit codes instead of files to determine success.  In cases where the exit code
says the job completed successfully, we wait until @('A.cert') becomes visible
to the head node before returning control to the Makefile.</p>")