
/******************************************************************************
 * MODULE     : qt_tm_widget.cpp
 * DESCRIPTION: The main TeXmacs widget for the Qt GUI
 * COPYRIGHT  : (C) 2008  Massimiliano Gubinelli
 *******************************************************************************
 * This software falls under the GNU general public license version 3 or later.
 * It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
 * in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
 ******************************************************************************/

#include <QtGui>

#include "analyze.hpp"

#include "qt_tm_widget.hpp"
#include "qt_utilities.hpp"
#include "qt_renderer.hpp"
#include "qt_gui.hpp"

#include "qt_basic_widgets.hpp"
#include "qt_simple_widget.hpp"
#include "qt_window_widget.hpp"
#include "QTMWindow.hpp"
#include "QTMStyle.hpp"      // qtstyle()
#include "QTMGuiHelper.hpp"  // needed to connect()
#include "QTMInteractivePrompt.hpp"
#include "QTMInteractiveInputHelper.hpp"


#ifdef Q_WS_MAC
#define UNIFIED_TOOLBAR
// enable the unified toolbar style on the mac. To work properly this requires
// a modification of the widget hierarchy of the main window.
#endif

int menu_count = 0;
list<qt_tm_widget_rep*> waiting_widgets;

void
replaceActions (QWidget* dest, QWidget* src) {
    //NOTE: the parent hierarchy of the actions is not modified while installing
    //      the menu in the GUI (see qt_menu.cpp for this memory management 
    //      policy)
  dest->setUpdatesEnabled(false);
  QList<QAction *> list = dest->actions();
  while (!list.isEmpty()) {
    QAction* a= list.takeFirst();
    dest->removeAction (a);
  }
  list = src->actions();
  while (!list.isEmpty()) {
    QAction* a= list.takeFirst();
    dest->addAction (a);
  }
  dest->setUpdatesEnabled(true);
}

void
replaceButtons(QToolBar* dest, QWidget* src) {
  dest->setUpdatesEnabled(false);
  bool visible = dest->isVisible();
  if (visible) dest->hide(); //TRICK: this is a trick to avoid flicker of the dest widget
  replaceActions (dest, src);
  QList<QObject*> list= dest->children();
  for (int i=0; i<list.count(); i++) {
    QToolButton* button= qobject_cast<QToolButton*> (list[i]);
    if (button) {
      button->setPopupMode (QToolButton::InstantPopup);
      button->setStyle( qtmstyle() );
    }
  }
  if (visible) dest->show(); //TRICK: see above
  dest->setUpdatesEnabled(true);
}

void QTMInteractiveInputHelper::commit(int result) {
  if (wid) {
    if (result == QDialog::Accepted) {
      QString item = "#f";
      QComboBox *cb = sender()->findChild<QComboBox*>("input");
      if (cb) {
        item = cb->currentText();
      }      
      ((qt_input_text_widget_rep*) wid->int_input.rep) -> text=
//      scm_quote (from_qstring (item));
      from_qstring (item);
      ((qt_input_text_widget_rep*) wid->int_input.rep) -> cmd ();      
    }
  }
  sender()->deleteLater();
}


/******************************************************************************
* qt_tm_widget_rep
******************************************************************************/

static void
tweek_iconbar_size (QSize& sz) {
  if (sz.height () >= 24) {
    sz.setWidth (sz.width () + 2);
    sz.setHeight (sz.height () + 6);
  }
  else if (sz.height () >= 20) {
    sz.setHeight (sz.height () + 2);
  }
  else if (sz.height () >= 16) {
    sz.setHeight (sz.height () + 2);
  }
}

qt_tm_widget_rep::qt_tm_widget_rep(int mask, command _quit)
 : qt_view_widget_rep (new QTMWindow (this)), helper (this), 
   full_screen(false), quit(_quit) 
{
  // decode mask
  visibility[0] = (mask & 1)  == 1;  // header
  visibility[1] = (mask & 2)  == 2;  // main
  visibility[2] = (mask & 4)  == 4;  // mode
  visibility[3] = (mask & 8)  == 8;  // focus
  visibility[4] = (mask & 16) == 16; // user
  visibility[5] = (mask & 32) == 32; // footer
  
  // general setup for main window
  
  QMainWindow* mw= tm_mainwindow ();
  mw->setStyle (qtmstyle ());
  mw->menuBar()->setStyle (qtmstyle ()); 
  
  // there is a bug in the early implementation of toolbars in Qt 4.6
  // which has been fixed in 4.6.2 (at least)
  // this is why we change dimension of icons
	
#if (defined(Q_WS_MAC)&&(QT_VERSION>=QT_VERSION_CHECK(4,6,0))&&(QT_VERSION<QT_VERSION_CHECK(4,6,2)))
  mw->setIconSize (QSize (22, 30));  
#else
  mw->setIconSize (QSize (17, 17));
#endif
  mw->setFocusPolicy (Qt::NoFocus);
  
  
  // central widget
  
  QStackedWidget* tw = new QStackedWidget (mw);
  tw->setObjectName("stacked widget"); // to easily find this object
  
  // status bar
  
  QStatusBar* bar= new QStatusBar(mw);
  leftLabel= new QLabel ("Welcome to TeXmacs", mw);
  rightLabel= new QLabel ("Booting", mw);
  leftLabel->setFrameStyle (QFrame::NoFrame);
  rightLabel->setFrameStyle (QFrame::NoFrame);
  {
    QFont f=  leftLabel->font();
    f.setPixelSize(12);
    leftLabel->setFont(f);
    rightLabel->setFont(f);
  }
  bar->addWidget (leftLabel, 1);
  bar->addPermanentWidget (rightLabel);
  bar->setStyle (qtmstyle ());
  
  // NOTE (mg): the following setMinimumWidth command disable automatic 
  // enlarging of the status bar and consequently of the main window due to 
  // long messages in the left label. I found this strange solution here
  // http://www.archivum.info/qt-interest@trolltech.com/2007-05/01453/Re:-QStatusBar-size.html
  // The solution if due to Martin Petricek. He adds:
  //    The docs says: If minimumSize() is set, the minimum size hint will be ignored.
  //    Probably the minimum size hint was size of the lengthy message and
  //    internal layout was enlarging the satusbar and the main window
  //    Maybe the notice about QLayout that is at minimumSizeHint should be
  //    also at minimumSize, didn't notice it first time and spend lot of time
  //    trying to figure this out :)
  
  bar->setMinimumWidth(2);
  mw->setStatusBar (bar);
 
  
  // toolbars
  
  mainToolBar  = new QToolBar ("main toolbar", mw);
  modeToolBar  = new QToolBar ("mode toolbar", mw);
  focusToolBar = new QToolBar ("focus toolbar", mw);
  userToolBar   = new QToolBar ("user toolbar", mw);
 
  mainToolBar->setStyle (qtmstyle ());
  modeToolBar->setStyle (qtmstyle ());
  focusToolBar->setStyle (qtmstyle ());
  userToolBar->setStyle (qtmstyle ());
  
  {
    // set proper sizes for icons
    QPixmap *pxm = the_qt_renderer()->xpm_image ("tm_new.xpm");
    QSize sz = (pxm ? pxm->size() : QSize(24,24));
    tweek_iconbar_size (sz);
    mainToolBar->setIconSize (sz);
    pxm = the_qt_renderer()->xpm_image ("tm_section.xpm");
    sz = (pxm ? pxm->size() : QSize(20,20));
    tweek_iconbar_size (sz);
    modeToolBar->setIconSize(sz);
    pxm = the_qt_renderer()->xpm_image ("tm_add.xpm");
    sz = (pxm ? pxm->size() : QSize(16,16));
    tweek_iconbar_size (sz);
    focusToolBar->setIconSize(sz);
  }  
  
//#if 0
#ifdef UNIFIED_TOOLBAR

  mw->setUnifiedTitleAndToolBarOnMac(true);

  QWidget *cw= new QWidget ();
  
  QBoxLayout *bl = new QBoxLayout(QBoxLayout::TopToBottom, cw);
  bl->setContentsMargins(2,2,2,2);
  bl->setSpacing(0);
  cw->setLayout(bl);
  bl->addWidget(tw);
  
  mw->setCentralWidget(cw);
  
  
  //WARNING: dumbToolBar is the toolbar installed on the top area of the
  //main widget which is  then unified in the title bar. 
  //to overcome some limitations of the unified toolbar implementation we
  //install the real toolbars as widgets in this toolbar.
  
  dumbToolBar = mw->addToolBar("dumb toolbar");
  dumbToolBar->setMinimumHeight(30);

  //these are the actions related to the various toolbars to be installed in
  //the dumb toolbar.
  
  mainToolBarAction = dumbToolBar->addWidget(mainToolBar);
  modeToolBarAction = NULL;

  
  //a ruler
  rulerWidget = new QWidget(cw);
  rulerWidget->setSizePolicy(QSizePolicy::Ignored, QSizePolicy::Fixed);
  rulerWidget->setMinimumHeight(1);
  rulerWidget->setBackgroundRole(QPalette::Dark);
  rulerWidget->setVisible(false);
  rulerWidget->setAutoFillBackground(true);
//  rulerWidget = new QLabel("pippo", cw);
  
  
  bl->insertWidget(0, modeToolBar);
  bl->insertWidget(1, rulerWidget);
  bl->insertWidget(2, focusToolBar);
  bl->insertWidget(3, userToolBar);

#else
  mw->setCentralWidget(tw);
  
  mw->addToolBar (mainToolBar);
  mw->addToolBarBreak ();
  mw->addToolBar (modeToolBar);
  mw->addToolBarBreak ();
  mw->addToolBar (focusToolBar);
  mw->addToolBarBreak ();
  mw->addToolBar (userToolBar);
 // mw->addToolBarBreak ();
#endif
  
  // handles visibility
  // at this point all the toolbars are empty so we avoid showing them
  // same for the menu bar if we are not on the Mac (where we do not have
  // other options)
  
  mainToolBar->setVisible (false);
  modeToolBar->setVisible (false);
  focusToolBar->setVisible (false);
  userToolBar->setVisible (false);
  tm_mainwindow()->statusBar()->setVisible (true);
#ifndef Q_WS_MAC
  tm_mainwindow()->menuBar()->setVisible (false);
#endif  
 
}

qt_tm_widget_rep::~qt_tm_widget_rep () {
  if (DEBUG_QT)
    cout << "qt_tm_widget_rep::~qt_tm_widget_rep\n";
  
  
    // clear any residual waiting menu installation
  waiting_widgets = remove(waiting_widgets, this);
  
    // we must detach the QTMWidget canvas from the Qt widget hierarchy otherwise
    // it will be destroyed when the view member of this object is deallocated
    // this is another problem related to our choice of letting qt_widget own its
    // underlying QWidget.
  
  QTMWidget *canvas = tm_canvas();
  QStackedWidget* tw= tm_centralwidget();
  if (canvas) {
    tw->removeWidget(canvas);
    canvas->setParent(NULL);
    QTMWidget::all_widgets.remove(canvas);
  }
  
}

void qt_tm_widget_rep::updateVisibility()
{
#define XOR(exp1,exp2) (((!exp1) && (exp2)) || ((exp1) && (!exp2)))

  bool old_mainVisibility = mainToolBar->isVisible();
  bool old_modeVisibility = modeToolBar->isVisible();
  bool old_focusVisibility = focusToolBar->isVisible();
  bool old_userVisibility = userToolBar->isVisible();
  bool old_statusVisibility = tm_mainwindow()->statusBar()->isVisible();

  bool new_mainVisibility = visibility[1] && visibility[0];
  bool new_modeVisibility = visibility[2] && visibility[0];
  bool new_focusVisibility = visibility[3] && visibility[0];
  bool new_userVisibility = visibility[4] && visibility[0];
  bool new_statusVisibility = visibility[5];
  
  if ( XOR(old_mainVisibility,  new_mainVisibility) )
    mainToolBar->setVisible (new_mainVisibility);
  if ( XOR(old_modeVisibility,  new_modeVisibility) )
    modeToolBar->setVisible (new_modeVisibility);
  if ( XOR(old_focusVisibility,  new_focusVisibility) )
    focusToolBar->setVisible (new_focusVisibility);
  if ( XOR(old_userVisibility,  new_userVisibility) )
    userToolBar->setVisible (new_userVisibility);
  if ( XOR(old_statusVisibility,  new_statusVisibility) )
    tm_mainwindow()->statusBar()->setVisible (new_statusVisibility);

#ifndef Q_WS_MAC
  bool old_menuVisibility = tm_mainwindow()->menuBar()->isVisible();
  bool new_menuVisibility = visibility[0];

  if ( XOR(old_menuVisibility,  new_menuVisibility) )
    tm_mainwindow()->menuBar()->setVisible (new_menuVisibility);
#endif

//#if 0
#ifdef UNIFIED_TOOLBAR

  // do modifications only if needed to reduce flicker
  if ( XOR(old_mainVisibility,  new_mainVisibility) ||
      XOR(old_modeVisibility,  new_modeVisibility) )
  {
    // ensure that the topmost visible toolbar is always unified on Mac
    // (actually only for main and mode toolbars, unifying focus is not
    // appropriate)
    
    QBoxLayout *bl = qobject_cast<QBoxLayout*>(tm_mainwindow()->centralWidget()->layout());
    
    if (modeToolBarAction)
      modeToolBarAction->setVisible(modeToolBar->isVisible());
    mainToolBarAction->setVisible(mainToolBar->isVisible());
    
    //WARNING: jugglying around bugs in Qt unified toolbar implementation
    //do not try to change the order of the following operations....
    
    if (mainToolBar->isVisible()) {       
      bool tmp = modeToolBar->isVisible();
      dumbToolBar->removeAction(modeToolBarAction);
      dumbToolBar->addAction(mainToolBarAction);
      bl->insertWidget(0, rulerWidget);
      bl->insertWidget(0, modeToolBar);
      mainToolBarAction->setVisible(true);
      rulerWidget->setVisible(true);
      modeToolBar->setVisible(tmp);
      if (modeToolBarAction)
        modeToolBarAction->setVisible(tmp);
      dumbToolBar->setVisible(true);
    } else { 
      dumbToolBar->removeAction(mainToolBarAction);
      if (modeToolBar->isVisible()) {
        bl->removeWidget(rulerWidget);
        rulerWidget->setVisible(false);
        bl->removeWidget(modeToolBar);
        if (modeToolBarAction == NULL) {
          modeToolBarAction = dumbToolBar->addWidget(modeToolBar);
        } else {
          dumbToolBar->addAction(modeToolBarAction);
        }
        dumbToolBar->setVisible(true);
      } else {
        dumbToolBar->setVisible(false);
        dumbToolBar->removeAction(modeToolBarAction);
      }
    }
  }
#endif // UNIFIED_TOOLBAR
#undef XOR
}


void
qt_tm_widget_rep::send (slot s, blackbox val) {
  if (DEBUG_QT)
    cout << "qt_tm_widget_rep::send " << slot_name (s) << LF;
  
  switch (s) {
    case SLOT_INVALIDATE:
    {
      TYPE_CHECK (type_box (val) == type_helper<coord4>::id);
      coord4 p= open_box<coord4> (val);
      if (DEBUG_QT)
        cout << "Invalidating rect " << rectangle(p.x1,p.x2,p.x3,p.x4) << LF;
      qt_renderer_rep* ren = (qt_renderer_rep*)get_renderer (this);
      QTMWidget *canvas = qobject_cast <QTMWidget*>(view);
      if (ren && canvas) {
        SI x1 = p.x1, y1 = p.x2, x2 = p.x3, y2 = p.x4;    
        ren->outer_round (x1, y1, x2, y2);
        ren->decode (x1, y1);
        ren->decode (x2, y2);
        canvas->invalidate_rect (x1,y2,x2,y1);
      }
    }
      break;
    case SLOT_INVALIDATE_ALL:
    {
      ASSERT (is_nil (val), "type mismatch");
      if (DEBUG_QT)
        cout << "Invalidating all"<<  LF;
      QTMWidget *canvas = qobject_cast <QTMWidget*>(view);
      if (canvas) canvas->invalidate_all ();
    }
      break;
      
    case SLOT_EXTENTS:
    {
      TYPE_CHECK (type_box (val) == type_helper<coord4>::id);
      coord4 p= open_box<coord4> (val);
      QRect rect = to_qrect (p);
        //NOTE: rect.topLeft is ignored since it is always (0,0)
      tm_canvas() -> setExtents(rect);
#if 0
        //cout << "p= " << p << "\n";
      QSize sz= to_qrect (p).size ();
      QSize ws= tm_scrollarea () -> size ();
      sz.setHeight (max (sz.height (), ws.height () - 4));
        //FIXME: the above adjustment is not very nice and useful only in papyrus 
        //       mode. When setting the size we should ask the GUI of some 
        //       preferred max size and set that without post-processing.
        //      tm_canvas () -> setFixedSize (sz);
      tm_canvas() -> setExtentsSize(sz);
#endif
    }
      break;
    case SLOT_HEADER_VISIBILITY:
    {
      TYPE_CHECK (type_box (val) == type_helper<bool>::id);
      bool f= open_box<bool> (val);
      visibility[0] = f;
      updateVisibility();
    }
      break;
    case SLOT_MAIN_ICONS_VISIBILITY:
    {
      TYPE_CHECK (type_box (val) == type_helper<bool>::id);
      bool f= open_box<bool> (val);
      visibility[1] = f;
      updateVisibility();
    }
      break;
    case SLOT_MODE_ICONS_VISIBILITY:
    {
      TYPE_CHECK (type_box (val) == type_helper<bool>::id);
      bool f= open_box<bool> (val);
      visibility[2] = f;
      updateVisibility();
    }
      break;
    case SLOT_FOCUS_ICONS_VISIBILITY:
    {
      TYPE_CHECK (type_box (val) == type_helper<bool>::id);
      bool f= open_box<bool> (val);
      visibility[3] = f;
      updateVisibility();
    }
      break;
    case SLOT_USER_ICONS_VISIBILITY:
    {
      TYPE_CHECK (type_box (val) == type_helper<bool>::id);
      bool f= open_box<bool> (val);
      visibility[4] = f;
      updateVisibility();
    }
      break;
    case SLOT_FOOTER_VISIBILITY:
    {
      TYPE_CHECK (type_box (val) == type_helper<bool>::id);
      bool f= open_box<bool> (val);
      visibility[5] = f;
      updateVisibility();
    }
      break;
      
    case SLOT_LEFT_FOOTER:
    {
      TYPE_CHECK (type_box (val) == type_helper<string>::id);
      string msg= open_box<string> (val);
      leftLabel->setText (to_qstring (tm_var_encode (msg)));
      leftLabel->update ();
    }
      break;
    case SLOT_RIGHT_FOOTER:
    {
      TYPE_CHECK (type_box (val) == type_helper<string>::id);
      string msg= open_box<string> (val);
      rightLabel->setText (to_qstring (tm_var_encode (msg)));
      rightLabel->update ();
    }
      break;
      
    case SLOT_SCROLL_POSITION:
    {
      TYPE_CHECK (type_box (val) == type_helper<coord2>::id);
      coord2 p= open_box<coord2> (val);
      QPoint pt= to_qpoint (p);
      if (DEBUG_QT)
        cout << "Position (" << pt.x() << "," << pt.y() << ")\n ";
      tm_scrollarea()->setOrigin(pt);
    }
      break;
      
    case SLOT_SCROLLBARS_VISIBILITY:
        // ignore this: qt handles scrollbars independently
        //                send_int (THIS, "scrollbars", val);
      break;
      
    case SLOT_INTERACTIVE_MODE:
    {
      TYPE_CHECK (type_box (val) == type_helper<bool>::id);

      if (open_box<bool> (val) == true) {
        prompt = new QTMInteractivePrompt (int_prompt, int_input);
        tm_mainwindow()->statusBar()->removeWidget(leftLabel);
        tm_mainwindow()->statusBar()->removeWidget(rightLabel);
        tm_mainwindow()->statusBar()->addWidget(prompt, 1);
        prompt->start();
      } else {
        if (prompt) prompt->end();
        tm_mainwindow()->statusBar()->removeWidget(prompt);
        tm_mainwindow()->statusBar()->addWidget(leftLabel);
        tm_mainwindow()->statusBar()->addPermanentWidget(rightLabel);
        leftLabel->show();
        rightLabel->show();
        delete prompt;
        prompt = NULL;
      }
    }
      break;
      
    case SLOT_SHRINKING_FACTOR:
      TYPE_CHECK (type_box (val) == type_helper<int>::id);
      if (QTMWidget* tmw= qobject_cast<QTMWidget*> (tm_canvas())) {
        int new_sf = open_box<int> (val);
        if (DEBUG_QT) cout << "New shrinking factor :" << new_sf << LF;
        tmw->tm_widget()->handle_set_shrinking_factor (new_sf);
      }
      break;
      
    case SLOT_FILE:
    {
      TYPE_CHECK (type_box (val) == type_helper<string>::id);
      string file = open_box<string> (val);
      if (DEBUG_QT) cout << "File: " << file << LF;
#if (QT_VERSION >= 0x040400)
      view->window()->setWindowFilePath(to_qstring(tm_var_encode(file)));
#endif
    }
      break;
      
      
    default:
      qt_view_widget_rep::send (s, val);
  }
}


blackbox
qt_tm_widget_rep::query (slot s, int type_id) {
  if (DEBUG_QT)
    cout << "qt_tm_widget_rep::query " << slot_name (s) << LF;
  
  switch (s) {
    case SLOT_SCROLL_POSITION:
    {
      TYPE_CHECK (type_id == type_helper<coord2>::id);
      QPoint pt= tm_canvas()->origin();
      if (DEBUG_QT)
        cout << "Position (" << pt.x() << "," << pt.y() << ")\n";
      return close_box<coord2> (from_qpoint (pt));
    }
      
    case SLOT_EXTENTS:
    {
      TYPE_CHECK (type_id == type_helper<coord4>::id);
      QRect rect= tm_canvas()->extents();
      coord4 c= from_qrect (rect);
      //if (DEBUG_QT) 
        cout << "Canvas geometry " << rect << LF;
      return close_box<coord4> (c);
    }
      
    case SLOT_VISIBLE_PART:
    {
      TYPE_CHECK (type_id == type_helper<coord4>::id);
      QSize sz = tm_canvas()->surface()->size();
        //sz.setWidth(sz.width()-2);
      QPoint pos = tm_canvas()->backing_pos;
      coord4 c = from_qrect(QRect(pos,sz));
      if (DEBUG_QT) 
        cout << "Visible Region " << c << LF;
      return close_box<coord4> (c);
    }
      
    case SLOT_USER_ICONS_VISIBILITY:
      TYPE_CHECK (type_id == type_helper<bool>::id);
      return close_box<bool> (visibility[4]);
      
    case SLOT_FOCUS_ICONS_VISIBILITY:
      TYPE_CHECK (type_id == type_helper<bool>::id);
      return close_box<bool> (visibility[3]);
      
    case SLOT_MODE_ICONS_VISIBILITY:
      TYPE_CHECK (type_id == type_helper<bool>::id);
      return close_box<bool> (visibility[2]);
      
    case SLOT_MAIN_ICONS_VISIBILITY:
      TYPE_CHECK (type_id == type_helper<bool>::id);
      return close_box<bool> (visibility[1]);
      
    case SLOT_HEADER_VISIBILITY:
      TYPE_CHECK (type_id == type_helper<bool>::id);
      return close_box<bool> (visibility[0]);
      
    case SLOT_FOOTER_VISIBILITY:
      TYPE_CHECK (type_id == type_helper<bool>::id);
      return close_box<bool> (visibility[5]);
      
    case SLOT_INTERACTIVE_INPUT:
      TYPE_CHECK (type_id == type_helper<string>::id);
    {
      qt_input_text_widget_rep* w =((qt_input_text_widget_rep*) int_input.rep);
      if (w->ok) {
        return close_box<string>(scm_quote(w->text));
      } else {
        return close_box<string>("#f");
      }
    }
      
    case SLOT_INTERACTIVE_MODE:
      TYPE_CHECK (type_id == type_helper<bool>::id);
      return close_box<bool> (false); // FIXME: who needs this info?
      
    default:
      return qt_view_widget_rep::query (s, type_id);
  }
}

widget
qt_tm_widget_rep::read (slot s, blackbox index) {
  if (DEBUG_QT) cout << "[qt_tm_widget_rep] ";
  return qt_view_widget_rep::read (s, index);
}


void
qt_tm_widget_rep::install_main_menu () {
  widget tmp = main_menu_widget;
  main_menu_widget = waiting_main_menu_widget;
  QMenu* m= concrete (main_menu_widget)->get_qmenu();
  if (m) {
    {
      QMenuBar *dest = tm_mainwindow()->menuBar();
      QWidget *src = m;
      replaceActions(dest,src);
      QList<QAction*> list = dest->actions();
      for (int i= 0; i < list.count(); i++) {
        QAction* a= list[i];
        if (a->menu()) {
          QObject::connect(a->menu(), SIGNAL(aboutToShow()),
                           the_gui->gui_helper, SLOT(aboutToShowMainMenu()));
          QObject::connect(a->menu(), SIGNAL(aboutToHide()),
                           the_gui->gui_helper, SLOT(aboutToHideMainMenu()));
        }
      }
    }
  }
}

void
qt_tm_widget_rep::write (slot s, blackbox index, widget w) {
  if (DEBUG_QT)
    cout << "qt_tm_widget_rep::write " << slot_name (s) << LF;
  
  switch (s) {
    case SLOT_CANVAS:
    {
      check_type_void (index, "SLOT_CANVAS");
      QStackedWidget* tw= tm_centralwidget();
      QWidget *new_widget= concrete(w)->get_canvas();
      QWidget *old_widget= tw->currentWidget();
      if (old_widget) {
        tw->removeWidget(old_widget);
        old_widget->setParent(NULL);
      }
      if (new_widget) {
        tw->addWidget(new_widget);
      }
      QTMWidget* new_canvas= qobject_cast<QTMWidget*>(new_widget);
      QTMWidget* old_canvas= qobject_cast<QTMWidget*>(old_widget);
      if (old_canvas) {
          QTMWidget::all_widgets.remove(old_canvas);
      }
      if (new_canvas) {
        QTMWidget::all_widgets.insert(new_canvas);
        new_canvas->setFocusPolicy (Qt::StrongFocus);
        new_canvas->setFocus ();
      }        
    }
      break;
      
    case SLOT_MAIN_MENU:
      check_type_void (index, "SLOT_MAIN_MENU");
    {
      waiting_main_menu_widget = w;
      if (menu_count <=0) {
        install_main_menu();
      } else { 
          // menu interaction ongoing.
          // postpone menu installation when the menu interaction is done
        if (DEBUG_QT)
          cout << "Main menu is busy: postponing menu installation" << LF;
        if (!contains(waiting_widgets,this))
          waiting_widgets << this;
      }
    }
      break;
      
    case SLOT_MAIN_ICONS:
      check_type_void (index, "SLOT_MAIN_ICONS");
    {
        //cout << "widget :" << (void*)w.rep << LF;
      main_icons_widget = w;
      QMenu* m= concrete (w)->get_qmenu();
      replaceButtons (mainToolBar, m);
      updateVisibility();
    }
      break;
      
    case SLOT_MODE_ICONS:
      check_type_void (index, "SLOT_MODE_ICONS");
    {   
      mode_icons_widget = w;
      QMenu* m= concrete (w)->get_qmenu();
      replaceButtons (modeToolBar, m);
      updateVisibility();
    }
      break;
      
    case SLOT_FOCUS_ICONS:
      check_type_void (index, "SLOT_FOCUS_ICONS");
    {   
      focus_icons_widget = w;
      QMenu* m= concrete (w)->get_qmenu();
      replaceButtons (focusToolBar, m);
      updateVisibility();
    }
      break;
      
    case SLOT_USER_ICONS:
      check_type_void (index, "SLOT_USER_ICONS");
    {   
      user_icons_widget = w;
      QMenu* m= concrete (w)->get_qmenu();
      replaceButtons (userToolBar, m);
      updateVisibility();
    }
      break;
      
    case SLOT_INTERACTIVE_PROMPT:
      check_type_void (index, "SLOT_INTERACTIVE_PROMPT");
      int_prompt= concrete (w);
      break;
      
    case SLOT_INTERACTIVE_INPUT:
      check_type_void (index, "SLOT_INTERACTIVE_INPUT");
      int_input= concrete (w);
      break;
      
    default:
      qt_view_widget_rep::write (s, index, w);
  }
}


void
qt_tm_widget_rep::set_full_screen(bool flag) {
  full_screen = flag;
  QWidget *win = tm_mainwindow()->window();  
  if (win) {
    if (flag ) {
      // remove the borders from some widgets
      tm_scrollarea()->setFrameShape(QFrame::NoFrame);
#ifdef UNIFIED_TOOLBAR
      //HACK: we disable unified toolbar since otherwise
      //  the application will crash when we return in normal mode
      // (bug in Qt? present at least with 4.7.1)
      tm_mainwindow()->setUnifiedTitleAndToolBarOnMac(false);
      tm_mainwindow()->centralWidget()->layout()->setContentsMargins(0,0,0,0);
#endif
//      tm_mainwindow()->window()->setContentsMargins(0,0,0,0);
      //win->showFullScreen();
       win->setWindowState(win->windowState() ^ Qt::WindowFullScreen);
    } else {
      bool cache = visibility[0];
      visibility[0] = false;
      updateVisibility();
//      win->showNormal();
      win->setWindowState(win->windowState() ^ Qt::WindowFullScreen);

      visibility[0] = cache;
      updateVisibility();
      // reset the borders of some widgets
      tm_scrollarea()->setFrameShape(QFrame::Box);
#ifdef UNIFIED_TOOLBAR
      tm_mainwindow()->centralWidget()->layout()->setContentsMargins(2,2,2,2);
      //HACK: we reenable unified toolbar (see above HACK) 
      //  the application will crash return in normal mode
      tm_mainwindow()->setUnifiedTitleAndToolBarOnMac(true);
#endif
    }
  }
  
  tm_scrollarea()->setHorizontalScrollBarPolicy(flag ? Qt::ScrollBarAlwaysOff : Qt::ScrollBarAsNeeded);
  tm_scrollarea()->setVerticalScrollBarPolicy(flag ? Qt::ScrollBarAlwaysOff : Qt::ScrollBarAsNeeded);
}

widget
qt_tm_widget_rep::plain_window_widget (string s) {
    // creates a decorated window with name s and contents w
  widget w= qt_view_widget_rep::plain_window_widget (s);
    // to manage correctly retain counts
  qt_window_widget_rep* wid= (qt_window_widget_rep*) (w.rep);
  return wid;
}

//#if !defined(_MBD_USE_NEW_INTERACTIVE_PROMPT)
#if 0
void
qt_tm_widget_rep::do_interactive_prompt () {
  QStringList items;
 // QString label= to_qstring (tm_var_encode (((qt_text_widget_rep*) int_prompt.rep)->str));
  qt_input_text_widget_rep* it = (qt_input_text_widget_rep*) (int_input.rep);
  if ( N(it->def) == 0) {
    items << "";
  } else {
    for (int j=0; j < N(it->def); j++) {
      items << to_qstring(it->def[j]);
    }
  }
  QDialog *d = new QDialog (tm_scrollarea()->window());

  QVBoxLayout* vl = new QVBoxLayout();
  QHBoxLayout *hl = new QHBoxLayout();
  
 // QLabel *lab = new QLabel (label,&d);
  QLayoutItem *lab = int_prompt->as_qlayoutitem ();
  QComboBox *cb = new QComboBox(d);
  cb-> setObjectName("input"); // to find it
  cb -> setSizeAdjustPolicy (QComboBox::AdjustToMinimumContentsLength);
  cb -> setEditText (items[0]);
  int minlen = 0;
  for(int j=0; j < items.count(); j++) {
    cb -> addItem (items[j]);
    int c = items[j].count();
    if (c > minlen) minlen = c;
  }
  cb -> setMinimumContentsLength (minlen>50 ? 50 : (minlen < 2 ? 10 : minlen));
  cb -> setEditable (true);
    // apparently the following flag prevents Qt from substituting an history item
    // for an input when they differ only from the point of view of case (upper/lower)
    // eg. if the history contains aAAAAa and you type AAAAAA then the combo box
    // will retain the string aAAAAa
  cb->setDuplicatesEnabled(true); 
  cb->completer()->setCaseSensitivity(Qt::CaseSensitive);
  
  if (QLabel *_lab = qobject_cast<QLabel*>(lab ->widget())) _lab -> setBuddy (cb);
  hl -> addItem (lab);
  hl -> addWidget (cb);
  vl -> addLayout (hl);
  
  if (ends (it->type, "file") || it->type == "directory") {
      // autocompletion
    QCompleter *completer = new QCompleter(d);
    QDirModel *dirModel = new QDirModel(d);
    completer->setModel(dirModel);
    cb->setCompleter(completer);
  }
  
  {
    QDialogButtonBox* buttonBox =
    new QDialogButtonBox (QDialogButtonBox::Ok | QDialogButtonBox::Cancel,
                          Qt::Horizontal, d);
    QObject::connect (buttonBox, SIGNAL (accepted()), d, SLOT (accept()));
    QObject::connect (buttonBox, SIGNAL (rejected()), d, SLOT (reject()));
    vl -> addWidget (buttonBox);
  }
  d->setLayout (vl);
  
  QRect wframe = view->window()->frameGeometry();
  QPoint pos = QPoint(wframe.x()+wframe.width()/2,wframe.y()+wframe.height()/2);
  
  d->setWindowTitle("Interactive Prompt");
  d->updateGeometry();
  QSize sz = d->sizeHint();
  QRect r; r.setSize(sz);
  r.moveCenter(pos);
  d->setGeometry(r);
  QObject::connect (d, SIGNAL (finished (int)), &helper, SLOT(commit (int)));
#if (QT_VERSION >= 0x040500)
  d->open();
#else
  d->exec();
#endif
}
#else

#endif
