# -*- coding: utf-8 -*-
"""
Created on Tue Sep 11 14:14:43 2018

@author: u0112721
"""

from __future__ import absolute_import, division, print_function

import numpy as np
import datetime
import pygfunction as gt


def writeRecord(tSer,gFunc):
    
	#Author
	#author = input('Insert your name, for documentation purposes:')
	author = 'Iago Cupeiro'
	#Date of generation
	date = str(datetime.date.today())

	#Preliminary checks
	if len(tSer) <> len(gFunc):
		raise Exception('Size of time series and g-function values are not equal')
	elif tSer[0] <> 0 or gFunc[0] <> 0:
		raise Exception('Initial values are not set to zero') 

	# Build the full name of the record, including the configuration, number of holes,
    # distribution and spacing
    # TO-DO
	name = 'SquareConfig_9bor_3x3_B6'
	path = name + '.mo'

	with open(path, 'w') as f:
		f.write('within IBPSA.Fluid.Geothermal.Borefields.Data.GFunctions;\n')
		f.write('record ' + name )
		f.write('extends IBPSA.Fluid.Geothermal.Borefields.Data.GFunctions.Template('
			+ '\n')
		f.write('    timExp={\n')
		for timExp in tSer[:-1]:
			f.write('    ' + str(timExp) + ',\n')
		f.write('    ' + str(tSer[-1]) + '},\n')
		f.write('    gFunc={\n')
		for gFun in gFunc[:-1]:
			f.write('    ' + str(gFun) + ',\n')
		f.write('    ' + str(gFunc[-1]) + '}\n')
		f.write('    );\n')

		f.write('  annotation (\n')
		f.write('    defaultComponentPrefixes = "parameter",\n')
		f.write('    defaultComponentName="gFunc",\n')
		f.write('  Documentation(info="<html>\n')
		f.write('<p>\n')
		f.write('Generated by ' + author + ' on ' + date + '.\n')
		f.write('</p>\n')
		f.write('</html>"));\n')
		f.write('end ' + name + ';')

def main():
    # -------------------------------------------------------------------------
    # Simulation parameters
    # -------------------------------------------------------------------------

    # Borehole dimensions
    D = 0.0             # Borehole buried depth (m)
    H = 149.0           # Borehole length (m)
    r_b = 0.075         # Borehole radius (m)
    B = 6.0             # Borehole spacing (m)

    # Soil thermal properties
    kSoi = 2.5				# Ground thermal conductivity (W/(mK))
    cSoi = 1200				# Specific heat capacity of the soil (J/(kgK))
    dSoi = 1800				# Density of the soil (kg/m3)
    aSoi = kSoi/cSoi/dSoi   # Ground thermal diffusivity (m2/s)


    # Number of segments per borehole
    nSegments = 10

    # Geometrically expanding time vector. 

    nt = 75						   # Number of time steps
    ts = H**2/(9.*aSoi)            # Bore field characteristic time
    #ttsMax = np.exp(5)
    ydes = 25.						# Design projected period (years)
    dt = 3600.		                # (Control) Time step (s)
    tmax = ydes * 8760. * 3600.     # Maximum time
    #tmax = ttsMax*ts                # Maximum time

    time = gt.utilities.time_geometric(dt, tmax, nt)
    # -------------------------------------------------------------------------
    # Borehole fields
    # -------------------------------------------------------------------------

    # Field definition
    N_1 = 3
    N_2 = 3
    nBor = N_1*N_2
    boreField = gt.boreholes.rectangle_field(N_1, N_2, B, B, H, D, r_b)
    gFunc = gt.gfunction.uniform_temperature(boreField, time, aSoi, nSegments=nSegments, disp=True)
    gFunc = gFunc / (2*np.pi*kSoi*H*nBor)

    #plt.plot(tLon, gFunc)
    #plt.show()
    
    #Adding zero as the first element
    time = np.insert(time, 0, 0)
    gFunc = np.insert(gFunc, 0, 0)

    print(time)

    writeRecord(time,gFunc)

    return


# Main function
if __name__ == '__main__':
    main()