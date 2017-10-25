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
		timer_flag = true;
		time_t start,end;
		timer_count = 0;
	}

	~ProgressBar() {
	}

public: // ===== main methods =====

	void display_progress_bar() {
		REprintf("0%%   10   20   30   40   50   60   70   80   90   100%%\n");
		REprintf("|----|----|----|----|----|----|----|----|----|----|\n");
		flush_console();
	}

	// will finalize display if needed
	void update(float progress) {
		_update_ticks_display(progress);
		if (_ticks_displayed >= _max_ticks)
			_finalize_display();
		
		timer_count++;
		
		if (timer_flag) {
		  timer_flag = false;
		  time(&start);
		} else if (timer_count % 10 == 0) {
		  time(&end);
		  
		  double rem_time = (std::difftime(end, start) / progress) * (1 - progress);
      int rem_time_simple = (int) rem_time;
		  
		  std::stringstream strs;
		  strs << rem_time_simple;
		  std::string temp_str = strs.str();
		  char const* char_type = temp_str.c_str();
		  
		  REprintf(char_type);
		  REprintf("s\n");
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
  bool timer_flag;
  time_t start,end;
  int timer_count;
  
};

#endif
