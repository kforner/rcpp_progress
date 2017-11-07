/*
 * progress_bar.h
 *
 * A class that display a progress bar
 *
 * Author: karl.forner@gmail.com
 *
 */
#ifndef _RcppProgress_PROGRESS_BAR_HPP
#define _RcppProgress_PROGRESS_BAR_HPP

#include <R_ext/Print.h>

class ProgressBar {
  public: // ====== LIFECYCLE =====
    
    /**
    * Main constructor
    */
    ~ProgressBar() {
    }
    
    public: // ===== main methods =====
      
      void display_progress_bar();
      // will finalize display if needed
      void update(float progress);
      void end_display();
      
};

#endif
