"""CirclePack.py
Compute circle packings according to the Koebe-Thurston-Andreev theory,
Following a numerical algorithm by C. R. Collins and K. Stephenson,
"A Circle Packing Algorithm", Comp. Geom. Theory and Appl. 2003.
http://www.ics.uci.edu/~eppstein/PADS/CirclePack.py
"""

import csv
import numpy as np
import operator
import random
from math import pi,acos,asin,sin,e,atan2
from scipy.spatial import Delaunay, ConvexHull

countPoints = 100
minRadius = 30
maxRadius = 50
tolerance = 1+10e-12

internal = {}
external = {}

def CirclePack(internal,external):
    """Find a circle packing for the given data.
    The two arguments should be dictionaries with disjoint keys; the
    keys of the two arguments are identifiers for circles in the packing.
    The internal argument maps each internal circle to its cycle of
    surrounding circles; the external argument maps each external circle
    to its desired radius. The return function is a mapping from circle
    keys to pairs (center,radius) where center is a complex number."""
    
    # Some sanity checks and preprocessing
    if min(external.values()) <= 0:
        raise ValueError("CirclePack: external radii must be positive")
    radii = dict(external)
    for k in internal:
        if k in external:
            raise ValueError("CirclePack: keys are not disjoint")
        radii[k] = 1

    # The main iteration for finding the correct set of radii
    lastChange = 2
    while lastChange > tolerance:
        lastChange = 1
        for k in internal:
            theta = flower(radii,k,internal[k])
            hat = radii[k]/(1/sin(theta/(2*len(internal[k])))-1)
            newrad = hat * (1/(sin(pi/len(internal[k]))) - 1)
            kc = max(newrad/radii[k],radii[k]/newrad)
            lastChange = max(lastChange,kc)
            radii[k] = newrad

    # Recursively place all the circles
    placements = {}
    k1 = next(iter(internal))   # pick one internal circle
    placements[k1] = 0j         # place it at the origin
    k2 = internal[k1][0]        # pick one of its neighbors
    placements[k2] = radii[k1]+radii[k2] # place it on the real axis
    place(placements,radii,internal,k1)  # recursively place the rest
    place(placements,radii,internal,k2)

    return dict((k,(placements[k],radii[k])) for k in radii)

def find_neighbors(pindex, triang):
    neighbors = list()
    for simplex in triang.vertices:
        if pindex in simplex:
            neighbors.extend([simplex[i] for i in range(len(simplex)) if simplex[i] != pindex])
    unordered = list(set(neighbors))
    sort = {}
    for i in range(0, len(unordered)):
	sort[unordered[i]] = atan2(tri.points[unordered[i]][1] - tri.points[pindex][1], tri.points[unordered[i]][0] - tri.points[pindex][0])
    sort_x = sorted(sort.items(), key=operator.itemgetter(1))
    sort = [x[0] for x in sort_x]
    return sort
	
def acxyz(x,y,z):
    """Angle at a circle of radius x given by two circles of radii y and z"""
    try:
        return acos(((x+y)**2 + (x+z)**2 - (y+z)**2)/(2.0*(x+y)*(x+z)))
    except ValueError:
        return pi/3
    except ZeroDivisionError:
        return pi

def flower(radius,center,cycle):
    """Compute the angle sum around a given internal circle"""
    return sum(acxyz(radius[center],radius[cycle[i-1]],radius[cycle[i]])
               for i in range(len(cycle)))

def place(placements,radii,internal,center):
    """Recursively find centers of all circles surrounding k"""
    if center not in internal:
        return
    cycle = internal[center]
    for i in range(-len(cycle),len(cycle)-1):
        if cycle[i] in placements and cycle[i+1] not in placements:
            s,t = cycle[i],cycle[i+1]
            theta = acxyz(radii[center],radii[s],radii[t])
            offset = (placements[s]-placements[center])/(radii[s]+radii[center])
            offset *= e**(-1j*theta)
            placements[t] = placements[center] + offset*(radii[t]+radii[center])
            place(placements,radii,internal,t)


# generate a random set of points #
points = np.random.rand(countPoints, 2)

# get the delaunay triangulation #
tri = Delaunay(points)

# get the convex hull #
hull = ConvexHull(points)

# for points on the convex hull generate a random radius #
# otherwise get the list of neighbor vertices #
for i in range(0, len(points)):
	if i in hull.vertices:
		external[i] = random.randint(minRadius, maxRadius)
	else:
		internal[i] = find_neighbors(i, tri)

# preform the circle packing #
c = CirclePack(internal, external)

# write the data to a text file #
with open('mytxtfile.txt', 'wb') as f:
	for i in c.keys():
		f.write(repr(c[i][0].real) + "\t" + repr(c[i][0].imag) + "\t" + repr(c[i][1]) + "\n")
