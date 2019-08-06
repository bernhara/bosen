'''
Created on 6 ao�t 2019

@author: orba6563
'''

# TEST
import numpy as np
from numpy import linalg as LA
a = np.arange(9) - 4

b = a.reshape((3, 3))

LA.norm(a)

# SAMPLE DATA
m='''num_labels: 7
feature_dim: 54
0:0.0186763 1:-0.0164335 2:-0.0169998 3:0.0370315 4:0.00644837 5:0.0421807 6:0.00698872 7:-0.00304337 8:-0.00585255 9:0.0935973 10:0.0493765 11:0 12:0.00329131 13:-0.0012124 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00256255 24:0 25:0.00840535 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:0.0168786 37:0 38:0 39:0 40:0 41:0 42:0.0152209 43:0.0174101 44:0 45:-0.00125008 46:-0.00264695 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:-0.00114076 1:-0.0235196 2:0.0447963 3:-0.0133807 4:0.0160463 5:0.00435073 6:-0.0176143 7:-0.0308338 8:-0.011437 9:-0.0470052 10:-5.83057e-05 11:0 12:0.0324549 13:-0.00193525 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:0.0064143 24:0 25:-0.00123802 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00289265 37:0 38:0 39:0 40:0 41:0 42:0.00594705 43:-0.00334087 44:0 45:0.00845456 46:0.0171169 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:-0.0233188 1:0.0016534 2:0.0103553 3:-0.0114836 4:-0.00400769 5:-0.0185372 6:0.00865482 7:-0.0152054 8:-0.0165118 9:-0.0151924 10:-0.00986364 11:0 12:-0.00714924 13:0.00862953 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:0.00722965 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0'''

m1 = m.splitlines()
num_labels_line=m1[0]
feature_dim_line=m1[1]

_, num_labels_str =  num_labels_line.split(':') num_labels = int(num_labels_str)

_, feature_dim_str = feature_dim_line.split(':') feature_dim = int(feature_dim_str)

matrix=m1[2:]

svm_matrix_list=''
for label, l in zip(range(num_labels), matrix):
     svm_line=label + ' ' + l
     svm_matrix_list.append (svm_line)







--
Rapha�l Bernhard
06110 Le Cannet - France
mailto:raphael.bernhard@orange.fr



if __name__ == '__main__':
    pass