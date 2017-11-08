/*
 * progress_bar.hpp
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
  public: 
    
    virtual ~ProgressBar() = 0;
    virtual void display() = 0;
    virtual void update(float progress) = 0;
    virtual void end_display() = 0;
      
};

ProgressBar::~ProgressBar() {}

#endif
