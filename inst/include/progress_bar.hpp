/*
 * progress_bar.hpp.hpp
 *
 * A class that display a progress bar
 *
 * Author: karl.forner@gmail.com
 *
 */
#ifndef _RcppProgress_PROGRESS_BAR_HPP
#define _RcppProgress_PROGRESS_BAR_HPP

#include <R_ext/Print.h>
#include <time.h>
#include <stdio.h>
#include <sstream>
#include <string.h>

// for unices only
#if !defined(WIN32) && !defined(__WIN32) && !defined(__WIN32__)
#include <Rinterface.h>
#endif

class ProgressBar {
public: // ====== LIFECYCLE =====

	/**
	 * Main constructor
	 */
	ProgressBar()  {
		_max_ticks = 50;
		_ticks_displayed = 0;
		_finalized = false;
		_mode_flag = 1;
		_timer_flag = true;
		time_t start,end;
		_timer_count = 1;
	}

	~ProgressBar() {
	}

public: // ===== main methods =====

	void display_progress_bar(int mode = 1) {
		this->_mode_flag = mode; 
		if (_mode_flag == 1) {
  		REprintf("0%%   10   20   30   40   50   60   70   80   90   100%%\n");
  		REprintf("|----|----|----|----|----|----|----|----|----|----|\n");
  		flush_console();
		} else if (_mode_flag == 2) {
			REprintf("0%% 10%%\n");
  		REprintf("|----|\n");
  		flush_console();
		}
	}

	// will finalize display if needed
	void update(float progress) {
	  
	  // mode 1: simple progress bar  
	  if (_mode_flag == 1) {
  		
  		_update_ticks_display(progress);
  		if (_ticks_displayed >= _max_ticks)
  			_finalize_display();
	  
	  // mode 2: progress bar with time estimation
	  } else if (_mode_flag == 2) {
	    
	    _update_ticks_display(progress);
	    if (_ticks_displayed >= _max_ticks)
	      _finalize_display();
  		
  		if (_timer_flag) {
  		  _timer_flag = false;
  		  time(&start);
  		} else if (_ticks_displayed >= _max_ticks) {
  		  time(&end);
  		} else if ((int) (((double)_ticks_displayed / (double)_max_ticks) * 100) == 10 * _timer_count) {
        
        _timer_count++;

  		  time(&end);
  		  
  		  double pas_time = std::difftime(end, start);
  		  double rem_time = (pas_time / progress) * (1 - progress);
  		  int pas_time_simple = (int) pas_time;
        int rem_time_simple = (int) rem_time;
        
        std::stringstream rem_strs;
        if (rem_time_simple > 3600) {
          rem_strs << (int) (rem_time_simple / 3600) << "h"; 
        } else if (rem_time_simple > 60) {
          rem_strs << (int) (rem_time_simple / 60) << "min"; 
        } else {
          rem_strs << rem_time_simple << "s"; 
        }
        std::string rem = rem_strs.str();
        
        std::stringstream pas_strs;
        if (pas_time_simple > 3600) {
          pas_strs << (int) (pas_time_simple / 3600) << "h"; 
        } else if (pas_time_simple > 60) {
          pas_strs << (int) (pas_time_simple / 60) << "min"; 
        } else {
          pas_strs << pas_time_simple << "s"; 
        }
        std::string pas = pas_strs.str();
  		  
  		  std::stringstream strs;
  		  strs << "| " << "⌛ " << rem << " (" << pas << ")\n";
  		  std::string temp_str = strs.str();
  		  char const* char_type = temp_str.c_str();
  		  
  		  REprintf(char_type);
  		}
		}
		
	}

	void end_display() {
		update(1);
	}


protected: // ==== other instance methods =====

	// update the ticks display corresponding to progress
	void _update_ticks_display(float progress) {
		int nb_ticks = _compute_nb_ticks(progress);
		int delta = nb_ticks - _ticks_displayed;
		if (delta > 0) {
			_display_ticks(delta);
			_ticks_displayed = nb_ticks;
		}

	}

	void _finalize_display() {
		if (_finalized) return;

		REprintf("|\n");
    flush_console();
		_finalized = true;
	}

	int _compute_nb_ticks(float progress) {
		return int(progress * _max_ticks);
	}

	void _display_ticks(int nb) {
		for (int i = 0; i < nb; ++i) {
			REprintf("*");
			R_FlushConsole();
		}
	}

	// N.B: does nothing on windows
	void flush_console() {
#if !defined(WIN32) && !defined(__WIN32) && !defined(__WIN32__)
	  R_FlushConsole();
#endif
	}

private: // ===== INSTANCE VARIABLES ====
	int _max_ticks;   		// the total number of ticks to print
	int _ticks_displayed; 	// the nb of ticks already displayed
	bool _finalized;
	int _mode_flag;
  bool _timer_flag;
  time_t start,end;
  int _timer_count;
  
};

#endif
