
/******************************************************************************
 * MODULE     : qt_view_widget.hpp
 * DESCRIPTION: QT view widget class
 * COPYRIGHT  : (C) 2008  Massimiliano Gubinelli
 *******************************************************************************
 * This software falls under the GNU general public license version 3 or later.
 * It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
 * in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
 ******************************************************************************/

#ifndef QT_VIEW_WIDGET_HPP
#define QT_VIEW_WIDGET_HPP

#include "widget.hpp"
#include "basic_renderer.hpp"
#include "qt_widget.hpp"

class QWidget;

/**
 * TODO: description!
 */
class qt_view_widget_rep: public qt_widget_rep {
public:
  QWidget *view;
  basic_renderer current_renderer;
  
public:
  qt_view_widget_rep (QWidget *v);
  ~qt_view_widget_rep ();
  
  virtual void send (slot s, blackbox val);
    // send a message val to the slot s
  virtual blackbox query (slot s, int type_id);
    // obtain information of a given type from the slot s
  virtual widget read (slot s, blackbox index);
    // abstract read access (of type s) of a subwidget at position index
  virtual void write (slot s, blackbox index, widget w);
    // abstract write access (of type s) of a subwidget at position index
  virtual void notify (slot s, blackbox new_val);
    // notification of a change on a slot s which contains a state variable
  //virtual void connect (slot s, widget w2, slot s2);
    // connect a state slot s to another slot s2 of another widget w2
  //virtual void deconnect (slot s, widget w2, slot s2);
    // deconnect a state slot s from another slot s2 of another widget w2
  
  virtual widget plain_window_widget (string s);
  void set_current_renderer(basic_renderer _r) { current_renderer = _r;  }
  basic_renderer get_current_renderer() {  return current_renderer; }
  virtual QWidget* as_qwidget () { return view ; };

};


#endif // QT_VIEW_WIDGET_HPP
