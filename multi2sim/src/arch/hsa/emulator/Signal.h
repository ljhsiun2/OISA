/*
 *  Multi2Sim
 *  Copyright (C) 2014  Yifan Sun (yifansun@coe.neu.edu)
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#ifndef ARCH_HSA_EMULATOR_SIGNAL_H
#define ARCH_HSA_EMULATOR_SIGNAL_H

namespace HSA
{

class Signal
{

	// Signal value
	unsigned long long value;

public:

	// Constructor
	Signal(unsigned long long init_value);

	// Get value
	unsigned long long getValue() const { return value; }

	// Set value
	void setValue(unsigned long long value) { this->value = value; }

};

}  // namespace net

#endif
