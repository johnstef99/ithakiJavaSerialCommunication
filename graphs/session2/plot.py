import matplotlib.pyplot as plt
import numpy as np
from matplotlib.pyplot import figure

dpi = 100

output_dir = "./"
g1_response = []

# G1
with open('./packets_without_errors.csv', 'r') as f:
    for line in f.readlines():
        __,time = line.split(';')
        g1_response.append(int(time))

figure(num=None, figsize=(12, 6),dpi=dpi, facecolor='w', edgecolor='k')
g1_range = (min(g1_response), 100)
plt.hist(g1_response, 20, g1_range, histtype='bar', rwidth=0.95)
plt.xlabel("response time in ms")
plt.ylabel("number of packets")
plt.savefig(output_dir+'G1.png', transparent=True)

g2_response = []
g2_repeat = []

# G2
with open('./packets_with_errors.csv', 'r') as f:
    for line in f.readlines():
        __,repeat,time = line.split(';')
        g2_response.append(int(time))
        g2_repeat.append(int(repeat))


figure(num=None, figsize=(12, 6),dpi=dpi, facecolor='w', edgecolor='k')
g2_range = (min(g2_response), 200)
plt.hist(g2_response, 20, g2_range, histtype='bar', rwidth=0.95)
plt.xlabel("response time in ms")
plt.ylabel("number of packets")
plt.savefig(output_dir+'G2.png', transparent=True)

# G3
g2_packages_per_repeat = []
for i in range(max(g2_repeat)+1):
    packages = 0
    for p in g2_repeat:
        if p == i:
            packages = packages+1
    g2_packages_per_repeat.append(packages)

figure(num=None, figsize=(12, 6),dpi=dpi, facecolor='w', edgecolor='k')
plt.bar(np.arange(len(g2_packages_per_repeat)), g2_packages_per_repeat)
plt.xlabel("number of packets")
plt.ylabel("number of repeats")
plt.savefig(output_dir+'G3.png', transparent=True)
plt.show()

total_bytes = 0
total_error_bytes = 0
for i in range(len(g2_packages_per_repeat)):
    bytess = g2_packages_per_repeat[i]*(i+1) * 16
    error = g2_packages_per_repeat[i]*(i) * 16
    total_bytes += bytess
    total_error_bytes += error
print("Total bytes " + str(total_bytes))
print("Total error bytes " + str(total_error_bytes))
error_over_total = total_error_bytes/total_bytes
print("error bytes/total bytes " + str(error_over_total))
print("BER -> " + str( 1 - (error_over_total**(1/16)) ))
