
/******************************************************************************
* MODULE     : tm_buffer.hpp
* DESCRIPTION: TeXmacs main data structures (buffers, views and windows)
* COPYRIGHT  : (C) 1999  Joris van der Hoeven
*******************************************************************************
* This software falls under the GNU general public license version 3 or later.
* It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
* in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
******************************************************************************/

#ifndef TM_BUFFER_H
#define TM_BUFFER_H
#include "server.hpp"

extern tree the_et;
path new_document ();
void delete_document (path rp);
void set_document (path rp, tree t);
int  create_window_id ();
void destroy_window_id (int);

class tm_buffer_rep {
public:
  url name;               // full name
  string abbr;            // abbreviated name
  string fm;              // buffer format
  url extra;              // for special buffers, like help buffer
  array<tm_view> vws;     // views attached to buffer
  bool read_only;         // buffer is read only?
  bool secure;            // is the buffer secure?
  tm_buffer prj;          // buffer which corresponds to the project
  bool in_menu;           // should the buffer be listed in the menus?

  path rp;                    // path to the document's root in the_et
  tree project;               // a project the document belongs to
  tree style;                 // the style of the buffer
  hashmap<string,tree> init;  // initial values of environment variables
  hashmap<string,tree> fin;   // final values of environment variables
  hashmap<string,tree> ref;   // all labels with references
  hashmap<string,tree> aux;   // auxiliary output: toc, bib, etc.

  inline tm_buffer_rep (url name2):
    name (name2), abbr (as_string (tail (name))),
    fm ("texmacs"), extra (url_none ()), vws (0),
    read_only (false), secure (is_secure (name2)),
    prj (NULL), in_menu (true),
    rp (new_document ()),
    project (""), style ("style"),
    init ("?"), fin ("?"), ref ("?"), aux ("?") {}

  inline ~tm_buffer_rep () {
    delete_document (rp); }

  bool needs_to_be_saved ();
  bool needs_to_be_autosaved ();
};

#endif // defined TM_BUFFER_H
