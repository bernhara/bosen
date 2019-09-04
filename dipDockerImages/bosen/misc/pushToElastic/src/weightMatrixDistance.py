
# TEST
import numpy as np
from numpy import linalg as LA
import math

import re
from numpy.lib.tests.test_format import dtype

a = np.arange(9) - 4

b = a.reshape((3, 3))

LA.norm(a)

#
# FIXME: the following code should be removed
#

def tmp_build_real_input_matrix_string (sample_data):
    
    # FIXME: following values should be computed
    num_labels=7
    feature_dim=54
    
    sample_data_without_headers=sample_data[30:]
    sample_data_without_feature_index=re.sub('[0-9]+\:', '', sample_data_without_headers)
    
    return (num_labels, feature_dim, sample_data_without_feature_index)
    
# SAMPLE DATA FOR TEST
petuum_m1='''num_labels: 7
feature_dim: 54
0:0.0186763 1:-0.0164335 2:-0.0169998 3:0.0370315 4:0.00644837 5:0.0421807 6:0.00698872 7:-0.00304337 8:-0.00585255 9:0.0935973 10:0.0493765 11:0 12:0.00329131 13:-0.0012124 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00256255 24:0 25:0.00840535 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:0.0168786 37:0 38:0 39:0 40:0 41:0 42:0.0152209 43:0.0174101 44:0 45:-0.00125008 46:-0.00264695 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:-0.00114076 1:-0.0235196 2:0.0447963 3:-0.0133807 4:0.0160463 5:0.00435073 6:-0.0176143 7:-0.0308338 8:-0.011437 9:-0.0470052 10:-5.83057e-05 11:0 12:0.0324549 13:-0.00193525 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:0.0064143 24:0 25:-0.00123802 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00289265 37:0 38:0 39:0 40:0 41:0 42:0.00594705 43:-0.00334087 44:0 45:0.00845456 46:0.0171169 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:-0.0233188 1:0.0016534 2:0.0103553 3:-0.0114836 4:-0.00400769 5:-0.0185372 6:0.00865482 7:-0.0152054 8:-0.0165118 9:-0.0151924 10:-0.00986364 11:0 12:-0.00714924 13:0.00862953 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:0.00722965 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0
0:0.00144582 1:0.00957494 2:-0.00953794 3:-0.00304181 4:-0.00462175 5:-0.00699856 6:0.000492702 7:0.0122706 8:0.00845034 9:-0.00784991 10:-0.00986364 11:0 12:-0.00714924 13:-0.00137047 14:0 15:0 16:0 17:0 18:0 19:0 20:0 21:0 22:0 23:-0.00277035 24:0 25:-0.00143347 26:0 27:0 28:0 29:0 30:0 31:0 32:0 33:0 34:0 35:0 36:-0.00279719 37:0 38:0 39:0 40:0 41:0 42:-0.00423359 43:-0.00281385 44:0 45:-0.0014409 46:-0.002894 47:0 48:0 49:0 50:0 51:0 52:0 53:0'''

m_string_for_unit_test='''num_labels: 7
feature_dim: 54
0:0.0558949 1:-0.0565716 2:-0.0779611 3:0.0423241 4:-0.00242083 5:0.0169353 6:0.00919495 7:-0.017949 8:-0.00199485 9:0.133662 10:0.0998833 11:0.0151293 12:0.0516097 13:-0.00228732 14:0 15:0 16:0 17:-0.00239317 18:0 19:-0.00107492 20:0 21:0 22:0.00863592 23:-0.00256255 24:0 25:0.00530048 26:0 27:0 28:0 29:0 30:-0.00136709 31:0 32:0 33:0 34:0 35:0.0239462 36:0.0455974 37:0.00852857 38:0 39:0 40:0 41:0 42:0.041599 43:0.0174101 44:0.00811878 45:0.00582366 46:0.00476907 47:-0.00159292 48:0 49:0 50:0 51:0.00514562 52:0 53:-0.00154924 
0:-0.0187947 1:0.0152313 2:0.0477335 3:-0.0300272 4:0.0594569 5:0.0241342 6:-0.0462908 7:0.0431373 8:0.0481135 9:-0.025506 10:0.0545374 11:-0.00386806 12:0.0690688 13:-0.00342022 14:0 15:0 16:0 17:0.00627225 18:0 19:-0.00148497 20:0 21:0 22:-0.00138369 23:0.0064143 24:0 25:0.0161013 26:0 27:0 28:0 29:0 30:0.00860215 31:0 32:0 33:0 34:0 35:0.00402787 36:0.0170553 37:-0.00163178 38:0 39:0 40:0 41:0 42:0.0247826 43:-0.00334087 44:-0.00142425 45:0.0156868 46:0.0237789 47:0.00823371 48:0 49:0 50:0 51:-0.00403787 52:0 53:-0.00133389 
0:-0.0258262 1:0.0274772 2:-0.00185329 3:-0.0104548 4:-0.0177723 5:-0.0135234 6:-0.00528279 7:0.00452241 8:0.00817965 9:-0.0214657 10:-0.0349259 11:-0.00405958 12:-0.0281372 13:0.00714377 14:0 15:0 16:0 17:-0.0027572 18:0 19:0.00851424 20:0 21:0 22:-0.00148977 23:-0.00277035 24:0 25:-0.00425477 26:0 27:0 28:0 29:0 30:-0.00144542 31:0 32:0 33:0 34:0 35:-0.00576342 36:-0.0127435 37:-0.0013141 38:0 39:0 40:0 41:0 42:-0.0149835 43:-0.00281385 44:-0.00126335 45:-0.00428667 46:-0.00572602 47:-0.00131994 48:0 49:0 50:0 51:-0.00421198 52:0 53:-0.00134933 
0:-0.00653223 1:0.0123715 2:0.00207562 3:0.00165248 4:-0.0101717 5:-0.00333679 6:0.00108122 7:0.00419787 8:0.00162422 9:-0.0178542 10:-0.0348374 11:-0.00420888 12:-0.0282346 13:-0.00285623 14:0 15:0 16:0 17:-0.00275938 18:0 19:-0.00148576 20:0 21:0 22:-0.00142617 23:-0.00277035 24:0 25:-0.00427691 26:0 27:0 28:0 29:0 30:-0.00144542 31:0 32:0 33:0 34:0 35:-0.00567279 36:-0.0125669 37:-0.0013695 38:0 39:0 40:0 41:0 42:-0.0151093 43:-0.00281385 44:-0.00133877 45:-0.00432352 46:-0.0057103 47:-0.00137741 48:0 49:0 50:0 51:-0.00427011 52:0 53:-0.00142067 
0:-0.00653223 1:0.0123715 2:0.00207562 3:0.00165248 4:-0.0101717 5:-0.00333679 6:0.00108122 7:0.00419787 8:0.00162422 9:-0.0178542 10:-0.0348374 11:-0.00420888 12:-0.0282346 13:-0.00285623 14:0 15:0 16:0 17:-0.00275938 18:0 19:-0.00148576 20:0 21:0 22:-0.00142617 23:-0.00277035 24:0 25:-0.00427691 26:0 27:0 28:0 29:0 30:-0.00144542 31:0 32:0 33:0 34:0 35:-0.00567279 36:-0.0125669 37:-0.0013695 38:0 39:0 40:0 41:0 42:-0.0151093 43:-0.00281385 44:-0.00133877 45:-0.00432352 46:-0.0057103 47:-0.00137741 48:0 49:0 50:0 51:-0.00427011 52:0 53:-0.00142067 
0:-0.0458004 1:0.000583473 2:0.0399301 3:-0.00783992 4:0.000134142 5:-0.0216405 6:0.0185604 7:-0.0437678 8:-0.0456252 9:-0.0329869 10:-0.034298 11:-0.00427329 12:-0.0178797 13:0.00708922 14:0 15:0 16:0 17:0.00697966 18:0 19:-0.00154031 20:0 21:0 22:-0.00150436 23:0.00722965 24:0 25:-0.00429382 26:0 27:0 28:0 29:0 30:-0.0014534 31:0 32:0 33:0 34:0 35:-0.0052165 36:-0.01195 37:-0.00147509 38:0 39:0 40:0 41:0 42:-0.0154523 43:-0.00281385 44:-0.00128283 45:-0.00421058 46:-0.00575873 47:-0.00121692 48:0 49:0 50:0 51:-0.00400737 52:0 53:-0.00139498 
0:0.0475907 1:-0.0114635 2:-0.0120005 3:0.0026929 4:-0.0190545 5:0.000767993 6:0.0216558 7:0.00566142 8:-0.0119215 9:-0.0179954 10:-0.015522 11:0.00548936 12:-0.0181923 13:-0.002813 14:0 15:0 16:0 17:-0.00258276 18:0 19:-0.00144253 20:0 21:0 22:-0.00140575 23:-0.00277035 24:0 25:-0.00429937 26:0 27:0 28:0 29:0 30:-0.00144542 31:0 32:0 33:0 34:0 35:-0.00564857 36:-0.0128255 37:-0.0013686 38:0 39:0 40:0 41:0 42:-0.00572713 43:-0.00281385 44:-0.0014708 45:-0.00436617 46:-0.00564264 47:-0.0013491 48:0 49:0 50:0 51:0.0156518 52:0 53:0.00846878''' 


petuum_m2='''num_labels: 7
feature_dim: 54
0:1.47151 1:0.0871438 2:-0.214651 3:-0.110342 4:-0.229398 5:-0.245189 6:-0.180576 7:-0.320589 8:0.074992 9:0.131998 10:1.93473 11:0.403259 12:1.55033 13:-0.0273264 14:-0.00154609 15:-0.0535776 16:-0.0053314 17:-0.0578093 18:-0.000108347 19:-0.00979735 20:-0.0530444 21:0 22:0.146045 23:0.0357319 24:-0.0444385 25:-0.0074418 26:0.168712 27:0 28:0 29:-0.00298374 30:-0.0301326 31:-0.0139281 32:-0.0251108 33:0.406429 34:0 35:0.801176 36:1.15034 37:0.051819 38:0 39:-0.0700538 40:0 41:0 42:0.707208 43:0.216414 44:0.876815 45:0.285871 46:0.503831 47:-0.0655331 48:0.0676791 49:0 50:0 51:-0.275511 52:-0.400132 53:-0.440606
0:-0.480646 1:-0.107792 2:0.151591 3:0.124172 4:0.0102008 5:0.0556738 6:-0.0113682 7:0.140518 8:0.0705429 9:0.0285185 10:2.73621 11:0.747552 12:2.12478 13:-0.0513337 14:-0.0212861 15:-0.253792 16:-0.15928 17:0.0163755 18:-0.00592904 19:0.0461635 20:0.0862153 21:0 22:0.00831278 23:0.471963 24:0.545878 25:0.753727 26:0.301362 27:0 28:0 29:-0.10404 30:-0.0367716 31:0.049049 32:0.162317 33:-0.175442 34:0 35:0.289024 36:0.157352 37:0.536443 38:0 39:-0.0108778 40:0 41:0 42:0.998233 43:0.399625 44:-0.01665 45:0.917544 46:0.815371 47:0.168793 48:-0.00566184 49:0 50:0 51:-0.20011 52:-0.0771142 53:-0.0995812
0:-1.42748 1:0.333513 2:0.579387 3:0.148116 4:0.00197478 5:-0.00411276 6:0.163158 7:0.324656 8:-0.104953 9:-0.287086 10:-0.974196 11:-0.179193 12:-0.776279 13:0.235312 14:0.101533 15:0.426159 16:0.274893 17:0.136247 18:0.0225526 19:-0.125572 20:-0.00284469 21:0 22:-0.0535718 23:-0.238794 24:-0.140148 25:-0.167609 26:-0.219301 27:0 28:0 29:-0.0478475 30:0.134056 31:-0.00733823 32:-0.0101397 33:-0.0270453 34:0 35:-0.17169 36:-0.222638 37:-0.115782 38:0 39:-0.017904 40:0 41:0 42:-0.325648 43:-0.156454 44:-0.118155 45:-0.262841 46:-0.276976 47:-0.0120602 48:-0.00116718 49:0 50:0 51:-0.0332311 52:-0.0264844 53:-0.00855291
0:-0.0625162 1:-0.021588 2:0.0204855 3:0.000148943 4:0.0146555 5:0.136354 6:0.0137038 7:0.0284361 8:-0.0105475 9:0.0296212 10:-1.01605 11:-0.249521 12:-1.084 13:-0.159603 14:-0.010553 15:-0.053462 16:-0.0167063 17:-0.0493043 18:-0.001882 19:-0.0538977 20:-0.00700198 21:0 22:-0.0187571 23:-0.133438 24:-0.0714613 25:-0.13234 26:-0.0548508 27:0 28:0 29:-0.00468768 30:-0.0149525 31:-0.00578871 32:-0.0245629 33:-0.0444095 34:0 35:-0.194616 36:-0.226298 37:-0.121438 38:0 39:-0.0169968 40:0 41:0 42:-0.349908 43:-0.147678 44:-0.131007 45:-0.259907 46:-0.203115 47:-0.0149827 48:-0.00627165 49:0 50:0 51:-0.067164 52:-0.0424623 53:-0.0292777
0:-0.226272 1:-0.159059 2:-0.302755 3:-0.10172 4:0.0890712 5:-0.194956 6:0.0975146 7:0.11061 8:-0.0120766 9:0.0287029 10:-0.755642 11:-0.261548 12:-0.858426 13:-0.181888 14:-0.0122806 15:-0.0648151 16:-0.0206058 17:-0.0544497 18:-0.00199244 19:-0.0712656 20:-0.00831139 21:0 22:-0.0297281 23:-0.140517 24:-0.0989873 25:-0.165733 26:-0.0499679 27:0 28:0 29:-0.00662365 30:-0.0203242 31:-0.00973883 32:-0.028589 33:-0.0499931 34:0 35:-0.206644 36:-0.258039 37:0.0459474 38:0 39:0.155781 40:0 41:0 42:-0.365587 43:0.0182635 44:-0.141425 45:-0.114869 46:-0.200818 47:-0.0152064 48:-0.00712736 49:0 50:0 51:-0.0652173 52:-0.0394804 53:-0.0291585
0:-1.03475 1:-0.0449331 2:-0.0588839 3:-0.0577204 4:0.2447 5:-0.00492624 6:0.0150396 7:-0.0234772 8:-0.0176803 9:-0.158415 10:-0.994011 11:-0.185493 12:-0.853709 13:0.237145 14:-0.0521548 15:0.0287784 16:-0.0650214 17:0.0397558 18:-0.0120732 19:0.231967 20:-0.00458039 21:0 22:-0.0434889 23:0.0817444 24:-0.128981 25:-0.160462 26:-0.0793744 27:0 28:0 29:0.167827 30:-0.0221808 31:-0.00963983 32:-0.0164252 33:-0.0368227 34:0 35:-0.16637 36:-0.21162 37:-0.130469 38:0 39:-0.0211003 40:0 41:0 42:-0.332611 43:-0.146983 44:-0.122319 45:-0.246573 46:-0.22506 47:-0.0151595 48:-0.00293077 49:0 50:0 51:-0.0422911 52:-0.0364811 53:-0.0149654
0:1.76016 1:-0.0872864 2:-0.175175 3:-0.00265374 4:-0.131202 5:0.257154 6:-0.0974715 7:-0.260155 8:-0.000277626 9:0.226661 10:-0.931039 11:-0.275056 12:-0.102695 13:-0.0523058 14:-0.00371202 15:-0.0292906 16:-0.00794822 17:-0.0308147 18:-0.000567493 19:-0.0175976 20:-0.0104324 21:0 22:-0.00881148 23:-0.076689 24:-0.0618612 25:-0.120139 26:-0.0665807 27:0 28:0 29:-0.00164403 30:-0.00969393 31:-0.00261537 32:-0.057489 33:-0.072717 34:0 35:-0.350882 36:-0.3891 37:-0.26652 38:0 39:-0.0188485 40:0 41:0 42:-0.331686 43:-0.183187 44:-0.347259 45:-0.319225 46:-0.413233 47:-0.045851 48:-0.0445203 49:0 50:0 51:0.683525 52:0.622155 53:0.622142'''

m_final_learning_string_for_unit_test='''num_labels: 7
feature_dim: 54
0:1.47144 1:0.0872032 2:-0.214817 3:-0.110651 4:-0.228583 5:-0.244507 6:-0.180637 7:-0.321078 8:0.0747818 9:0.131684 10:1.93489 11:0.403168 12:1.55104 13:-0.0273093 14:-0.00154632 15:-0.053628 16:-0.00533104 17:-0.0577952 18:-0.000108758 19:-0.00978364 20:-0.0531033 21:0 22:0.146097 23:0.0356558 24:-0.044523 25:-0.0076089 26:0.168612 27:0 28:0 29:-0.00298663 30:-0.0301676 31:-0.0139254 32:-0.0249738 33:0.406692 34:0 35:0.800994 36:1.15042 37:0.0519214 38:0 39:-0.0700568 40:0 41:0 42:0.70763 43:0.215919 44:0.877225 45:0.285476 46:0.504028 47:-0.0655256 48:0.0677376 49:0 50:0 51:-0.275215 52:-0.399866 53:-0.440464 
0:-0.480272 1:-0.108336 2:0.152433 3:0.125286 4:0.00965467 5:0.0553989 6:-0.0113692 7:0.140627 8:0.0706243 9:0.0303401 10:2.7359 11:0.747975 12:2.12499 13:-0.0513447 14:-0.0211192 15:-0.253631 16:-0.1594 17:0.016311 18:-0.0059556 19:0.0460335 20:0.0863098 21:0 22:0.00813342 23:0.471832 24:0.546097 25:0.75415 26:0.301943 27:0 28:0 29:-0.10407 30:-0.0365352 31:0.0490747 32:0.162215 33:-0.175635 34:0 35:0.289125 36:0.157422 37:0.536297 38:0 39:-0.0108776 40:0 41:0 42:0.997918 43:0.400003 44:-0.0169463 45:0.918549 46:0.814989 47:0.168652 48:-0.00565862 49:0 50:0 51:-0.200339 52:-0.0776461 53:-0.0997164 
0:-1.42788 1:0.334107 2:0.578897 3:0.147575 4:0.00125224 5:-0.00466613 6:0.163307 7:0.324682 8:-0.105085 9:-0.287935 10:-0.973895 11:-0.179238 12:-0.776152 13:0.235506 14:0.101633 15:0.425527 16:0.275187 17:0.13631 18:0.0225764 19:-0.125886 20:-0.00284891 21:0 22:-0.0535048 23:-0.238151 24:-0.140277 25:-0.167552 26:-0.219435 27:0 28:0 29:-0.047864 30:0.134013 31:-0.00734179 32:-0.0101393 33:-0.0270235 34:0 35:-0.171564 36:-0.222592 37:-0.115759 38:0 39:-0.0179099 40:0 41:0 42:-0.325551 43:-0.156436 44:-0.118043 45:-0.262799 46:-0.276902 47:-0.0120383 48:-0.00116777 49:0 50:0 51:-0.0332235 52:-0.0264591 53:-0.00855864 
0:-0.0624666 1:-0.0213781 2:0.0203758 3:1.94066e-05 4:0.0147135 5:0.136374 6:0.0136984 7:0.0284069 8:-0.0105363 9:0.0294373 10:-1.01588 11:-0.249585 12:-1.08392 13:-0.159617 14:-0.01056 15:-0.0534689 16:-0.0167022 17:-0.0492712 18:-0.00188523 19:-0.05386 20:-0.00700751 21:0 22:-0.018747 23:-0.133534 24:-0.0715147 25:-0.132296 26:-0.0549106 27:0 28:0 29:-0.00468946 30:-0.0149818 31:-0.00579196 32:-0.02456 33:-0.044388 34:0 35:-0.194567 36:-0.22628 37:-0.121399 38:0 39:-0.016995 40:0 41:0 42:-0.349847 43:-0.147678 44:-0.130916 45:-0.260014 46:-0.203065 47:-0.0149781 48:-0.00627042 49:0 50:0 51:-0.0671432 52:-0.0424049 53:-0.0292807 
0:-0.226411 1:-0.159147 2:-0.3028 3:-0.101703 4:0.0888942 5:-0.194944 6:0.0975324 7:0.110804 8:-0.0120088 9:0.0286053 10:-0.755666 11:-0.261569 12:-0.858638 13:-0.181945 14:-0.0122924 15:-0.0647964 16:-0.020609 17:-0.054418 18:-0.00198706 19:-0.0712592 20:-0.00831753 21:0 22:-0.029709 23:-0.140516 24:-0.0989976 25:-0.165762 26:-0.0500053 27:0 28:0 29:-0.00661423 30:-0.0203486 31:-0.0097513 32:-0.0285875 33:-0.0500118 34:0 35:-0.206621 36:-0.25811 37:0.0458495 38:0 39:0.155783 40:0 41:0 42:-0.365613 43:0.0183356 44:-0.141519 45:-0.114839 46:-0.200777 47:-0.0151943 48:-0.00713098 49:0 50:0 51:-0.0652882 52:-0.0395704 53:-0.0291384 
0:-1.03483 1:-0.0453097 2:-0.0587672 3:-0.0574954 4:0.24539 5:-0.00463638 6:0.0148262 7:-0.0232264 8:-0.0173495 9:-0.158105 10:-0.994249 11:-0.185381 12:-0.854635 13:0.23718 14:-0.0524031 15:0.0292892 16:-0.0652012 17:0.0396558 18:-0.0120775 19:0.232412 20:-0.00458291 21:0 22:-0.0434624 23:0.0814718 24:-0.128923 25:-0.160576 26:-0.079558 27:0 28:0 29:0.167862 30:-0.02227 31:-0.00964755 32:-0.0164037 33:-0.0368633 34:0 35:-0.166431 36:-0.211801 37:-0.130538 38:0 39:-0.0210898 40:0 41:0 42:-0.332809 43:-0.146906 44:-0.122585 45:-0.24665 46:-0.225132 47:-0.0151793 48:-0.00292993 49:0 50:0 51:-0.042424 52:-0.0363997 53:-0.0149317 
0:1.76043 1:-0.0871407 2:-0.175322 3:-0.00303196 4:-0.131321 5:0.256982 6:-0.0973578 7:-0.260215 8:-0.000425939 9:0.225974 10:-0.931099 11:-0.27537 12:-0.10269 13:-0.0524705 14:-0.00371192 15:-0.0292921 16:-0.00794357 17:-0.0307928 18:-0.000562256 19:-0.0176565 20:-0.0104496 21:0 22:-0.00880678 23:-0.0767591 24:-0.0618615 25:-0.120355 26:-0.0666465 27:0 28:0 29:-0.0016385 30:-0.00970977 31:-0.00261667 32:-0.0575509 33:-0.07277 34:0 35:-0.350934 36:-0.389054 37:-0.266372 38:0 39:-0.0188536 40:0 41:0 42:-0.331728 43:-0.183237 44:-0.347216 45:-0.319723 46:-0.413141 47:-0.0457361 48:-0.0445799 49:0 50:0 51:0.683632 52:0.622346 53:0.62209''' 


#
# FIXME: end of code which should be removed
#




def petuum_mlr_sample_data_to_numpy_matrix (num_labels, feature_dim, petuum_mlr_sample):
    
    line_list = petuum_mlr_sample.splitlines()
    matrix_as_line_list_of_value_list = list (l.split() for l in line_list)
    
    matrix_as_np_array = np.array(matrix_as_line_list_of_value_list, dtype=float)
    assert matrix_as_np_array.shape == (num_labels, feature_dim), "Inconsistent shape for input matrix: %s" + petuum_mlr_sample
    
    return matrix_as_np_array

def distance_between (x_raw_dense_matrix, target_raw_dense_matrix, num_labels, feature_dim):

   
    c_minus_b = x_raw_dense_matrix - target_raw_dense_matrix
    m_square = np.square (c_minus_b)
    s = m_square.sum()
    
    norm1 = math.sqrt (s)
    
    # version 2
    
    norm2 = LA.norm(c_minus_b)
    

    return norm2

if __name__ == '__main__':
    
    num_labels, feature_dim, m1_string_without_feature_index = tmp_build_real_input_matrix_string(petuum_m1)    
    sample_data_as_np_matrix = petuum_mlr_sample_data_to_numpy_matrix(num_labels, feature_dim, m1_string_without_feature_index)
    
    num_labels, feature_dim, m2_string_without_feature_index = tmp_build_real_input_matrix_string(petuum_m2)
    final_learning_sample_data_as_np_matrix = petuum_mlr_sample_data_to_numpy_matrix(num_labels, feature_dim, m2_string_without_feature_index)
    
    r_test_1 = distance_between (num_labels, feature_dim, sample_data_as_np_matrix, final_learning_sample_data_as_np_matrix)
    
    print (r_test_1)
    
    m1_basic = np.array ([[1,1,1],[1,1,1]],dtype=float)
    m2_basic = np.array ([[2,2,2],[2,2,2]],dtype=float)
    
    r_simple = distance_between (num_labels=2, feature_dim=3, x_raw_dense_matrix=m1_basic, target_raw_dense_matrix=m2_basic)
    
    

